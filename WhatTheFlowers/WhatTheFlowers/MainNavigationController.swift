//
//  MainNavigationController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/23.
//

import UIKit

class MainNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationBar.barTintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkBlue900,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .medium),
        ]

        navigationBar.tintColor = .darkBlue900
        delegate = self

        // 隱藏 Bar 底線
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()

        // 更換back按鍵圖片
        let image = UIImage(named: "icNav24Back")?.withRenderingMode(.alwaysTemplate)
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image

        //要啟用 在頁面左滑（由左到右) NAV 返回上一頁效果的話這邊要加 以及上面要 conform UIGestureRecognizerDelegate
        interactivePopGestureRecognizer?.delegate = self

//        modalPresentationStyle = .fullScreen
    }

    // 去除navigationController所有返回按鈕帶上一頁的title文字
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = barButtonItem
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

}
