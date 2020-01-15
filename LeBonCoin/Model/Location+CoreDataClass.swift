//
//  Location+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject, Decodable {

    
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var city: String?
    @NSManaged public var location: Temperatures?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case long
        case city
        case location
    }
    
    // MARK: - Decodable
             required convenience public init(from decoder: Decoder) throws {
                  guard let managedObjectContext =  PersistanceService.context,
                           let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext)
                               else {
                               fatalError("Failed to decode Location")
                           }

                 self.init(entity: entity, insertInto: managedObjectContext)

                 let container = try decoder.container(keyedBy: CodingKeys.self)
                
                self.lat = (try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0)
                self.long = (try container.decodeIfPresent(Double.self, forKey: .long) ?? 0)
                self.city = try container.decodeIfPresent(String.self, forKey: .city)?.lowercased()
                self.location = try container.decodeIfPresent(Temperatures.self, forKey: .location)

             }
}
