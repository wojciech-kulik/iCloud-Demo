//
//  CloudKitRawViewModel.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI
import CloudKit

final class CloudKitRawViewModel: ObservableObject {
    @Published var items: [ItemEntity] = []

    private let privateDatabase = CKContainer(identifier: "iCloud.pl.wojciechkulik.icloud-demo").privateCloudDatabase
    private let publicDatabase = CKContainer(identifier: "iCloud.pl.wojciechkulik.icloud-demo").publicCloudDatabase

    init() {
        fetchItems()
    }

    func addItem() {
        let record = ItemEntity(recordName: "", timestamp: Date()).toRecord()

        publicDatabase.save(record) { [weak self] result, error in
            if let error = error {
                print(error)
            }

            if let result = result {
                print(result)

                DispatchQueue.main.async {
                    guard let self = self, let entity = ItemEntity(from: result) else { return }
                    self.items = (self.items + [entity]).sorted { $0.timestamp > $1.timestamp }
                }
            }
        }
    }

    func deleteItems(indexes: IndexSet) {
        let recordsToDelete = indexes.map { items[$0].recordName }
        
        items = items.filter { !recordsToDelete.contains($0.recordName) }

        recordsToDelete.forEach {
            publicDatabase.delete(withRecordID: CKRecord.ID(recordName: $0)) { result, error in
                if let error = error {
                    print(error)
                }
                if let result = result {
                    print(result)
                }
            }
        }
    }

    func fetchItems() {
        let query = CKQuery(recordType: "Item", predicate: NSPredicate(value: true))

        publicDatabase.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
            guard let results = results else { return }
            guard let self = self else { return }
            if let error = error { return print(error) }

            DispatchQueue.main.async {
                self.items = results.compactMap(ItemEntity.init).sorted { $0.timestamp > $1.timestamp }
            }
        }
    }
}
