//  UserLocationService.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 10/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class UserLocationService : NSObject, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
     private var cancellables: [AnyCancellable] = []
    let subject = PassthroughSubject<UserLocationResponse, Never>()
    let publisher : AnyPublisher<UserLocationResponse, Never>
    
    var location : Location!
    override init() {
        publisher = subject.eraseToAnyPublisher()
        location = Location(context: PersistanceService.context!)
        location.city = "Paris"
        location.lat = 48.856697
        location.long = 2.351462
    }
    
    func getLocation( completionHandler: ((UserLocationResponse) -> Void)?) -> Void {
    
        let subscriber1 = publisher.sink(receiveCompletion: { _ in
            print("finished")
        }, receiveValue: { value in
            print(value)
           completionHandler?(value)
        })
        
        
          let status = CLLocationManager.authorizationStatus()
         
          switch status {
          case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                    let ulr = UserLocationResponse(authorization: UserLocationAuthorization.notDetermined, location: self.location)
                    subject.send(ulr)
                break
          case .denied, .restricted:
                    let ulr = UserLocationResponse(authorization: UserLocationAuthorization.notAuthorized, location: self.location)
                        subject.send(ulr)
                break
          case .authorizedAlways, .authorizedWhenInUse:
            
              break
          @unknown default:
                    let ulr = UserLocationResponse(authorization:  UserLocationAuthorization.notAuthorized, location: self.location)
                    subject.send(ulr)
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        cancellables += [
              subscriber1,
          ]
        
        
       }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
              print("location manager authorization status changed")
          }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            let geoCoder = CLGeocoder()
            var ulr = UserLocationResponse(authorization: .notAuthorized, location: self.location)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if error == nil  {
                    placemarks?.forEach { (placemark) in
                                       if let city = placemark.locality {
                                            self.location.lat = location.coordinate.latitude
                                            self.location.long = location.coordinate.longitude
                                            self.location.city = city
                                            ulr.authorization = .authorized
                                            self.subject.send(ulr)
                                            self.subject.send(completion: .finished)

                                       }
                                   }
                } else {
                    self.location.city = "UNKNOWN"
                    self.location.lat = location.coordinate.latitude
                    self.location.long = location.coordinate.longitude
                    ulr.authorization = .couldntReverseGeoloc
                    self.subject.send(ulr)
                }
                
                
               
            })
           
            
            
        } else {
            let ulr = UserLocationResponse(authorization: UserLocationAuthorization.notAuthorized, location: location)
                subject.send(ulr)
        }
    }
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {

        print("error with location manager: " + error.description)
        let ulr = UserLocationResponse(authorization: UserLocationAuthorization.authorized, location: self.location)
        self.subject.send(ulr)
    }
}
