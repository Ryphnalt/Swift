//
//  UIViewExtension.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/29.
//

import UIKit

extension UIView {

    /// 在view增加點擊功能
    func addTap(target:Any, action:Selector){
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = true
        self.addGestureRecognizer(tap)
    }

    /// 移除view的點擊功能
    func removeTap(){
        for tap in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(tap)
        }
    }

    func setCorner(radius: CGFloat, clipsToBounds: Bool = false) {
        layer.cornerRadius = radius
        self.clipsToBounds = clipsToBounds
    }

}
