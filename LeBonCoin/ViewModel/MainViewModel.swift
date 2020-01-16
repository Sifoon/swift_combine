//
//  ListViewModel.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 09/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation
import Combine
import CoreData

class MainViewModel : ObservableObject {
    
    
    private var cancellables: [AnyCancellable] = []
    

    private let responseSubject = PassthroughSubject<Data, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var fetchTemperature: APIServiceType?
    private let userLocation: UserLocationService

    
       init(userLocation: UserLocationService = UserLocationService()) {
            self.userLocation = userLocation
            getGeoLocalisation()

       }

    func getGeoLocalisation () {
        self.userLocation.getLocation(
                completionHandler: ({
                    resutl in
                    print(resutl)
                    let locationResponse = ["response" : resutl as UserLocationResponse]
                    NotificationCenter.default.post(name: .geoLocStatus, object: nil, userInfo: locationResponse)
                    
                }))
        
    }
    
    func getTemperaturesWs(location : Location){
        self.fetchTemperature = APIService(location: location)
        self.bindOutputs()
        self.bindInputs()
    }
    
    
    private func bindInputs() {
        
            let responsePublisher = self.fetchTemperature!.response()
                .catch { [weak self] error -> Empty<Data, Never> in
                    self?.errorSubject.send(error)
                    return .init()
            }
            
            let responseStream = responsePublisher
                .share()
                .subscribe(responseSubject)
            
           
            cancellables += [
                responseStream,
            ]
        }
        
        private func bindOutputs() {
            let temperaturesFeed = responseSubject
            .sink(receiveValue: { value in
                print(value)
                self.saveInBackGroundAndSendResponse(value)
            })
            
            let errorMessageStream = errorSubject
                .map { error -> String in
                    switch error {
                    case .parsing(let city):
                        return city
                    case .network(let description):
                        return description
                    }
                }
            .sink(receiveValue: { value in
                self.getSavedTemperatures(city: value == "network" ? nil : value)
                
            })
            
           
            cancellables += [
                temperaturesFeed,
                errorMessageStream
            ]
        }
    
    
    func saveInBackGroundAndSendResponse(_ temps : Data){
         
            do {
                    let tempsModel = try JSONDecoder().decode(Temperatures.self, from: temps)
                    PersistanceService.saveContext(context: PersistanceService.context!)
                    let response = ["status": FluxStatus.newFeed, "response" : tempsModel] as [String : Any]
                    NotificationCenter.default.post(name: .newTemperatures, object: nil, userInfo: response)
                }
            catch
                {
                    self.getSavedTemperatures(city: nil)
                }
               
    }
    
    
    func getSavedTemperatures( city : String? ) {
        // if we have city string we search if we have saved Temperatures with city else return last saved Temperatures to show at least a result for user
        
        let prService = PersistanceService()
        var savedTemperature: Temperatures?
        
        if city != nil {
            if let temperaturesByCity = prService.fetchTemperaturesWithCity(city: city!) {
                if temperaturesByCity.count > 0{
                    savedTemperature = temperaturesByCity.first
                }else {
                    if let allTemperatures =  prService.fetchAllTemperatures() {
                        savedTemperature = allTemperatures.count > 0 ? allTemperatures.last! : nil
                    }
                }
        }
        }else {
            if let allTemperatures =  prService.fetchAllTemperatures() {
                       savedTemperature = allTemperatures.count > 0 ? allTemperatures.last! : nil
                   }
        }
        NotificationCenter.default.post(name: savedTemperature != nil ? .newTemperatures : .noTemperatureToShow, object: nil, userInfo: savedTemperature != nil ? ["status": FluxStatus.oldFeed, "response" : savedTemperature! ] : nil)
    }
    
    
    
    
    
    
}



            
