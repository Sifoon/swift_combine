//
//  Degree+CoreDataProperties.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData


extension Degree {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Degree> {
        return NSFetchRequest<Degree>(entityName: "Degree")
    }

}
