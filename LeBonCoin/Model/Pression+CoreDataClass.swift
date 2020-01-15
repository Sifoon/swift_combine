//
//  Pression+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pression)
public class Pression: NSManagedObject , Decodable {

    
    @NSManaged public var seaLevel: Int32
    @NSManaged public var pression: Temperature?

    enum CodingKeys: String, CodingKey {
           case seaLevel = "niveau_de_la_mer"
       }
    
    
    // MARK: - Decodable
          required convenience public init(from decoder: Decoder) throws {
              guard let managedObjectContext =  PersistanceService.context,
              let entity = NSEntityDescription.entity(forEntityName: "Pression", in: managedObjectContext)
                  else {
                  fatalError("Failed to decode Pression")
              }

              self.init(entity: entity, insertInto: managedObjectContext)

              let container = try decoder.container(keyedBy: CodingKeys.self)
           self.seaLevel = Int32(try (container.decodeIfPresent(Float.self, forKey: .seaLevel) ?? 0))
             
          }

}
