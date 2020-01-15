//
//  Temperatures+CoreDataProperties.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 11/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//
//

import Foundation
import CoreData


extension Temperatures {

    @nonobjc public class func fetchRequestTemperatures() -> NSFetchRequest<Temperatures> {
        return NSFetchRequest<Temperatures>(entityName: "Temperatures")
    }

    
}

// MARK: Generated accessors for temperatures
extension Temperatures {

    @objc(insertObject:inTemperaturesAtIndex:)
    @NSManaged public func insertIntoTemperatures(_ value: Temperature, at idx: Int)

    @objc(removeObjectFromTemperaturesAtIndex:)
    @NSManaged public func removeFromTemperatures(at idx: Int)

    @objc(insertTemperatures:atIndexes:)
    @NSManaged public func insertIntoTemperatures(_ values: [Temperature], at indexes: NSIndexSet)

    @objc(removeTemperaturesAtIndexes:)
    @NSManaged public func removeFromTemperatures(at indexes: NSIndexSet)

    @objc(replaceObjectInTemperaturesAtIndex:withObject:)
    @NSManaged public func replaceTemperatures(at idx: Int, with value: Temperature)

    @objc(replaceTemperaturesAtIndexes:withTemperatures:)
    @NSManaged public func replaceTemperatures(at indexes: NSIndexSet, with values: [Temperature])

    @objc(addTemperaturesObject:)
    @NSManaged public func addToTemperatures(_ value: Temperature)

    @objc(removeTemperaturesObject:)
    @NSManaged public func removeFromTemperatures(_ value: Temperature)

    @objc(addTemperatures:)
    @NSManaged public func addToTemperatures(_ values: NSOrderedSet)

    @objc(removeTemperatures:)
    @NSManaged public func removeFromTemperatures(_ values: NSOrderedSet)

}
