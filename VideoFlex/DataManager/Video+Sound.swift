//
//  Video+Sound.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/8/22.
//

import AVKit
import Foundation

// MARK: - Supported audio file type

enum AudioFileType: String, Identifiable, CaseIterable {
    case m4a, wav, caf
    var id: Int { hashValue }

    /// Export file type
    var fileType: AVFileType {
        switch self {
        case .m4a: return .m4a
        case .caf: return .caf
        case .wav: return .wav
        }
    }
}

// MARK: - Convert Video to Audio file

extension DataManager {
    /// Convert video asset to audio file
    func extractAudio(from video: AVAsset?) {
        guard let asset = video else {
            presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
            return
        }

        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documentsDirectoryPath.appending("/audio-\(Date().string(format: "MM-dd_HH-mm-ss")).\(selectedAudioFileType)")

        guard let assetReader = try? AVAssetReader(asset: asset),
              let assetWriter = try? AVAssetWriter(outputURL: URL(fileURLWithPath: path), fileType: selectedAudioFileType.fileType),
              let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first
        else {
            presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
            return
        }

        let audioSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM, AVSampleRateKey: 22050.0,
            AVNumberOfChannelsKey: 1, AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false, AVLinearPCMIsBigEndianKey: false, AVLinearPCMIsNonInterleaved: false,
        ]

        let assetReaderAudioOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: audioSettings)

        if assetReader.canAdd(assetReaderAudioOutput) {
            assetReader.add(assetReaderAudioOutput)
        } else {
            presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
        }

        let audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioSettings)
        let audioInputQueue = DispatchQueue(label: "audioQueue")
        assetWriter.add(audioInput)
        assetWriter.startWriting()
        assetReader.startReading()
        assetWriter.startSession(atSourceTime: CMTime.zero)

        showLoadingView = true

        audioInput.requestMediaDataWhenReady(on: audioInputQueue) {
            while audioInput.isReadyForMoreMediaData {
                if let sample = assetReaderAudioOutput.copyNextSampleBuffer() {
                    audioInput.append(sample)
                } else {
                    audioInput.markAsFinished()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        assetWriter.finishWriting {
                            assetReader.cancelReading()
                        }
                        self.showLoadingView = false
                        let controller = UIActivityViewController(activityItems: [URL(fileURLWithPath: path)], applicationActivities: nil)
                        controller.completionWithItemsHandler = { _, _, _, _ in
                            self.shareSheetShow = false
                        }
                        self.shareSheetShow = true
                        rootController?.present(controller, animated: true)
                        self.fetchFilesHistory()
                    }
                    break
                }
            }
        }
    }
}
