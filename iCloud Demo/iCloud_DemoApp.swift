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
                VStack {
                    NavigationLink(
                        "CloudKit",
                        destination: CloudKitView()
                            .navigationTitle("CloudKit")
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    )
                    .font(.system(size: 24))
                    .padding(.top, 8)
                    Spacer()
                }
                .navigationBarTitle("iCloud Demo", displayMode: .inline)
                .padding()
            }
        }
    }
}
