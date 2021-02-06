//
//  CloudService.swift
//  iCloud Demo
//
//  Created by Wojciech Kulik on 06/02/2021.
//

import Foundation

final class CloudService {
    enum CloudError: Error {
        case cloudSyncDisabled
        case cloudDisabled
        case couldNotAccessCloud
        case cloudFileDoesNotExist
        case couldNotReadContent
        case unknown(Error)
    }

    private enum Constants {
        static let cloudDirectory = "Documents"
        static let cloudSyncFileName = "cloud_file.txt"
    }

    var cloudContentDidUpdate: (() -> ())?

    private(set) var cloudContent = "" {
        didSet { cloudContentDidUpdate?() }
    }

    private var cloudUrl: URL? {
        FileManager.default
            .url(forUbiquityContainerIdentifier: nil)?
            .appendingPathComponent(Constants.cloudDirectory)
            .appendingPathComponent(Constants.cloudSyncFileName)
    }
    private var lastSyncDate: Date?
    private var cloudObserver: NSObjectProtocol?

    private let iCloudQuery = NSMetadataQuery()

    init() {
        downloadFile()
        observeCloudFile()
        print("Cloud URL: \(cloudUrl!)")
    }

    deinit {
        if let cloudObserver = cloudObserver {
            NotificationCenter.default.removeObserver(cloudObserver)
        }
        iCloudQuery.stop()
    }

    private func observeCloudFile() {
        if let cloudObserver = cloudObserver {
            NotificationCenter.default.removeObserver(cloudObserver)
        }

        cloudObserver = NotificationCenter.default.addObserver(
            forName: .NSMetadataQueryDidUpdate,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.downloadFile()
        }

        iCloudQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        iCloudQuery.predicate = NSPredicate(
            format: "(%K = %@ AND %K = %@)",
            NSMetadataItemFSNameKey,
            Constants.cloudSyncFileName,
            NSMetadataUbiquitousItemDownloadingStatusKey,
            NSMetadataUbiquitousItemDownloadingStatusCurrent
        )

        iCloudQuery.enableUpdates()
        iCloudQuery.start()

        if let cloudUrl = cloudUrl {
            try? FileManager.default.startDownloadingUbiquitousItem(at: cloudUrl)
        }
    }
}

extension CloudService {
    var isCloudEnabled: Bool { FileManager.default.ubiquityIdentityToken != nil }

    func clear() {
        lastSyncDate = nil
    }

    func getCloudDatabaseModificationDate() -> Date? {
        guard let cloudUrl = cloudUrl, FileManager.default.fileExists(atPath: cloudUrl.path) else { return nil }

        return try? FileManager.default.attributesOfItem(atPath: cloudUrl.path)[.modificationDate] as? Date
    }

    @discardableResult
    func uploadFile(content: String) -> Result<Void, CloudError> {
        guard isCloudEnabled else { return .failure(.cloudDisabled) }
        guard let cloudUrl = cloudUrl else { return .failure(.couldNotAccessCloud) }

        do {
            guard let data = content.data(using: .utf8) else { return .failure(.couldNotReadContent) }

            try data.write(to: cloudUrl)
            lastSyncDate = getCloudDatabaseModificationDate() ?? Date()
            print("--> Uploaded File")

            return .success(())
        } catch {
            return .failure(.unknown(error))
        }
    }

    @discardableResult
    func downloadFile() -> Result<String, CloudError> {
        guard isCloudEnabled else { return .failure(.cloudDisabled) }
        guard let cloudUrl = cloudUrl else { return .failure(.couldNotAccessCloud) }
        guard FileManager.default.fileExists(atPath: cloudUrl.path) else { return .failure(.cloudFileDoesNotExist) }

        do {
            guard let cloudFileDate = getCloudDatabaseModificationDate(), cloudFileDate != lastSyncDate else {
                return .success(cloudContent)
            }

            lastSyncDate = cloudFileDate
            cloudContent = try String(contentsOf: cloudUrl)
            print("--> Downloaded File")

            return .success(cloudContent)
        } catch {
            return .failure(.unknown(error))
        }
    }
}
