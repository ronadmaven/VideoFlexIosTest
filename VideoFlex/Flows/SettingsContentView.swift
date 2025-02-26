//
//  SettingsContentView.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/8/22.
//

import CommonSwiftUI
import MessageUI
import SDK
import StoreKit
import SwiftUI
/// Main settings flow for the app

enum SettingsSheet: String, Identifiable {
    case terms, privacy
    var id: String { rawValue }
}

struct SettingsContentView: View {
    @EnvironmentObject private var manager: DataManager
    @EnvironmentObject private var sdk: TheSDK
    @Environment(\.isSubscribed) private var isSubscribed: Bool

    @Binding var show: Bool
    @State var sheet: SettingsSheet?
    @State var showRateUs: Bool = false

    // MARK: - Main rendering function

    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()

            BgCircleView()

            VStack(spacing: 0) {
                CustomHeaderView
                ScrollView(.vertical, showsIndicators: false, content: {
                    Spacer(minLength: 10)
                    VStack {
                        CustomHeader(title: "IN-APP PURCHASES")
                        InAppPurchasesPromoBannerView
                        InAppPurchasesView
                        CustomHeader(title: "SPREAD THE WORD")
                        RatingShareView
                        CustomHeader(title: "SUPPORT & PRIVACY")
                        PrivacySupportView
                    }.padding([.leading, .trailing], 20)
                    Spacer(minLength: 20)
                }).padding(.top, 5)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.deepBlueColor)
            )

            .padding()
            .sheet(item: $sheet) { item in
                switch item {
                case .privacy:
                    WebView(url: Config.settingsPrivacyURL)
                case .terms:
                    WebView(url: Config.settingsTermsURL)
                }
            }
            .overlay {
                if showRateUs {
                    RateusAlert(show: $showRateUs, imageName: "rateusIcon") { _ in }
                }
            }
        }
        .onAppear {
            A.s.send(event: Events.AppPresentedScreen(screen: .settings))
        }
    }

    /// Custom header view
    private var CustomHeaderView: some View {
        ZStack {
            HStack {
                Text("Settings").bold()
                    .foregroundColor(.lightBlueColor).font(.custom(Fonts.UbuntuBold, size: 24, relativeTo: .largeTitle))
                Spacer()
                Button {
                    show = false
                } label: {
                    Image(systemName: "xmark.circle").font(.system(size: 24, weight: .medium))
                }
            }.foregroundColor(.white).font(.system(size: 20, weight: .medium))
        }.padding()
    }

    /// Create custom header view
    private func CustomHeader(title: String, subtitle: String? = nil) -> some View {
        HStack {
            Text(title).font(.custom(Fonts.UbuntuBold, size: 20, relativeTo: .headline))
            Spacer()
        }.foregroundColor(.lightGrayColor)
    }

    /// Custom settings item
    private func SettingsItem(title: String, icon: String, goal: String = "", action: @escaping () -> Void) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator().impactOccurred()
            action()
        }, label: {
            HStack {
                Image(systemName: icon).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22, alignment: .center)
                Text(title).font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .subheadline))
                Spacer()
                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(.lightBlueColor)
            }.foregroundColor(.lightGrayColor).padding()
                .background(
                    BorderedRectangle()
                )
        })
    }

    // MARK: - Daily Steps Goal

    private var InAppPurchasesView: some View {
        VStack {
            SettingsItem(title: "Upgrade Premium", icon: "crown") {
                sdk.presentSDKView(page: .unlockContent, show: nil)
            }
            SettingsItem(title: "Restore Purchases", icon: "arrow.clockwise") {
                Task {
                    try await sdk.updateIsSubscribed(thoroughly: true)
                }
            }
        }.padding([.top, .bottom], 5)
            .padding(.bottom, 40)
    }

    private var InAppPurchasesPromoBannerView: some View {
        ZStack {
            if !isSubscribed {
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Premium Version").bold().font(.custom(Fonts.UbuntuBold, size: 20, relativeTo: .title))
                        HStack {
                            Image(systemName: "checkmark.square").resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                            Text("Video to GIF").font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .body))
                        }
                        HStack {
                            Image(systemName: "checkmark.square").resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                            Text("Merge Videos").font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .body))
                        }
                        HStack {
                            Image(systemName: "checkmark.square").resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                            Text("Remove Ads").font(.custom(Fonts.UbuntuMedium, size: 16, relativeTo: .body))
                        }
                    }
                    Spacer()
                    Image("Premium_medium").font(.system(size: 45))
                }.foregroundColor(.lightGrayColor).padding([.leading, .trailing], 20)
                    .padding()
                    .padding(.vertical)
                    .background(BorderedRectangle())
            }
        }
    }

    // MARK: - Rating and Share

    // TODO: Embed Rate US
    private var RatingShareView: some View {
        VStack {
            SettingsItem(title: "Rate App", icon: "star") {
                showRateUs = true
                A.s.send(event: Events.UserInitiatedRateApp())
            }

            Color.extraDarkGrayColor.frame(height: 1).opacity(0.8).padding(.horizontal)

            SettingsItem(title: "Share App", icon: "square.and.arrow.up") {
                let shareController = UIActivityViewController(activityItems: [AppConfig.yourAppURL], applicationActivities: nil)
                rootController?.present(shareController, animated: true, completion: nil)
            }
        }
        .padding([.top, .bottom], 5)
        .padding(.bottom, 40)
    }

    // MARK: - Support & Privacy

    private var PrivacySupportView: some View {
        VStack {
            SettingsItem(title: "E-Mail us", icon: "envelope.badge") {
                EmailPresenter.shared.present()
            }
            Color.extraDarkGrayColor.frame(height: 1).opacity(0.8).padding(.horizontal)

            SettingsItem(title: "Privacy Policy", icon: "hand.raised") {
                sheet = .privacy
            }
            SettingsItem(title: "terms and conditions".capitalized, icon: "document") {
                sheet = .terms
            }
        }.padding([.top, .bottom], 5)
    }
}

// MARK: - Preview UI

struct SettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContentView(show: .constant(true))
            .environmentObject(DataManager())
            .environment(\.isSubscribed, false)
            .environmentObject(TheSDK(config: .init(baseURL: Config.serverURL)))
    }
}

// MARK: - Mail presenter for SwiftUI

class EmailPresenter: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailPresenter()
    override private init() { }

    func present() {
        if !MFMailComposeViewController.canSendMail() {
            presentAlert(title: "Email Client", message: "Your device must have the native iOS email app installed for this feature.")
            return
        }

        let picker = MFMailComposeViewController()
        picker.setSubject(Config.settingsMailSubject)
        picker.setMessageBody(Config.settingsMailbody, isHTML: false)
        picker.setToRecipients([Config.settingsMailRecepient])
        picker.mailComposeDelegate = self
        rootController?.present(picker, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        rootController?.dismiss(animated: true, completion: nil)
    }
}
