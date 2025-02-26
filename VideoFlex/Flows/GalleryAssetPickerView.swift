//
//  GalleryAssetPickerView.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import PhotosUI
import SwiftUI

/// Video and Photo asset picker view
struct GalleryAssetPickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @State var videoMaximumDuration: Double?
    let didSelectVideo: ((_ video: AVAsset?) -> Void)?

    func makeUIViewController(context: UIViewControllerRepresentableContext<GalleryAssetPickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = true

        if let duration = videoMaximumDuration {
            picker.videoMaximumDuration = duration
        }

        A.s.send(event: Events.AppPresentedScreen(screen: .gallery))

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: GalleryAssetPickerView
        init(_ parent: GalleryAssetPickerView) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let videoURL = info[.mediaURL] as? URL {
                parent.didSelectVideo?(AVAsset(url: videoURL))
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
