//
//  DashboardContentView.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import SDK
import SwiftUI
/// Main dashboard for the app
struct DashboardContentView: View {
    @EnvironmentObject var sdk: TheSDK
    @EnvironmentObject var manager: DataManager
    @Environment(\.isSubscribed) var isSubscribed: Bool

    @State var showSettings: Bool = false

    // MARK: - Main rendering function

    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            BgCircleView()
            VStack {
                CustomHeaderView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ImportMediaSectionView
                        OtherToolsView
                        ConvertedFilesView
                    }
                }
            }

            /// Show bottom sheet for file conversion and tools
            if manager.showBottomSheet && manager.selectedVideoThumbnail != nil {
                BottomSheetView().environmentObject(manager)
            }

            /// Show loading view and file preview
            LoadingView(isLoading: $manager.showLoadingView)
                .background(FilePreview($manager.showFilePreview, url: manager.selectedFileURL))
        }
        .onChange(of: manager.fullScreenMode) { newValue in
            switch newValue {
            case .premium:
                sdk.presentSDKView(page: .unlockContent, show: .init(get: {
                    true
                }, set: { _ in
                    if manager.fullScreenMode == .premium {
                        manager.fullScreenMode = nil
                    }
                }))
            case .settings:
                showSettings = true

            default: break
            }
        }
        .fullScreenCover(isPresented: $showSettings, content: {
            SettingsContentView(show: .init(get: {
                showSettings
            }, set: { _ in
                showSettings = false
                manager.fullScreenMode = nil
            }))

        })

        /// Modal flow presentation
        .sheet(isPresented: $manager.showPhotoPicker) {
            GalleryAssetPickerView(videoMaximumDuration: manager.videoToolType.videoDuration) { video in
                manager.handleSelectedAsset(video)
            }
        }
    }

    // MARK: - Section header title

    private func SectionHeader(title: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom(Fonts.UbuntuMedium, size: 18, relativeTo: .headline))
                    .foregroundColor(.lightGrayColor)
            }
            Spacer()
        }
    }

    /// Custom header view
    private var CustomHeaderView: some View {
        HStack {
            Image("Logo")
            VStack(alignment: .leading, spacing: 8) {
                Text("VideoFlex").font(.custom(Fonts.UbuntuBold, size: 26, relativeTo: .largeTitle))
                    .foregroundColor(.lightBlueColor)
                Text("Video to Audio Convertor").foregroundColor(.lightGrayColor)
                    .font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .headline))
            }.foregroundColor(.white)
            Spacer()
            Button { manager.fullScreenMode = .settings } label: {
                Image(systemName: "gearshape").foregroundColor(.white)
                    .font(.system(size: 24, weight: .light))
            }
        } // .padding(.top,10)
        .padding(.bottom)
        .padding(.horizontal, 10)
    }

    // MARK: - Import media section

    private var ImportMediaSectionView: some View {
        VStack(spacing: 15) {
            SectionHeader(title: "Import Media")
            VStack(spacing: 15) {
                MediaImportTool(title: "From File") {
                    manager.videoToolType = .regular
                    rootController?.present(manager.documentViewController(), animated: true)
                }
                MediaImportTool(title: "From Photo") {
                    manager.videoToolType = .regular
                    manager.showPhotoPicker = true
                }
            }
        }.padding()
            .background(
                NoBorderRectangle()
            )
            .padding(.horizontal)
    }

    /// Media import tool view
    private func MediaImportTool(title: String, action: @escaping () -> Void) -> some View {
        Button { action() } label: {
            HStack {
                Image("\(title)").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .center)
                Text(title.capitalized)
                    .font(.custom(Fonts.UbuntuBold, size: 20, relativeTo: .headline))
                    .foregroundColor(.lightGrayColor)
                    .padding(.leading)
                Spacer()
                Image("\(title)_right").resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: .center)
            }.padding().frame(maxWidth: .infinity).background(
                BorderedRectangle()
            )
        }
    }

    // MARK: - Other tools

    private var OtherToolsView: some View {
        VStack {
            SectionHeader(title: "Other Tools")
            HStack(spacing: 10) {
                OtherTool(title: "Video to GIF") {
                    manager.videoToolType = .videoGIF
                    manager.showPhotoPicker = true
                }
                OtherTool(title: "Merge Videos") {
                    manager.mergeVideoThumbnails.removeAll()
                    manager.mergeVideoAssets.removeAll()
                    manager.videoToolType = .mergeVideos
                    manager.showPhotoPicker = true
                }
            }.overlay(PremiumOverlay)
        }.padding().background(
            NoBorderRectangle()
        ).padding(.horizontal)
    }

    /// Other tool view
    private func OtherTool(title: String, action: @escaping () -> Void) -> some View {
        Button { action() } label: {
            VStack {
                Image(title).resizable().aspectRatio(contentMode: .fit)
                    .frame(height: 40, alignment: .center)
                    .padding()
                Text(title)
                    .font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .body))
                    .foregroundColor(.lightGrayColor)
                    .padding(.bottom)
            }.padding().frame(maxWidth: .infinity).background(
                BorderedRectangle()
            )
        }.opacity(isSubscribed ? 1 : 0.1).disabled(!isSubscribed)
    }

    /// Premium features overlay
    private var PremiumOverlay: some View {
        ZStack {
            if !isSubscribed {
                VStack {
                    Spacer()
                    Image("Premium").font(.system(size: 27))
                        .padding(.horizontal, 25)
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.backgroundColor)
                                .shadow(radius: 6, x: 0, y: 3)
                        )
                    Spacer()
                    Text("Premium Features").font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .body))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(
                            RoundedCorner(radius: 20, corners: [.bottomLeft, .topRight])
                                .foregroundColor(.backgroundColor)
                        )
                        .offset(y: 25)
                        .shadow(radius: 6, y: 3)
                }
                .foregroundColor(.lightGrayColor)
                .onTapGesture {
                    sdk.presentSDKView(page: .unlockContent, show: nil)
                }
            }
        }
    }

    // MARK: - Converted files

    private var ConvertedFilesView: some View {
        VStack {
            SectionHeader(title: "Converted Files")
            LazyVStack {
                ForEach(0 ..< manager.filesHistory.count, id: \.self) { index in
                    Button {
                        manager.selectedFileURL = manager.filesHistory[index]
                        manager.showFilePreview = true
                    } label: {
                        FileHistoryItem(atIndex: index)
                    }
                }
            }
            EmptyFilesListView
        }.padding().background(
            NoBorderRectangle()
        ).padding(.horizontal)
            .padding(.top, 10)
    }

    /// File history item view
    private func FileHistoryItem(atIndex index: Int) -> some View {
        HStack {
            Image(systemName: manager.filesHistory[index].lastPathComponent.contains("video") ? "film" : "music.note.list")
                .resizable().aspectRatio(contentMode: .fit).frame(width: 20, height: 20)
            Text(manager.filesHistory[index].lastPathComponent).lineLimit(1)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Button {
                presentAlert(title: "Delete File", message: "Are you sure you want to delete this file?", primaryAction: .Cancel, secondaryAction: .init(title: "Delete", style: .destructive, handler: { _ in
                    manager.deleteFile(atIndex: index)
                }))
            } label: {
                Image(systemName: "trash.fill")
            }
        }.foregroundColor(.lightGrayColor).padding(10).background(
            BorderedRectangle()
        )
    }

    /// Empty converted files list
    private var EmptyFilesListView: some View {
        ZStack {
            if manager.filesHistory.count == 0 {
                VStack {
                    Image("NoFiles")
                    Text("No Files Yet").padding(.top, 2)
                        .font(.custom(Fonts.UbuntuMedium, size: 20, relativeTo: .headline))
                        .foregroundColor(.lightGrayColor)
                        .padding(.all, 8)
                    Text("You don't have any converted files").opacity(0.7)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.lightGrayColor)
                        .font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .body))
                }.font(.system(size: 20, weight: .semibold)).padding(.vertical, 40)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                BorderedRectangle()
                    .frame(width: nil)
            )
    }

//    /// Premium in-app purchases view
//    private var PremiumView: some View {
//        PremiumContentView(title: "Premium Version", subtitle: "Unlock All Features", features: ["Video to GIF", "Merge Videos", "Remove Ads"], productIds: [AppConfig.premiumVersion]) {
//            manager.fullScreenMode = nil
//        } completion: { _, status, _ in
//            DispatchQueue.main.async {
//                if status == .success || status == .restored {
//                    manager.isPremiumUser = true
//                }
//            }
//        }
//    }
}

// MARK: - Preview UI

struct DashboardContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = DataManager()
        return DashboardContentView()
            .environmentObject(manager)
            .environmentObject(TheSDK(config: .init(baseURL: Config.serverURL)))
            .environment(\.isSubscribed, true)
    }
}
