//
//  BaseViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/1.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {

    var loadingView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (SCREEN_WIDTH - 50) / 2, y: (SCREEN_HEIGHT - 250) / 2, width: 50, height: 50), type: .pacman, color: .hexEF6A6F, padding: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loadingView)
    }

    func startLoading() {
        loadingView.startAnimating()
    }

    func stopLoading() {
        if loadingView.isAnimating {
            loadingView.stopAnimating()
        }
    }

}

