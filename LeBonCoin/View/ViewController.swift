//
//  ViewController.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 03/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import UIKit
import Combine
import CoreLocation


enum StoryNeedTo {
    case simulateGeoloc
    case showOldTemperatures
    case askForCity
}

enum FluxStatus {
    case newFeed 
    case oldFeed
}

enum LocationSubkectError: Error {
    case noLocation
    case noLocationWithCity(city: String)
}

class ViewController: UIViewController {
   
    @IBOutlet var gelocStatusImage: UIImageView!
    @IBOutlet weak var internetStatusImage: UIImageView!
    @IBOutlet weak var simulateButton: UIButton!
    @IBOutlet weak var explinationTextView: UITextView!
    @IBOutlet weak var newSynchro: UILabel!
    @IBOutlet weak var newSynchroImage: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var viewModel: MainViewModel?
    
    let locationForWsTemperaturesSubject = PassthroughSubject<Location, LocationSubkectError>()
    let didreceivedNewValueSubkect = PassthroughSubject<Bool, Never>()

    private var cancellables: [AnyCancellable] = []
    
    var loction : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simulateButton.isHidden = true
        explinationTextView.isHidden = true
        
        newSynchro.isHidden = true
        newSynchroImage.isHidden = true
        
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTemperatureFromWs(_:)), name: .newTemperatures, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.noTemperaturesToShow(_:)), name: .noTemperatureToShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.geoLocStatus(_:)), name: .geoLocStatus, object: nil)
    
        
        setUpPublisher()
        viewModel = MainViewModel()
    }
    
    func setUpPublisher(){
        let locationForWsTemperaturesPublisher = locationForWsTemperaturesSubject
             .receive(on: RunLoop.main)
             .eraseToAnyPublisher()
             
                
        let locationForWsTemperaturesPublisherCancellable = locationForWsTemperaturesPublisher
            .sink(receiveCompletion: { completion in
             switch completion {
             case .finished:
                 break
             case .failure(let error):
                 switch error {
                     case .noLocation:
                        self.didreceivedNewValueSubkect.send(completion : .finished)
                        self.viewModel?.getSavedTemperatures(city: nil)
                        break
                     case .noLocationWithCity(let city):
                        self.didreceivedNewValueSubkect.send(completion : .finished)
                        self.viewModel?.getSavedTemperatures(city: city)
                        break
                 }
             }
         }, receiveValue: { location in
             self.viewModel?.getTemperaturesWs(location: location)
         })
        
        
        let didreceivedNewValuePublisher = didreceivedNewValueSubkect
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
        let didreceivedNewValuePublisherCancellable = didreceivedNewValuePublisher.sink(receiveValue: { reveivedFromWS in
            if reveivedFromWS {
                self.newSynchro.isHidden = false
                self.newSynchroImage.isHidden = false
            }
        })
            
         cancellables += [
            locationForWsTemperaturesPublisherCancellable,
            didreceivedNewValuePublisherCancellable
         ]
    
    }
    
    
    @objc
    func geoLocStatus(_ notification:Notification) {
        guard let userLocationResponse = notification.userInfo?["response"] as? UserLocationResponse  else {
            return
        }
        
        self.loction = userLocationResponse.location
        
        switch userLocationResponse.authorization {
        case .authorized:
            gelocStatusImage.image = UIImage(named: "check_sign")
            internetStatusImage.image = UIImage(named: "check_sign")
            self.locationForWsTemperaturesSubject.send(userLocationResponse.location)
            break
        case .notAuthorized:
            gelocStatusImage.image = UIImage(named: "uncheck_sign")
            storyNeedToAction(storyNeedTo: .simulateGeoloc, location :userLocationResponse.location)
            break
        case .notDetermined:
            gelocStatusImage.image = UIImage(named: "uncheck_sign")
            break
        case .couldntReverseGeoloc:
            gelocStatusImage.image = UIImage(named: "check_sign")
            internetStatusImage.image = UIImage(named: "uncheck_sign")
            storyNeedToAction(storyNeedTo: .askForCity, location :userLocationResponse.location)
            break
            
        }
        
    }
    
    @objc
    func getTemperatureFromWs(_ notification:Notification) {
        print(Thread.isMainThread)
        if let temperatures = notification.userInfo?["response"] as? Temperatures{
            
            self.simulateButton.isHidden = false
            self.simulateButton.setTitle("Voir les Temperatures", for: .normal)
            
            if let status = notification.userInfo?["status"] as? FluxStatus {
                switch status {
                case .newFeed:
                    didreceivedNewValueSubkect.send(true)
                case .oldFeed:
                    didreceivedNewValueSubkect.send(false)
                    self.explinationTextView.text = " Nous n'avions pas réussi a synchroniser ! Voila les dernière valeurs enregistré "
                    self.explinationTextView.isHidden = false
                    internetStatusImage.image = UIImage(named: "uncheck_sign")
                }
            }

            
            
            Singleton.shared.temperatures = temperatures
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "splitVU")
            self.present(controller, animated: true, completion: nil)            }
            
        
    }
    
    
    @objc
    func noTemperaturesToShow(_ notification:Notification) {
        self.simulateButton.setTitle("Réessayer", for: .normal)
        self.simulateButton.isHidden = false
        explinationTextView.isHidden = false
        explinationTextView.text = "Nous n'avions pas réussi a chercher la température! Vous devez synchroniser au moins une fois pour visualiser sans internet"
    }
    
    
    @IBAction func simulateButtonTapped(_ sender: Any) {
        if(Singleton.shared.temperatures != nil ){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "splitVU")
            self.present(controller, animated: true, completion: nil)
        }else {
            self.viewModel?.getTemperaturesWs(location: self.loction!)
        }
    }
    
    
    private func storyNeedToAction ( storyNeedTo: StoryNeedTo , location : Location){
        
        switch storyNeedTo {
            case .simulateGeoloc:
                askIfShowSimulation(location)
                break
            case .showOldTemperatures:
                self.locationForWsTemperaturesSubject.send(completion: .failure(.noLocation))
                break
            case .askForCity:
                askForCity(location)
                break
        }
    }
    
    func askIfShowSimulation( _ location : Location){
        
               let alert = UIAlertController(title: "Géolocalisation", message: "Nous n'avions pas réussi à récupérer votre géolocalisation! voulez vous simulez la ville de Paris", preferredStyle: .alert)
               
               alert.addAction(UIAlertAction(title: "Simulate", style: .default, handler: { [weak alert] (_) in
                    self.locationForWsTemperaturesSubject.send(location)
               }))
               self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func askForCity( _ location : Location){
        
               let alert = UIAlertController(title: "Ville", message: "Nous n'avions pas réussi à récupérer votre ville! Veuillez l'introduire pour recherche la dernière synchronisation pour cette ville? Ou vous pouvez récupérer la dernière synchronisation faite ? ", preferredStyle: .alert)
               alert.addTextField { (textField) in
                    textField.placeholder = "Paris"
               }
               alert.addAction(UIAlertAction(title: "Ville", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    location.city = textField!.text
                    self.locationForWsTemperaturesSubject.send(completion: .failure(.noLocationWithCity(city: textField!.text!)))
               }))
                alert.addAction(UIAlertAction(title: "Dernière", style: .cancel, handler: { [weak alert] (_) in
                    self.locationForWsTemperaturesSubject.send(completion: .failure(.noLocation))
                }))
               self.present(alert, animated: true, completion: nil)
        
    }
}
extension Notification.Name {
    static let newTemperatures = Notification.Name("new_flux_temperatures")
    static let geoLocStatus = Notification.Name("geo_loc_status")
    static let noTemperatureToShow = Notification.Name("no_temps_to_show")
}
