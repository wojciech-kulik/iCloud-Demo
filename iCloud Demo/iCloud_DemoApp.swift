//
//  iCloud_DemoApp.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI

@main
struct iCloud_DemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink(
                        "CloudKit + CoreData",
                        destination: CloudKitView()
                            .navigationTitle("CloudKit + CoreData")
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    )
                    NavigationLink(
                        "CloudKit",
                        destination: CloudKitRawView()
                            .navigationTitle("CloudKit")
                    )
                    NavigationLink(
                        "iCloud Documents",
                        destination: CloudDocumentsView()
                            .navigationTitle("iCloud Documents")
                    )
                    NavigationLink(
                        "Key-Value Storage",
                        destination: KeyValueStorageView()
                            .navigationTitle("Key-Value Storage")
                    )
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("iCloud Demo") // SwiftUI bug - constraints conflict
            }
        }
    }
}
