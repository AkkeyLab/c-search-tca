//
//  CompanyAddressEntity+CoreDataClass.swift
//  c-search
//
//  Created by AkkeyLab on 2023/03/05.
//
//

import Foundation
import CoreData

@objc(CompanyAddressEntity)
public class CompanyAddressEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyAddressEntity> {
        return NSFetchRequest<CompanyAddressEntity>(entityName: "CompanyAddressEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}
