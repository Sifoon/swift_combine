//
//  Wind+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Wind)
public class Wind: NSManagedObject , Decodable {

    
    
    @NSManaged public var windDirection: Float
    @NSManaged public var mediumWins: Float
    @NSManaged public var windGusts: Float
    @NSManaged public var wind: Temperature?
    
    
    enum CodingKeys: String, CodingKey {
        case windDirection = "vent_direction"
        case mediumWins = "vent_moyen"
        case windGusts = "vent_rafales"
    }
    
    // MARK: - Decodable
       required convenience public init(from decoder: Decoder) throws {
           guard let managedObjectContext =  PersistanceService.context,
           let entity = NSEntityDescription.entity(forEntityName: "Wind", in: managedObjectContext)
               else {
               fatalError("Failed to decode Wind")
           }

           self.init(entity: entity, insertInto: managedObjectContext)

           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.windDirection = try (container.decodeIfPresent(Float.self, forKey: .windDirection) ?? 0.0)
           self.mediumWins = try (container.decodeIfPresent(Float.self, forKey: .mediumWins) ?? 0.0)
           self.windGusts = try (container.decodeIfPresent(Float.self, forKey: .windGusts) ?? 0.0)
       }

}
