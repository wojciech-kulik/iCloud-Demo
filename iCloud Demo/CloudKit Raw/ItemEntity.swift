//
//  ItemEntity.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 08/02/2021.
//

import CloudKit

struct ItemEntity: Hashable {
    let recordName: String
    let timestamp: Date
}

extension ItemEntity {
    init?(from record: CKRecord) {
        guard let timestamp = record["timestamp"] as? Date else { return nil }

        self.recordName = record.recordID.recordName
        self.timestamp = timestamp
    }

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Item")
        record["timestamp"] = timestamp

        return record
    }
}
