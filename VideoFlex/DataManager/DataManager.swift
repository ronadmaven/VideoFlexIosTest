//
//  DataManager.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import AVKit
import Photos
import SwiftUI
import ImageIO
import Foundation
import AVFoundation
import MobileCoreServices

/// Main data manager for the app
class DataManager: NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var fullScreenMode: FullScreenMode?
    @Published var videoToolType: VideoToolType = .regular
    @Published var filesHistory: [URL] = [URL]()
    @Published var framesPerSecond: Float = 10.0
    @Published var mergeVideoPortrait: Bool = false
    @Published var mergeVideoThumbnails: [UIImage] = [UIImage]()
    @Published var selectedVideoThumbnail: UIImage?
    @Published var selectedAudioFileType: AudioFileType = .m4a
    @Published var showPhotoPicker: Bool = false
    @Published var showLoadingView: Bool = false
    @Published var showBottomSheet: Bool = false
    @Published var showFilePreview: Bool = false
    @Published var selectedFileURL: URL?
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage(AppConfig.premiumVersion) var isPremiumUser: Bool = false {
        didSet { Interstitial.shared.isPremiumUser = isPremiumUser }
    }
    
    /// Internal properties
    internal var mergeVideoAssets: [AVAsset] = [AVAsset]()
    internal var selectedVideoAsset: AVAsset?

    /// Default initializer
    override init() {
        super.init()
        fetchFilesHistory()
    }
}

// MARK: - Handle selected video asset
extension DataManager: UIDocumentPickerDelegate {
    
    /// Handle selected asset from Photo gallery or Files app
    func handleSelectedAsset(_ videoAsset: AVAsset?) {
        guard let asset = videoAsset else {
            presentAlert(title: "Oops!", message: "This video is not supported")
            return
        }
        showPhotoPicker = false
        selectedVideoAsset = asset
        asset.generateThumbnail { thumbnail in
            DispatchQueue.main.async {
                if self.videoToolType == .mergeVideos, let thumbnailImage = thumbnail {
                    self.mergeVideoThumbnails.append(thumbnailImage)
                    self.mergeVideoAssets.append(asset)
                }
                self.selectedVideoThumbnail = thumbnail
                self.showBottomSheet = true
            }
        }
    }
    
    /// Document picker controller
    func documentViewController() -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [
            .movie, .mpeg4Movie, .mpeg4Movie, .quickTimeMovie, .appleProtectedMPEG4Video
        ])
        controller.allowsMultipleSelection = false
        controller.delegate = self
        return controller
    }
    
    /// Handle selected image files from Files iOS app
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        guard fileURL.startAccessingSecurityScopedResource() else { return }
        defer { fileURL.stopAccessingSecurityScopedResource() }
        fullScreenMode = nil
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let path = documentsDirectoryPath.appending(fileURL.lastPathComponent)
        do {
            try Data(contentsOf: fileURL).write(to: URL(fileURLWithPath: path))
            self.handleSelectedAsset(AVAsset(url: URL(fileURLWithPath: path)))
        } catch let error {
            presentAlert(title: "Oops!", message: error.localizedDescription)
        }
    }
}

// MARK: - Manage converted files history
extension DataManager {
    
    /// Fetch converted files to audio and merged videos
    func fetchFilesHistory() {
        filesHistory.removeAll()
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let directoryContents = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        var files: [URL] = [URL]()
        directoryContents?.forEach { fileURL in
            if fileURL.lastPathComponent.starts(with: "video-") || fileURL.lastPathComponent.starts(with: "audio-") {
                files.append(fileURL)
            }
        }
        DispatchQueue.main.async {
            self.filesHistory = files.sorted(by: { $0.lastPathComponent > $1.lastPathComponent })
        }
    }
    
    /// Delete file for a given URL
    func deleteFile(atIndex index: Int) {
        do {
            try FileManager.default.removeItem(at: filesHistory[index])
            DispatchQueue.main.async { self.filesHistory.remove(at: index) }
        } catch let error {
            presentAlert(title: "Oops!", message: error.localizedDescription)
        }
    }
}

// MARK: - Play Selected video
extension DataManager {
    
    /// Play current video
    func playSelectedVideo() {
        guard let asset = selectedVideoAsset else { return }
        let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        rootController?.present(playerViewController, animated: true, completion: {
            playerViewController.player?.play()
        })
    }
}

// MARK: - Convert Selected video
extension DataManager {
    
    /// Convert/Merge selected asset(s)
    func convertSelectedAsset() {
        guard let asset = selectedVideoAsset else { return }
        switch videoToolType {
        case .regular: extractAudio(from: asset)
        case .videoGIF: createGIF(from: asset)
        case .mergeVideos: mergeVideos(portrait: mergeVideoPortrait)
        }
    }
}
