//
//  LoginViewController.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/8.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var screenSize:CGSize = UIScreen.main.bounds.size
    var autoRotateTimer:Timer!
    var backgroundImages:[String]?
    var titles:[String]?
    var descriptions:[String]?
    var scrollViewForField:UIScrollView!
    var accountTextField:UITextField!
    var passwordTextField:UITextField!
    var emailTextField:UITextField!
    var forgetButton:UIButton!
    var loginButton:UIButton!
    var regButton:UIButton!
    var buttonView:UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        var rotateBG = RotateBackground()
        rotateBG.backgroundImages = backgroundImages!
        rotateBG.titles = titles!
        rotateBG.descriptions = descriptions!
        rotateBG.layoutForSubviews(superView: self.view)
        
        
        
        scrollViewForField = UIScrollView()
        scrollViewForField.backgroundColor = .clear
        scrollViewForField.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
        scrollViewForField.contentSize = CGSize(width:screenSize.width, height:screenSize.height)
        
        accountTextField = UITextField()
        accountTextField.frame = CGRect(x:20, y:screenSize.height*0.4, width:screenSize.width-40, height:40)
        //accountTextField.backgroundColor = .white
        accountTextField.placeholder = "身分證字號"
        accountTextField.boderField()
        accountTextField.returnKeyType = .next
        accountTextField.delegate = self
        accountTextField.clearButtonMode = .whileEditing
        scrollViewForField.addSubview(accountTextField)
        
        passwordTextField = UITextField()
        passwordTextField.frame = CGRect(x:20, y:accountTextField.frame.origin.y+accountTextField.frame.size.height+10, width:screenSize.width-40, height:40)
        passwordTextField.placeholder = "密碼"
        passwordTextField.boderField()
        passwordTextField.returnKeyType = .go
        passwordTextField.delegate = self
        let paddingView = UIButton(frame: CGRect(x:0, y:0, width:40, height:40))
        paddingView.setTitle("顯示", for: .normal)
        paddingView.setTitleColor(.blue, for: .normal)
        paddingView.titleLabel?.font = UIFont(name:"Helvetica", size:14.0)
        passwordTextField.rightView = paddingView
        passwordTextField.rightViewMode = .always
        scrollViewForField.addSubview(passwordTextField)
        
        forgetButton = UIButton(frame: CGRect(x:20, y:passwordTextField.frame.origin.y+passwordTextField.frame.size.height+10, width:100, height:40))
        forgetButton.setTitle("忘記密碼？", for: .normal)
        forgetButton.setTitleColor(.blue, for: .normal)
        forgetButton.titleLabel?.textAlignment = .left
        forgetButton.titleLabel?.font = UIFont(name:"Helvetica", size:16.0)
        scrollViewForField.addSubview(forgetButton)
        
        emailTextField = UITextField()
        emailTextField.frame = CGRect(x:20, y:passwordTextField.frame.origin.y+passwordTextField.frame.size.height+10, width:screenSize.width-40, height:40)
        emailTextField.placeholder = "電子信箱"
        emailTextField.boderField()
        emailTextField.returnKeyType = .go
        emailTextField.delegate = self
        emailTextField.clearButtonMode = .whileEditing
        scrollViewForField.addSubview(emailTextField)
        emailTextField.isHidden = true
        
        buttonView = UIView(frame: CGRect(x:0, y:forgetButton.frame.origin.y+forgetButton.frame.size.height+20, width:screenSize.width, height:100))
        buttonView.backgroundColor = .clear
        scrollViewForField.addSubview(buttonView)
        
        loginButton = UIButton(frame: CGRect(x:20, y:0, width:screenSize.width-40, height:40))
        loginButton.backgroundColor = .orange
        loginButton.setTitle("登入", for: .normal)
        buttonView.addSubview(loginButton)
        
        regButton = UIButton(frame: CGRect(x:20, y:loginButton.frame.origin.y+loginButton.frame.size.height+10, width:screenSize.width-40, height:40))
        regButton.setTitle("還不是518會員？3秒免費加入！", for: .normal)
        regButton.setTitleColor(.blue, for: .normal)
        regButton.titleLabel?.textAlignment = .center
        regButton.addTarget(self, action: #selector(self.register), for: .touchUpInside)
        buttonView.addSubview(regButton)
        
        self.view.addSubview(scrollViewForField)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            /*
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
            */
            if scrollViewForField.contentSize.height == screenSize.height {
                var frameTmp:CGRect = scrollView.frame
                frameTmp.origin.y = frameTmp.origin.y-keyboardSize.height
                scrollView.frame = frameTmp
                
                frameTmp = pageControl.frame
                frameTmp.origin.y = frameTmp.origin.y-keyboardSize.height
                pageControl.frame = frameTmp
                
                scrollViewForField.contentSize = CGSize(width:screenSize.width, height:screenSize.height+keyboardSize.height)
                scrollViewForField.setContentOffset(CGPoint(x:0,y:150), animated: true)
            }
            
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if scrollViewForField.contentSize.height > screenSize.height {
                var frameTmp:CGRect = scrollView.frame
                frameTmp.origin.y = frameTmp.origin.y+keyboardSize.height
                scrollView.frame = frameTmp
                
                frameTmp = pageControl.frame
                frameTmp.origin.y = frameTmp.origin.y+keyboardSize.height
                pageControl.frame = frameTmp
                
                scrollViewForField.contentSize = CGSize(width:screenSize.width, height:screenSize.height)
            }
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    


    
    func register(_ sender: UIButton) {
        UIView.transition(with: forgetButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.forgetButton.isHidden = (!self.forgetButton.isHidden) ? true : false
        }, completion: nil)
        UIView.transition(with: emailTextField, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.emailTextField.isHidden = (!self.emailTextField.isHidden) ? true : false
        }) { (true) in
            UIView.transition(with: self.loginButton, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.loginButton.titleLabel?.text = (!self.emailTextField.isHidden) ? "註冊" : "登入"
            }, completion: nil)
            
            UIView.transition(with: self.regButton, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.regButton.titleLabel?.text = (!self.emailTextField.isHidden) ? "已經是518會員？立即登入！" : "還不是518會員？3秒免費加入！"
            }, completion: nil)
        }
        
       passwordTextField.returnKeyType = (!self.emailTextField.isHidden) ? .next : .go
        
        
        
        /*
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.forgetLabel.isHidden = (!self.forgetLabel.isHidden) ? true : false
            self.emailView.isHidden = (!self.emailView.isHidden) ? true : false
        }) { (true) in
            
            if let btn = self.loginBtnView.viewWithTag(1) as? UIButton {
                UIView.transition(with: btn,
                                  duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    btn.titleLabel?.text = "註冊"
                }, completion: nil)
            }

            if let btn2 = self.loginBtnView.viewWithTag(2) as? UIButton {
                btn2.titleLabel?.text = (!self.emailView.isHidden) ? "已經是518會員？立即登入！" : "還不是518會員？3秒免費加入！"
                /*
                UIView.transition(with: btn2,
                                  duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    
                                    
                }, completion: nil)*/
            }
            
            
        }
 */
 
    }
    
    
    @IBAction func closeLoginView(_ sender: UIButton) {
        dissmissloginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2) / pageWidth) + 1
        self.pageControl.currentPage = Int(currentPage)
    }
    */
    public func showLoginView() {
        //let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        //appDelegate.window?.rootViewController = self
        //appDelegate.window?.makeKeyAndVisible()
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let window = appDelegate.window
        let rootViewController = window?.rootViewController
        
        self.view.frame = (rootViewController?.view.frame)!
        self.view.layoutIfNeeded()
        
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = self
            window?.makeKeyAndVisible()
            
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    public func dissmissloginView(){
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        
        UIView.transition(from: self.view, to: tabBarController.view, duration: 0.3, options: .transitionCrossDissolve) { (
            true) in
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField == self.accountTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            if !self.emailTextField.isHidden {
                self.emailTextField.becomeFirstResponder()
            } else {
                if self.accountTextField.text=="" {
                    self.accountTextField.becomeFirstResponder()
                } else {
                    print("login")
                }
            }
        } else if textField == self.emailTextField {
            if self.accountTextField.text=="" {
                self.accountTextField.becomeFirstResponder()
            } else if self.passwordTextField.text=="" {
                self.passwordTextField.becomeFirstResponder()
            } else {
                print("register")
            }
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
