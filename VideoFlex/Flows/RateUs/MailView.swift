//
//  WebViewScreen.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 27/06/2024.
//

import CommonSwiftUI
import Foundation
import MessageUI
import SwiftUI
import UIKit
class VC: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .red
    }
}

enum MAilError: Error, Equatable {
    case general
}

@MainActor
struct MailView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let body: String
    @Binding var result: Result<MFMailComposeResult, CommonError>?

    init(recipients: [String] = [], subject: String = "", body: String = "", result: Binding<Result<MFMailComposeResult, CommonError>?>) {
        self.recipients = recipients
        self.subject = subject
        self.body = body
        _result = result
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(result: $result)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        guard MFMailComposeViewController.canSendMail() else { return .init() }

        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = context.coordinator
        mailVC.setToRecipients(recipients)
        mailVC.setSubject(subject)
        mailVC.setMessageBody(body, isHTML: false)

        A.s.send(event: Events.AppPresentedScreen(screen: .mail))

        return mailVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var result: Result<MFMailComposeResult, CommonError>?

        init(result: Binding<Result<MFMailComposeResult, CommonError>?>) {
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            guard error == nil else {
                self.result = .failure(.generic)
                return
            }
            self.result = .success(result)
        }
    }
}
