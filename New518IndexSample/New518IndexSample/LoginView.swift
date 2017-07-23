//
//  LoginView.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/16.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

protocol LoginViewLayout {
    var scrollView:UIScrollView {get set}
    var accountTextField:UITextField {get set}
    var passwordTextField:UITextField {get set}
    var emailTextField:UITextField {get set}
    var displayPasswordButton:UIButton {get set}
    var forgetButton:UIButton {get set}
    var loginButton:UIButton {get set}
    var regButton:UIButton {get set}
    var buttonView:UIView {get set}
}
