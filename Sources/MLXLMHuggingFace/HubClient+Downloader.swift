import Foundation
import HuggingFace
import MLXLMCommon

public enum HuggingFaceDownloaderError: LocalizedError {
    case invalidRepositoryID(String)

    public var errorDescription: String? {
        switch self {
        case .invalidRepositoryID(let id):
            return "Invalid Hugging Face repository ID: '\(id)'. Expected format 'namespace/name'."
        }
    }
}

extension HubClient: @retroactive Downloader {

    public func download(
        id: String,
        revision: String?,
        matching patterns: [String],
        useLatest: Bool,
        progressHandler: @Sendable @escaping (Progress) -> Void
    ) async throws -> URL {
        guard let repoID = Repo.ID(rawValue: id) else {
            throw HuggingFaceDownloaderError.invalidRepositoryID(id)
        }
        let revision = revision ?? "main"

        // TODO: Add a cache fast path in swift-huggingface and use it here when useLatest is false,
        // to avoid a network round-trip for already-cached snapshots.
        return try await downloadSnapshot(
            of: repoID,
            revision: revision,
            matching: patterns,
            progressHandler: { @MainActor progress in
                progressHandler(progress)
            }
        )
    }
}
