//
//  KeyboardInfoExtension.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/30.
//

import Foundation
import UIKit

struct KeyboardInfo {
    var animationCurve: UIView.AnimationCurve
    var animationOptions: UIView.AnimationOptions
    var animationDuration: Double
    var isLocal: Bool
    var frameBegin: CGRect
    var frameEnd: CGRect
}

extension KeyboardInfo {
    init?(_ notification: NSNotification) {

        guard notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillHideNotification else { return nil }
        let u = notification.userInfo!

        animationCurve = UIView.AnimationCurve(rawValue: u[UIWindow.keyboardAnimationCurveUserInfoKey] as! Int)!
        animationOptions = UIView.AnimationOptions(rawValue: UInt(animationCurve.rawValue))
        animationDuration = u[UIWindow.keyboardAnimationDurationUserInfoKey] as! Double
        isLocal = u[UIWindow.keyboardIsLocalUserInfoKey] as! Bool
        frameBegin = u[UIWindow.keyboardFrameBeginUserInfoKey] as! CGRect
        frameEnd = u[UIWindow.keyboardFrameEndUserInfoKey] as! CGRect
    }
}
