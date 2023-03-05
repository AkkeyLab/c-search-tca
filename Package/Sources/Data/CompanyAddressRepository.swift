//
//  CompanyAddressRepository.swift
//  
//
//  Created by AkkeyLab on 2023/03/05.
//

import CoreData

public final class CompanyAddressRepository {
    // https://blog.ch3cooh.jp/entry/2022/01/03/210300
    private let modelFileURL = Bundle.module.url(forResource: "Model", withExtension: "momd")!
    private lazy var container = NSPersistentContainer(
        name: String(describing: type(of: CompanyAddressRepository.self)),
        managedObjectModel: NSManagedObjectModel(contentsOf: modelFileURL)!
    )

    public static let shared = CompanyAddressRepository()

    private init() {
        container.loadPersistentStores { _, _ in }
    }

    public func load<T: CompanyAddressEntity>() throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        return try container.viewContext.fetch(request)
    }

    public func append(address: String, latitude: Double, longitude: Double) throws {
        let description = NSEntityDescription.entity(
            forEntityName: String(describing: CompanyAddressEntity.self),
            in: container.viewContext
        )
        guard let description else {
            assertionFailure()
            return
        }
        let entity = CompanyAddressEntity(entity: description, insertInto: nil)
        entity.address = address
        entity.latitude = latitude
        entity.longitude = longitude
        container.viewContext.insert(entity)
    }

    public func saveIfNeeded() throws {
        guard container.viewContext.hasChanges else { return }
        try container.viewContext.save()
    }
}
