//
//  Temperature+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Temperature)
public class Temperature: NSManagedObject, Decodable {

    
    @NSManaged public var cape: Int16
    @NSManaged public var convectiveRain: Float
    @NSManaged public var humidity: Float
    @NSManaged public var isoZero: Int32
    @NSManaged public var rain: Float
    @NSManaged public var snowRisk: Bool
    @NSManaged public var date: Date
    @NSManaged public var cloudiness: Cloudiness?
    @NSManaged public var degree: Degree?
    @NSManaged public var pression: Pression?
    @NSManaged public var wind: Wind?
    @NSManaged public var tempetures: Temperatures?
    
    
    enum CodingKeys: String, CodingKey {
           case degree
           case date
           case pression
           case rain = "pluie"
           case convectiveRain = "pluie_convective"
           case humidity = "humidite"
           case mediumWind = "vent_moyen"
           case windGusts = "vent_rafales"
           case windDirection = "vent_direction"
           case isoZero = "iso_zero"
           case snowRisk = "risque_neige"
           case cape
           case cloudiness = "nebulosite"
           case wind
       }
    
    
    // MARK: - Decodable
         required convenience public init(from decoder: Decoder) throws {
             guard let managedObjectContext =  PersistanceService.context,
             let entity = NSEntityDescription.entity(forEntityName: "Temperature", in: managedObjectContext)
                 else {
                 fatalError("Failed to decode Temperature")
             }

             self.init(entity: entity, insertInto: managedObjectContext)

             let container = try decoder.container(keyedBy: CodingKeys.self)
            
            
            let formatter = DateFormatter.yyyyMMdd
            let dateString = try (container.decodeIfPresent(String.self, forKey: .date) ?? formatter.string(from: Date()) as String )
            if let date = formatter.date(from: dateString) {
                self.date = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .date,
                      in: container,
                      debugDescription: "Date string does not match format expected by formatter.")
            }
            
           self.convectiveRain = try (container.decodeIfPresent(Float.self, forKey: .convectiveRain) ?? 0.0)
           self.humidity = try (container.decodeIfPresent(Float.self, forKey: .humidity) ?? 0.0)
           self.isoZero = Int32(try (container.decodeIfPresent(Int.self, forKey: .isoZero) ?? 0))
           self.rain = try (container.decodeIfPresent(Float.self, forKey: .rain) ?? 0.0)
           self.snowRisk = try container.decode(String.self, forKey: .snowRisk) == "oui" ? true : false
           //self.snowRisk = try (container.decodeIfPresent(Bool.self, forKey: .snowRisk) ?? false)

           self.cloudiness = try container.decodeIfPresent(Cloudiness.self, forKey: .cloudiness)
           self.degree = try container.decodeIfPresent(Degree.self, forKey: .degree)
           self.pression = try container.decodeIfPresent(Pression.self, forKey: .pression)
           self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
         }
}


extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"  //2020-01-10 19:00:00
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: +1)
    formatter.locale = Locale(identifier: "FR.fr")
    return formatter
  }()
}
