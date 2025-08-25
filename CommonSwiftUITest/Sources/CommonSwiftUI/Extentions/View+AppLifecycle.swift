//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 12/01/2025.
//

import SwiftUI

public extension View {
    func didEnterBackground(_ callback: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            callback()
        }
    }

    func willEnterForeground(_ callback: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            callback()
        }
    }

    func didBecomeActive(_ callback: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            callback()
        }
    }

    func willResignActive(_ callback: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            callback()
        }
    }

    func didReceiveMemoryWarning(_ callback: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            callback()
        }
    }

    func appWillTerminate(_ callback: @escaping () -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            callback()
        }
    }
}

public struct KeyboardActivityInfo {
    public let frame: CGRect
    public let duration: TimeInterval
    public let curve: UIView.AnimationOptions
}

public extension View {
    func keyboardWillShow(_ callback: @escaping (KeyboardActivityInfo?) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)) {
            guard let userInfo = $0.userInfo else {
                callback(nil)
                return
            }

            guard let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                callback(nil)
                return
            }

            let keyboardFrame = keyboardFrameValue.cgRectValue

            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                callback(nil)
                return
            }

            guard let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
                callback(nil)
                return
            }

            let animationOptions = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

            callback(.init(frame: keyboardFrame, duration: animationDuration, curve: animationOptions))
        }
    }

    func keyboardDidShow(_ callback: @escaping (KeyboardActivityInfo?) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)) {
            guard let userInfo = $0.userInfo else {
                callback(nil)
                return
            }

            guard let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                callback(nil)
                return
            }

            let keyboardFrame = keyboardFrameValue.cgRectValue

            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                callback(nil)
                return
            }

            guard let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
                callback(nil)
                return
            }

            let animationOptions = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

            callback(.init(frame: keyboardFrame, duration: animationDuration, curve: animationOptions))
        }
    }

    func keyboardWillHide(_ callback: @escaping (KeyboardActivityInfo?) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) {
            guard let userInfo = $0.userInfo else {
                callback(nil)
                return
            }

            guard let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                callback(nil)
                return
            }

            let keyboardFrame = keyboardFrameValue.cgRectValue

            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                callback(nil)
                return
            }

            guard let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
                callback(nil)
                return
            }

            let animationOptions = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

            callback(.init(frame: keyboardFrame, duration: animationDuration, curve: animationOptions))
        }
    }

    func keyboardDidHide(_ callback: @escaping (KeyboardActivityInfo?) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification)) {
            guard let userInfo = $0.userInfo else {
                callback(nil)
                return
            }

            guard let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                callback(nil)
                return
            }

            let keyboardFrame = keyboardFrameValue.cgRectValue

            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                callback(nil)
                return
            }

            guard let animationCurveRawValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
                callback(nil)
                return
            }

            let animationOptions = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

            callback(.init(frame: keyboardFrame, duration: animationDuration, curve: animationOptions))
        }
    }

    func keyboardWillChangeFrame(_ callback: @escaping (CGRect?) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillChangeFrameNotification)) {
            guard let userInfo = $0.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                callback(nil)
                return
            }

            callback(frame)
        }
    }

    func keyboardDidChangeFrame(_ callback: @escaping (CGRect?) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidChangeFrameNotification)) {
            guard let userInfo = $0.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                callback(nil)
                return
            }

            callback(frame)
        }
    }
}
