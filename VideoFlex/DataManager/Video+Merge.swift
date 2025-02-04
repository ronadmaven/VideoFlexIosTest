//
//  Video+Merge.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/8/22.
//

import AVKit
import UIKit
import Foundation

// MARK: - Merge Multiple Videos
extension DataManager {
    
    /// Merge all videos into 1 video file
    func mergeVideos(portrait: Bool) {
        guard mergeVideoAssets.count > 1 else {
            presentAlert(title: "Oops!", message: "You need at least 2 videos to merge")
            return
        }
        
        var insertTime: CMTime = .zero
        var arrayLayerInstructions: [AVMutableVideoCompositionLayerInstruction] = []
        
        let defaultResolution: CGSize = AppConfig.mergedVideoResolution
        let portraitResolution: CGSize = CGSize(width: defaultResolution.height, height: defaultResolution.width)
        let videoResolution: CGSize = portrait ? portraitResolution : defaultResolution
        let mixComposition = AVMutableComposition()
        
        for videoAsset in mergeVideoAssets {
            guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { continue }

            var audioTrack: AVAssetTrack?
            if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
                audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
            }
            
            let videoComposition = mixComposition.addMutableTrack(withMediaType: AVMediaType.video,
                                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let audioComposition = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                       preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            
            let startTime = CMTime.zero
            let duration = videoAsset.duration
            try? videoComposition?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration), of: videoTrack, at: insertTime)

            if let audioTrack = audioTrack {
                try? audioComposition?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: duration), of: audioTrack, at: insertTime)
            }

            if let videoCompositionTrack = videoComposition {
                let layerInstruction = videoCompositionInstructionForTrack(track: videoCompositionTrack, asset: videoAsset, targetSize: videoResolution)
                let endTime = CMTimeAdd(insertTime, duration)
                layerInstruction.setOpacity(0, at: endTime)
                arrayLayerInstructions.append(layerInstruction)
            }

            insertTime = CMTimeAdd(insertTime, duration)
        }
        
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: insertTime)
        mainInstruction.layerInstructions = arrayLayerInstructions
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = videoResolution
        
        /// Export merged video to URL
        guard let exportSession = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
            presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
            return
        }
        
        showLoadingView = true
        
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documentsDirectoryPath.appending("/video-\(Date().string(format: "MM-dd_HH-mm-ss")).mp4")
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = URL(fileURLWithPath: path)
        exportSession.videoComposition = mainComposition
        exportSession.exportAsynchronously {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showLoadingView = false
                switch exportSession.status {
                case .completed:
                    let controller = UIActivityViewController(activityItems: [URL(fileURLWithPath: path)], applicationActivities: nil)
                    rootController?.present(controller, animated: true)
                    self.fetchFilesHistory()
                default:
                    presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
                }
            }
        }
    }
    
    /// Create video composition instruction
    private func videoCompositionInstructionForTrack(track: AVCompositionTrack?, asset: AVAsset, targetSize: CGSize) -> AVMutableVideoCompositionLayerInstruction {
        
        guard let track = track else { return AVMutableVideoCompositionLayerInstruction() }
        
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        let transform = assetTrack.fixedPreferredTransform
        let assetInfo = orientationFromTransform(transform)
        var scaleToFitRatio = targetSize.width / assetTrack.naturalSize.width
        
        if assetInfo.isPortrait {
            scaleToFitRatio = targetSize.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            let newY = targetSize.height/2 - (assetTrack.naturalSize.width * scaleToFitRatio)/2
            let moveCenterFactor = CGAffineTransform(translationX: 0, y: newY)
            let finalTransform = transform.concatenating(scaleFactor).concatenating(moveCenterFactor)
            instruction.setTransform(finalTransform, at: .zero)
        } else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            let newY = targetSize.height/2 - (assetTrack.naturalSize.height * scaleToFitRatio)/2
            let moveCenterFactor = CGAffineTransform(translationX: 0, y: newY)
            let finalTransform = transform.concatenating(scaleFactor).concatenating(moveCenterFactor)
            instruction.setTransform(finalTransform, at: .zero)
        }

        return instruction
    }
    
    /// Get asset orientation
    private func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        
        switch [transform.a, transform.b, transform.c, transform.d] {
        case [0.0, 1.0, -1.0, 0.0]:
            assetOrientation = .right
            isPortrait = true
            
        case [0.0, -1.0, 1.0, 0.0]:
            assetOrientation = .left
            isPortrait = true
            
        case [1.0, 0.0, 0.0, 1.0]:
            assetOrientation = .up
            
        case [-1.0, 0.0, 0.0, -1.0]:
            assetOrientation = .down

        default:
            break
        }
    
        return (assetOrientation, isPortrait)
    }
}

// MARK: - Useful AV extensions
extension AVAssetTrack {
    var fixedPreferredTransform: CGAffineTransform {
        var updatedTransform = preferredTransform
        switch [updatedTransform.a, updatedTransform.b, updatedTransform.c, updatedTransform.d] {
        case [1, 0, 0, 1]:
            updatedTransform.tx = 0
            updatedTransform.ty = 0
        case [1, 0, 0, -1]:
            updatedTransform.tx = 0
            updatedTransform.ty = naturalSize.height
        case [-1, 0, 0, 1]:
            updatedTransform.tx = naturalSize.width
            updatedTransform.ty = 0
        case [-1, 0, 0, -1]:
            updatedTransform.tx = naturalSize.width
            updatedTransform.ty = naturalSize.height
        case [0, -1, 1, 0]:
            updatedTransform.tx = 0
            updatedTransform.ty = naturalSize.width
        case [0, 1, -1, 0]:
            updatedTransform.tx = naturalSize.height
            updatedTransform.ty = 0
        case [0, 1, 1, 0]:
            updatedTransform.tx = 0
            updatedTransform.ty = 0
        case [0, -1, -1, 0]:
            updatedTransform.tx = naturalSize.height
            updatedTransform.ty = naturalSize.width
        default:
            break
        }
        return updatedTransform
    }
}

extension AVAsset {
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            imageGenerator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension UIImage {
    var isPortrait: Bool {
        size.height > size.width
    }
}

