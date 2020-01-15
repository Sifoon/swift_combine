//
//  APIService.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 10/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation
import Combine



protocol APIServiceType {
    func response() -> AnyPublisher<Data, APIServiceError>
}

final class APIService: APIServiceType {
    
    var location : Location! 
    init(location : Location) {
        self.location = location
    }

    func response() -> AnyPublisher<Data, APIServiceError>  {
    
       // let pathURL = URL(string: request.path, relativeTo: baseURL)!
        let pathURL = URL(string: "https://www.infoclimat.fr/public-api/gfs/json?_ll=\(self.location.lat),\(self.location.long)&_auth=BhxRRg9xV3VTflFmUyVXflQ8ATQAdgYhBHgEZ104USxUP1Q1AmJRN14wB3oPIAUzVXhTMA80CDgLYAd%2FAHJQMQZsUT0PZFcwUzxRNFN8V3xUYgFiADYGOgRgBHxdL1E7VDVULgJoUTNeLwdkDz0FNVV4UzIPMwgxC3cHfwBsUDYGYlE9D2xXMFM9UTFTYFdmVHgBfgA6BmsEZwQ1XTJRNFRmVDMCM1ExXmAHNw9qBTZVeFM2DzIINgtoB2YAblA3BmRRKg9zV0xTT1EuUyNXIVQyAScAIgZrBDkENw%3D%3D&_c=ae08e25263c63bd99c4a52177fb7d20e")!
        
        

        let urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let decorder = JSONDecoder()
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, urlResponse in
                let jsonData = self.conformeWsResponseToDataCoreModelWith(location: self.location , data)
                return jsonData ?? data
             } 
            .mapError { _ in APIServiceError.network(description: "network") }
            .mapError{_  in APIServiceError.parsing(city: self.location.city!)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func conformeWsResponseToDataCoreModelWith( location : Location,  _ data: Data ) -> Data? {
         
             var returnedData = data
             do {
                 if let jsonDataArray = try? JSONSerialization.jsonObject(with: returnedData, options: []) as? [String: AnyObject] {
                      
                     var temperaturesByDates: [[String: AnyObject]] = []
                        for (key, subJson) in jsonDataArray {
                                
                                if((DateFormatter.yyyyMMdd.date(from:key)) != nil){
                                    let tempByday  = createConformeDictionaryForCoreData(key: key, subJson: subJson as! [String : Any])
                                            temperaturesByDates.append(tempByday as [String : AnyObject])
                                            
                                   }
                               }
                    
                    let sortedTemperaturesByDates = sortByDateTime(dict: temperaturesByDates)
                    let dataCoreDictionnary = [
                    "location": [
                        "city": location.city as Any,
                        "lat":location.lat,
                        "long":location.long],
                    "temperatures":
                     sortedTemperaturesByDates ] as [String: Any]

                     do {
                         returnedData = try JSONSerialization.data(withJSONObject: dataCoreDictionnary, options: .prettyPrinted)
                         
                     } catch {
                         print(error.localizedDescription)
                     }
                     
                 }
                
             }
             
         return returnedData
     
     
 }
    
    func sortByDateTime (dict : [[String: AnyObject]]) -> [[String: AnyObject]]{
        
        let formatter = DateFormatter.yyyyMMdd
        
        let myArrayOfTuples = dict.sorted{
            guard let d1 = formatter.date(from: $0["date"] as! String) , let d2 = formatter.date(from: $1["date"]as! String) else { return false }
            return d1 < d2
        }
        return myArrayOfTuples
    }
    
    func createConformeDictionaryForCoreData (key : String , subJson : [String : Any]) -> Dictionary<String, Any>{
        let nebulosite = subJson["nebulosite"] as! Dictionary<String, Any>
        let cloudiness = [
            "moyenne":nebulosite["moyenne"] ?? 0,
            "haute":nebulosite["haute"] ?? 0 ,
            "basse":nebulosite["basse"] ?? 0 ,
            "totale":nebulosite["totale"] ?? 0
        ]
        
        let tempsDict = subJson["temperature"] as! Dictionary<String, Any>
        let degree =  [ "sol":tempsDict["sol"] ?? 0,
                        "2m":tempsDict["2m"] ?? 0,
                        "500hPa":tempsDict["500hPa"] ?? 0,
                        "850hPa":tempsDict["850hPa"] ?? 0
                        ]
        
        
        let pressionJson = subJson["pression"]  as? Dictionary<String, Any>
        let pression = [ "niveau_de_la_mer": pressionJson!["niveau_de_la_mer"]
        ]
        
        
        let windDire = subJson["vent_direction"]  as? Dictionary<String, Any>
        let winfMoyen = subJson["vent_moyen"]  as? Dictionary<String, Any>
        let windRafale = subJson["vent_rafales"]  as? Dictionary<String, Any>
        let wind = [ "vent_direction": windDire!["10m"],
              "vent_moyen":winfMoyen!["10m"],
              "vent_rafales":windRafale!["10m"]
        ]
        
        let humidite = subJson["humidite"] as! Dictionary<String, Any>
                
        let tempByday = ["date" : key,
                       "cape": subJson["cape"],
                       "pluie_convective":subJson["pluie_convective"],
                       "pluie":subJson["pluie"],
                      "iso_zero":subJson["iso_zero"],
                      "humidite":humidite["2m"],
                      "risque_neige":subJson["risque_neige"],
                      "nebulosite":
                                cloudiness
                          ,
                      "degree":
                                degree
                      ,
                      "pression":
                                pression
                        ,
                      "wind":
                                wind
        ]
        
        return tempByday as Dictionary<String, Any>
    }
    
}







 
 
 
   
     
   
   
   
 
 
 
