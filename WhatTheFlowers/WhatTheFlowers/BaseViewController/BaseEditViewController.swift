//
//  BaseEditViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/30.
//

import UIKit

class BaseEditViewController: BaseViewController {

    var baseTableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardObserver()
    }

    private func addKeyboardObserver() {
        let sel = #selector(keyboardWillShow(_:))
        let name = UIResponder.keyboardWillShowNotification
        NotificationCenter.default.addObserver(self,
                                               selector: sel,
                                               name: name,
                                               object: nil)

        let sel2 = #selector(keyboardWillHide(_:))
        let name2 = UIResponder.keyboardWillHideNotification
        NotificationCenter.default.addObserver(self,
                                               selector: sel2,
                                               name: name2,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        adjustContentForKeyboard(shown: true, notification: notification)
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        adjustContentForKeyboard(shown: false, notification: notification)
    }

    private func adjustContentForKeyboard(shown: Bool, notification: NSNotification) {
        guard let keyboardInfo = KeyboardInfo(notification) else { return }
        if shown {
            setTableViewContentInset(bottomInset: keyboardInfo.frameEnd.height - 40)
        } else {
            setTableViewContentInset(bottomInset: 0)
        }
    }

    func setTableViewContentInset(bottomInset: CGFloat) {
        guard let tableView = baseTableView else { return }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }

    func removeFirstResponder() {
        view.endEditing(true)
        removePickerView()
    }

    func removePickerView() {
        view.subviews.forEach {
            if $0 is CustomDatePickerView {
                $0.resignFirstResponder()
            } else if $0 is CustomPickerView {
                $0.resignFirstResponder()
            }
        }
    }

}
