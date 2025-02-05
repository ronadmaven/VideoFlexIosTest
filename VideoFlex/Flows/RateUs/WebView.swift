//
//  WebViewScreen.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 27/06/2024.
//

import SwiftUI
import WebKit

@MainActor
struct WebView: UIViewRepresentable {
 
    let url: URL
    let webView: WKWebView
    
    init(url: URL) {
        self.url = url
        let config1 = WKWebViewConfiguration()
        config1.processPool = WKProcessPool()
        webView = WKWebView(frame: .zero,configuration: config1)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}


#Preview {
    WebView(url: .init(string: "http://www.google.com")!)
}


