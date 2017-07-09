//
//  LoginViewController.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/8.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var loginBtnView: UIView!
    @IBOutlet weak var forgetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        var frame = self.loginBtnView.frame
        frame.origin.y = self.emailView.frame.origin.y-30
        self.loginBtnView.frame = frame
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    @IBAction func register(_ sender: UIButton) {
 
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
 
    }
    
    @IBAction func closeLoginView(_ sender: UIButton) {
        dissmissloginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2) / pageWidth) + 1
        self.pageControl.currentPage = Int(currentPage)
    }
    
    public func showLoginView(current:Int) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
