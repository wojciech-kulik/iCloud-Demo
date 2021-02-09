//
//  CoreDataController.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import CoreData

struct CoreDataController {
    static let shared = CoreDataController()

    let container: NSPersistentCloudKitContainer

    init() {
        // CloudKit container based on *.xcdatamodeld file name
        container = NSPersistentCloudKitContainer(name: "iCloud_Demo")

        // Path to local mirror of CloudKit database
        let cloudStoreLocation = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("cloud.store")

        // iCloud container configuration
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: AppConstants.cloudContainerId
        )
        container.persistentStoreDescriptions = [cloudStoreDescription]

        // Automatic sync
        container.viewContext.automaticallyMergesChangesFromParent = true

        // Load DB
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
