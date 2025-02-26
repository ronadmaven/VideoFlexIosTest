//
//  VideoFlexApp.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import CommonSwiftUI
import SDK
import SwiftUI

class UserState: ObservableObject {
    @Published var debug: Bool = false
}

@main
struct VideoFlexApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var showDashboard: Bool = false
    @State var launchScreen: AnyView?
    @StateObject var userSettings: UserState = .init()
    @StateObject private var manager: DataManager = DataManager()
    @StateObject var sdk: TheSDK = .init(config: .init(baseURL: Config.serverURL,
                                                       appsFlyer: (appId: Config.appId, devKey: Config.appsFlyerDevKey),
                                                       logOptions: .none,
                                                       manageNotifications: true))

    init() {
        RateusAlert.rules = .init(minSecondsBetweenPresentations: 24 * 60 * 60, rateByAppVersion: true)

        A.s.addSubVendor(SDKAnalyticsVendor(sdk: sdk))

        KeyChainUtil.set(value: sdk.userId, forKey: "userId")
    }

    // MARK: - Main rendering function

    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    if let launchScreen {
                        launchScreen
                    } else {
                        Color.clear
                    }
                }
            }
            .environment(\.isSubscribed, sdk.isSubsccribed)
            .environmentObject(sdk)
            .environmentObject(manager)
            .environmentObject(userSettings)
            .onFirstAppear {
                if wasLaunchedFromNotification {
                    launchScreen = AnyView(DashboardContentView())
                } else {
                    launchScreen = AnyView(SplashScreen())
                }
            }
        }
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// Show a loading indicator view
struct LoadingView: View {
    @Binding var isLoading: Bool

    // MARK: - Main rendering function

    var body: some View {
        ZStack {
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all).opacity(0.4)
                ProgressView("please wait...")
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10).opacity(0.7))
            }
        }.colorScheme(.light)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

struct FilePreview: UIViewControllerRepresentable {
    private var isActive: Binding<Bool>
    private let viewController = UIViewController()
    private let documentController: UIDocumentInteractionController

    init(_ isActive: Binding<Bool>, url: URL?) {
        self.isActive = isActive
        documentController = UIDocumentInteractionController(url: url ?? URL(fileURLWithPath: ""))
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<FilePreview>) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<FilePreview>) {
        if isActive.wrappedValue && documentController.delegate == nil {
            documentController.delegate = context.coordinator
            documentController.presentPreview(animated: true)
        }
    }

    func makeCoordinator() -> Coordintor {
        return Coordintor(owner: self)
    }

    final class Coordintor: NSObject, UIDocumentInteractionControllerDelegate {
        let owner: FilePreview
        init(owner: FilePreview) { self.owner = owner }

        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return owner.viewController
        }

        func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
            controller.delegate = nil
            owner.isActive.wrappedValue = false
        }
    }
}
