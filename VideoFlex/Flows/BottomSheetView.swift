//
//  BottomSheetView.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/8/22.
//

import SwiftUI

/// Custom bottom sheet view
struct BottomSheetView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var startEnterAnimation: Bool = false
    @State private var startExitAnimation: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .opacity(startEnterAnimation ? (startExitAnimation ? 0 : 0.8) : 0)
                .onTapGesture { exitFlow() }
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    VStack(spacing: 15) {
                        VideoPreviewContainer
                        switch manager.videoToolType {
                        case .regular: AudioFileTypeSelector
                        case .videoGIF: FramesPerSecondSlider
                        case .mergeVideos: MergeVideosCollection
                        }
                        Color.backgroundColor.frame(height: 1).opacity(0.5).padding(.horizontal)
                    }.padding(.top)
                    PrimaryActionButton
                    DisclaimerText
                }
                .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.extraDarkGrayColor).ignoresSafeArea())
                .offset(y: startEnterAnimation ? (startExitAnimation ? UIScreen.main.bounds.height : 0) : UIScreen.main.bounds.height)
            }
        }
        /// Initial configurations when the view appears
        .onAppear {
            if startEnterAnimation == false {
                withAnimation { startEnterAnimation = true }
            }
        }
    }
    
    /// Exit flow action
    private func exitFlow(convert: Bool = false) {
        withAnimation { startExitAnimation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.manager.showBottomSheet = false
            if convert { self.manager.convertSelectedAsset() }
        }
    }
    
    // MARK: - Selected Video Preview
    private var VideoPreviewContainer: some View {
        let isPortrait = manager.selectedVideoThumbnail?.isPortrait ?? false
        return VStack(spacing: 15) {
            Text(manager.videoToolType.title).font(.system(size: 18, weight: .semibold))
            Color.backgroundColor.frame(height: 1).opacity(0.5).padding(.horizontal)
            Color.darkGrayColor.cornerRadius(15).frame(width: isPortrait ? 160 : 250, height: isPortrait ? 200 : 150).overlay(
                ZStack {
                    if let thumbnail = manager.selectedVideoThumbnail {
                        Image(uiImage: thumbnail).resizable().aspectRatio(contentMode: .fill)
                        Button { manager.playSelectedVideo() } label: {
                            Image(systemName: "play.circle.fill").foregroundColor(.white).opacity(0.75).font(.system(size: 45))
                        }
                    }
                }
            ).clipShape(RoundedRectangle(cornerRadius: 15)).contentShape(Rectangle())
            Color.backgroundColor.frame(height: 1).opacity(0.5).padding(.horizontal)
        }.frame(maxWidth: .infinity)
    }
    
    // MARK: - Audio File type selector
    private var AudioFileTypeSelector: some View {
        HStack(spacing: 5) {
            ForEach(AudioFileType.allCases) { type in
                Button { manager.selectedAudioFileType = type } label: {
                    Text(type.rawValue.uppercased()).font(.system(size: 14, weight: .semibold))
                        .foregroundColor(manager.selectedAudioFileType == type ? .white : .accentLightColor)
                        .padding(.vertical, 10).padding(.horizontal, 10).background(
                            ZStack {
                                if manager.selectedAudioFileType == type {
                                    Color.accentLightColor
                                }
                            }
                        ).cornerRadius(8)
                }
            }
        }.frame(height: 40)
    }
    
    // MARK: - Frames per second slider
    private var FramesPerSecondSlider: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Frames Per Second").font(.system(size: 12, weight: .light))
                Spacer()
                Text("\(Int(manager.framesPerSecond))").font(.system(size: 14))
            }
            Slider(value: $manager.framesPerSecond, in: 5...Float(AppConfig.videoGIFMaxFramesPerSecond), step: 1)
                .accentColor(.accentLightColor)
        }.padding(.horizontal)
    }
    
    // MARK: - Merge Videos collection
    private var MergeVideosCollection: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer(minLength: 20)
                    ForEach(0..<manager.mergeVideoThumbnails.count, id: \.self) { index in
                        Image(uiImage: manager.mergeVideoThumbnails[index]).resizable()
                            .aspectRatio(contentMode: .fill).frame(width: 40, height: 40)
                            .clipShape(Rectangle()).onTapGesture {
                                manager.selectedVideoThumbnail = manager.mergeVideoThumbnails[index]
                            }
                    }
                    Button {
                        manager.showPhotoPicker = true
                    } label: {
                        Image(systemName: "plus.square.fill")
                            .resizable().aspectRatio(contentMode: .fit)
                            .foregroundColor(.white).padding(.leading)
                    }
                }.frame(height: 40)
            }
            Toggle(isOn: $manager.mergeVideoPortrait) {
                Text("Portrait Orientation").font(.system(size: 12, weight: .light))
            }
            .padding(.horizontal)
            .toggleStyle(SwitchToggleStyle(tint: .accentLightColor))
        }
    }
    
    // MARK: - Primary Action Button
    private var PrimaryActionButton: some View {
        Button { exitFlow(convert: true) } label: {
            ZStack {
                Color.accentLightColor.cornerRadius(12)
                Text(manager.videoToolType == .mergeVideos ? "Merge Videos" : "Convert")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
        }.frame(height: 50).padding(.horizontal)
    }
    
    // MARK: - Disclaimer view
    private var DisclaimerText: some View {
        Text("All files are processed on device.\nThis app doesn't collect any of your data.")
            .multilineTextAlignment(.center).font(.system(size: 10, weight: .light))
            .foregroundColor(.gray)
    }
}

// MARK: - Preview UI
struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        manager.videoToolType = .mergeVideos
        return BottomSheetView().environmentObject(manager)
    }
}

