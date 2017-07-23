//
//  TextFieldExtension.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/15.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

extension UITextField {
    func boderField() {
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:10, height:self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
