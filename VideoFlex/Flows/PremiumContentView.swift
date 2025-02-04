//
//  PremiumContentView.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import SwiftUI
import PurchaseKit

/// In-App Purchases view
struct PremiumContentView: View {
    
    var title: String
    var subtitle: String
    var features: [String]
    var productIds: [String]
    var exitFlow: () -> Void
    @State var completion: PKCompletionBlock?
    
    // MARK: - Privacy Policy, Terms & Conditions URLs
    // NOTE: You must provide these 2 URLs
    private let privacyPolicyURL: URL = AppConfig.privacyURL
    
    /// If you don't have the URLs mentioned above, you can hide the buttons by setting this to `true`
    private let hidePrivacyPolicyTermsButtons: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            BgCircleView()
            VStack{
                CloseButtonView
                ScrollView{
                    VStack(alignment: .leading,spacing: 15){
                        HeaderSectionView
                        VStack(spacing: 15) {
                            FeaturesListView
                            VStack(spacing: 15){
                                RestorePurchases
                                PrivacyPolicyTermsSection
                            }
                            .padding(.top,10)
                            ProductsListView
                        }.padding(.bottom, 20).padding(.top,10)
                        //                DisclaimerTextView
                    }
                    .background(
                        BorderedRectangle()
                    )
                    .padding()
                }
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.deepBlueColor)
            )
            .padding()
            
            
        }
    }
    
    /// Header view
    private var HeaderSectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            /// Image for the header
            Image("Premium_big")
            /// Title & Subtitle
            VStack (alignment: .leading, spacing: 15){
                Text(title).font(.custom(Fonts.UbuntuBold, size: 24, relativeTo: .title))
                Text(subtitle).font(.custom(Fonts.UbuntuMedium, size: 18, relativeTo: .headline))
            }.foregroundColor(.lightGrayColor)
        }
        .padding(.top)
        .padding(.horizontal, 30)
    }
    
    /// Features scroll list view
    private var FeaturesListView: some View {
        VStack(alignment: .leading,spacing: 15) {
            ForEach(features, id: \.self) { feature in
                HStack {
                    Image(systemName: "checkmark.square").resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    Text(feature).font(.custom(Fonts.UbuntuMedium, size: 18, relativeTo: .headline))
                    Spacer()
                }
            }.padding(.horizontal,30)
        }.foregroundColor(.lightGrayColor)
    }
    
    /// List of products
    private var ProductsListView: some View {
        VStack(spacing: 15) {
            ForEach(productIds, id: \.self) { product in
                Button(action: {
                    PKManager.purchaseProduct(identifier: product, completion: self.completion)
                }, label: {
                    ZStack {
                        RoundedCorner(radius: 20, corners: [.bottomLeft, .topRight]).foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))).frame(height: 45)
                        VStack {
                            Text(PKManager.formattedProductTitle(identifier: product)).font(.custom(Fonts.UbuntuMedium, size: 18, relativeTo: .body)).foregroundColor(.white).bold()
                        }
                    }
                })
            }
        }.padding(.leading, 30).padding(.trailing, 30).padding(.top, 10)
    }
    
    /// Close button on the top header
    private var CloseButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button { exitFlow() } label: {
                    Image(systemName: "xmark.circle").font(.system(size: 24, weight: .medium))
                }.foregroundColor(.white)
            }
        }.padding(.horizontal)
            .padding(.top)
    }
    
    /// Restore purchases button
    private var RestorePurchases: some View {
        HStack{
            Button(action: {
                PKManager.restorePurchases { (error, status, id) in
                    self.completion?((error, status, id))
                }
            }, label: {
                Text("Restore Purchases")
                    .font(.custom(Fonts.UbuntuBold, size: 20, relativeTo: .headline))
            }).foregroundColor(.lightGrayColor)
            Spacer()
        }
            .padding(.horizontal,30)
    }
    
    /// Privacy Policy, Terms & Conditions section
    private var PrivacyPolicyTermsSection: some View {
        HStack(spacing: 20) {
            if hidePrivacyPolicyTermsButtons == false {
                Button(action: {
                    UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Privacy Policy")
                })
            }
            Spacer()
        }.font(.custom(Fonts.UbuntuMedium, size: 18, relativeTo: .headline)).foregroundColor(.lightGrayColor).padding(.horizontal,30)
    }
    
    /// Disclaimer text view at the bottom
    private var DisclaimerTextView: some View {
        VStack {
            Text(PKManager.disclaimer).font(.system(size: 12))
                .multilineTextAlignment(.center)
                .padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 50)
        }.foregroundColor(.white).opacity(0.2)
    }
}

