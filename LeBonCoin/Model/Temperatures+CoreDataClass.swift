//
//  Temperatures+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Temperatures)
public class Temperatures: NSManagedObject, Decodable  {

    @NSManaged public var location: Location?
    @NSManaged public var temperatures: NSOrderedSet?

    
    
    enum CodingKeys: String, CodingKey {
        case location
        case temperatures
      }
    
    
    // MARK: - Decodable
          required convenience public init(from decoder: Decoder) throws {
               guard let managedObjectContext =  PersistanceService.context,
                        let entity = NSEntityDescription.entity(forEntityName: "Temperatures", in: managedObjectContext)
                            else {
                            fatalError("Failed to decode Temperatures")
                        }

                self.init(entity: entity, insertInto: managedObjectContext)

                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.location = try container.decodeIfPresent(Location.self, forKey: .location)
                let arrayTemps: [Temperature] = try container.decode([Temperature].self, forKey: .temperatures)
                self.temperatures = NSOrderedSet(array:arrayTemps)
          }
}
