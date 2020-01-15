//
//  Pression+CoreDataProperties.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData


extension Pression {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pression> {
        return NSFetchRequest<Pression>(entityName: "Pression")
    }


}
