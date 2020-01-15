//
//  Cloudiness+CoreDataClass.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Cloudiness)
public class Cloudiness: NSManagedObject,  Decodable {

   
    
    @NSManaged public var average: Int16
    @NSManaged public var hight: Int16
    @NSManaged public var low: Int16
    @NSManaged public var total: Int16
    @NSManaged public var cloudiness: Temperature?
    
   enum CodingKeys: String, CodingKey {
       case hight = "haute"
       case average = "moyenne"
       case low = "basse"
       case total = "totale"
   }
    
    // MARK: - Decodable
           required convenience public init(from decoder: Decoder) throws {
               guard let managedObjectContext =  PersistanceService.context,
               let entity = NSEntityDescription.entity(forEntityName: "Cloudiness", in: managedObjectContext)
                   else {
                   fatalError("Failed to decode Cloudiness")
               }

               self.init(entity: entity, insertInto: managedObjectContext)

             let container = try decoder.container(keyedBy: CodingKeys.self)
             self.average = Int16(try (container.decodeIfPresent(Float.self, forKey: .average) ?? 0))
             self.hight = Int16(try (container.decodeIfPresent(Float.self, forKey: .hight) ?? 0))
             self.low = Int16(try (container.decodeIfPresent(Float.self, forKey: .low) ?? 0))
             self.total = Int16(try (container.decodeIfPresent(Float.self, forKey: .total) ?? 0))

              
               }

}
