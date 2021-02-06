//
//  CloudDocumentsViewModel.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import SwiftUI

final class CloudDocumentsViewModel: ObservableObject {
    @Published var content: String = "" {
        didSet {
            guard shouldUploadOnChange else { return }
            uploadFile()
        }
    }

    private var shouldUploadOnChange = true
    private let cloudService = CloudService()

    init() {
        setContent(cloudService.cloudContent)
        cloudService.cloudContentDidUpdate = { [weak self] in
            self?.setContent(self?.cloudService.cloudContent ?? "")
        }
    }

    func uploadFile() {
        cloudService.uploadFile(content: content)
    }

    private func setContent(_ content: String) {
        shouldUploadOnChange = false
        self.content = content
        shouldUploadOnChange = true
    }
}
