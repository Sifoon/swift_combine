//
//  Degree+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Degree)
public class Degree: NSManagedObject , Decodable {


    
    @NSManaged public var ground: Float
    @NSManaged public var temp2M: Float
    @NSManaged public var temp500HPa: Float
    @NSManaged public var temp850HPa: Float
    @NSManaged public var degree: Temperature?
    
    
    enum CodingKeys: String, CodingKey {
        case temp2M = "2m"
        case ground = "sol"
        case temp500HPa = "500hPa"
        case temp850HPa = "850hPa"
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext =  PersistanceService.context,
        let entity = NSEntityDescription.entity(forEntityName: "Degree", in: managedObjectContext)
            else {
            fatalError("Failed to decode Degree")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.ground = try (container.decodeIfPresent(Float.self, forKey: .ground) ?? 0)
      self.temp2M = try (container.decodeIfPresent(Float.self, forKey: .temp2M) ?? 0)
      self.temp500HPa = try (container.decodeIfPresent(Float.self, forKey: .temp500HPa) ?? 0)
      self.temp850HPa = try (container.decodeIfPresent(Float.self, forKey: .temp850HPa) ?? 0)

       
    }


}
