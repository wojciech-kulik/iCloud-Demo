//
//  KeyValueStorageViewModel.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI

final class KeyValueStorageViewModel: ObservableObject {
    @Published var isEnabled = false {
        didSet {
            userDefaults.set(isEnabled, forKey: "isEnabled")
        }
    }

    let userDefaults = NSUbiquitousKeyValueStore()

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUpdate),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil
        )
        userDefaults.synchronize()

        isEnabled = userDefaults.bool(forKey: "isEnabled")
    }

    @objc private func didUpdate() {
        isEnabled = userDefaults.bool(forKey: "isEnabled")
    }
}
