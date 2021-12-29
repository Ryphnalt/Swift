//
//  DropMenuTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

import UIKit

struct DropMenuTableViewCellModel {
    let title: String
    var text: String = ""
    var value: String = ""
    let placeholder: String
    var status: DropMenuStatus = .normal
    let menuItems: [String]

    enum DropMenuStatus {
        case normal
        case focus
        case done
        case error(message: String)

        var borderColor: UIColor {
            switch self {
            case .normal, .done:
                return .black

            case .focus:
                return .black

            case .error:
                return .red
            }
        }

        var borderHeight: CGFloat {
            switch self {
            case .normal, .done:
                return 0.5

            case .focus:
                return 1.5

            case .error:
                return 1.5
            }
        }
    }
}

protocol DropMenuTableViewCellDelegate: AnyObject {
    func didSelect(_ cell: DropMenuTableViewCell, rowIndex: Int)
    func didTapMenuView(_ cell: DropMenuTableViewCell)
    func didTapDone(_ cell: DropMenuTableViewCell)
    func didTapCancel(_ cell: DropMenuTableViewCell, rowIndex: Int)
}

class DropMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var dropMenuView: UIStackView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewHeight: NSLayoutConstraint!

    lazy var pickerView: CustomPickerView = {
        let pickerView = CustomPickerView()
        pickerView.delegate = self
        return pickerView
    }()

    var menuItems: [String] = []
    var initRowIndex: Int = 0
    var currentRowIndex: Int = 0

    weak var delegate: DropMenuTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: DropMenuTableViewCellModel) {
        menuItems = model.menuItems
        currentRowIndex = (Int(model.value) ?? 1) - 1

        titleLabel.text = model.title
        itemNameLabel.text = model.text
        updateWhenStatusChenge(status: model.status)

        dropMenuView.addTap(target: self, action: #selector(didTapMenuView))
    }

    func updateWhenStatusChenge(status: DropMenuTableViewCellModel.DropMenuStatus) {
        borderView.backgroundColor = status.borderColor
        borderViewHeight.constant = status.borderHeight
    }

    @objc func didTapMenuView() {
        guard menuItems.count > 0 else {
            print("DropMenuTableViewCell menu is empty")
            return
        }
        guard let superView = self.superview as? UITableView else {
            print("DropMenuTableViewCell superview is not UITableView")
            return
        }
        initRowIndex = currentRowIndex

        delegate?.didTapMenuView(self)

        pickerView.openView(view: superView.superview)
        pickerView.picker.delegate = self
        pickerView.picker.dataSource = self
        pickerView.picker.selectRow(currentRowIndex, inComponent: 0, animated: false)
    }
    
}

extension DropMenuTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuItems.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return menuItems[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelect(self, rowIndex: row)
    }

}

extension DropMenuTableViewCell: CustomPickerViewDelegate {
    func becomeFirstResponder() {
        updateWhenStatusChenge(status: .focus)
    }

    func resignFirstResponder() {
        updateWhenStatusChenge(status: .done)
    }

    func didTapDone() {
        delegate?.didTapDone(self)
    }

    func didTapCancel() {
        delegate?.didTapCancel(self, rowIndex: initRowIndex)
    }
}
