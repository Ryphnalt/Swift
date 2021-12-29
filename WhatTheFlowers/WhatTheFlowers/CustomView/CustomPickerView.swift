//
//  CustomPickerView.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/29.
//

import UIKit

protocol CustomPickerViewDelegate: AnyObject {
    func didTapDone()
    func didTapCancel()
    func becomeFirstResponder()
    func resignFirstResponder()
}

class CustomPickerView: UIView {

    weak var delegate: CustomPickerViewDelegate?

    var picker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    var pickerToolBar: UIToolbar = {
        let pickerToolBar = UIToolbar()
        pickerToolBar.barStyle = .default
        pickerToolBar.backgroundColor = .darkBlue30
        return pickerToolBar
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
    }

    func setupUI() {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                self.widthAnchor.constraint(equalTo: superview.widthAnchor)
            ])
        }

        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(didTapCancel))
        let doneButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(didTapDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        pickerToolBar.items = [cancelButton, spaceButton, doneButton]

        self.addSubview(picker)
        self.addSubview(pickerToolBar)

        pickerToolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerToolBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerToolBar.topAnchor.constraint(equalTo: self.topAnchor),
            pickerToolBar.widthAnchor.constraint(equalTo: self.widthAnchor),
            pickerToolBar.heightAnchor.constraint(equalToConstant: 44.0)
        ])

        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picker.topAnchor.constraint(equalTo: pickerToolBar.topAnchor),
            picker.widthAnchor.constraint(equalTo: self.widthAnchor),
            picker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    /// 開啟pickerview
    func openView(view: UIView?) {
        let isPickerExist: Bool = view?.subviews.contains(self) ?? false
        guard !isPickerExist else {
            return
        }
        let _ = becomeFirstResponder()
        view?.addSubview(self)
        setupUI()
    }

    @objc func didTapDone() {
        delegate?.didTapDone()

        let _ = resignFirstResponder()
    }

    @objc func didTapCancel() {
        delegate?.didTapCancel()

        let _ = resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        delegate?.becomeFirstResponder()
        return true
    }

    override func resignFirstResponder() -> Bool {
        delegate?.resignFirstResponder()
        self.removeFromSuperview()
        return true
    }

}
