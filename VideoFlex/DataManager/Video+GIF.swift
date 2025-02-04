//
//  Video+GIF.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/8/22.
//

import Photos
import SwiftUI
import ImageIO
import Foundation
import AVFoundation
import MobileCoreServices

// MARK: - Convert Video to GIF
extension DataManager {
    
    /// Convert video asset to animated GIF
    func createGIF(from video: AVAsset?) {
        guard let asset = video else {
            presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
            return
        }
        
        showLoadingView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let duration = asset.duration
            let videoLength = duration
            let seconds = CMTimeGetSeconds(videoLength)
            let framesPerSecond = Float(self.framesPerSecond)
            let framesCount = Int(seconds * Double(framesPerSecond))
            let step = videoLength.value / Int64(framesCount)
            var value = CMTimeValue.init(0.0)
            var videoImageFrames = [UIImage]()

            for _ in 0..<framesCount {
                let assetImageGenerator : AVAssetImageGenerator = AVAssetImageGenerator.init(asset: asset)
                assetImageGenerator.requestedTimeToleranceAfter = CMTime.zero
                assetImageGenerator.requestedTimeToleranceBefore = CMTime.zero
                assetImageGenerator.appliesPreferredTrackTransform = true
                let time : CMTime = CMTime(value: value, timescale: videoLength.timescale)
                if let videoFrame = try? assetImageGenerator.copyCGImage(at: time, actualTime: nil) {
                    videoImageFrames.append(UIImage(cgImage: videoFrame))
                    value = value + step
                }
            }
            
            if videoImageFrames.count > 0 {
                self.generateAnimatedGIF(from: videoImageFrames, delay: AppConfig.videoGIFMaxDuration/Double(framesCount))
            } else {
                self.showLoadingView = false
                presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
            }
        }
    }
    
    /// Build animated GIF from images
    func generateAnimatedGIF(from photos: [UIImage], delay: Double) {
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documentsDirectoryPath.appending("/animated.gif")
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: delay]]
        let cfURL = URL(fileURLWithPath: path) as CFURL
        
        if let destination = CGImageDestinationCreateWithURL(cfURL, kUTTypeGIF, photos.count, nil) {
            CGImageDestinationSetProperties(destination, fileProperties as CFDictionary?)
            for photo in photos {
                CGImageDestinationAddImage(destination, photo.cgImage!, gifProperties as CFDictionary?)
            }
            if CGImageDestinationFinalize(destination) {
                PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .photo, fileURL: URL(fileURLWithPath: path), options: nil)
                } completionHandler: { _, error in
                    DispatchQueue.main.async {
                        self.showLoadingView = false
                        if let errorMessage = error?.localizedDescription {
                            presentAlert(title: "Oops!", message: errorMessage)
                        } else {
                            presentAlert(title: "Saved!", message: "Your Animated GIF has been saved into the Photos app")
                        }
                    }
                }
                return
            }
        }
        
        DispatchQueue.main.async { self.showLoadingView = false }
        presentAlert(title: "Oops!", message: "Something went wrong\nPlease try again later")
    }
}
