//
//  DoubleDropMenuTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/9.
//

import UIKit

struct DoubleDropMenuTableViewCellModel {
    let title: String
    var mainText: String = ""
    var subText: String = ""
    var mainValue: String = ""
    var subValue: String = ""
    let mainPlaceholder: String
    let subPlaceholder: String
    var status: DropMenuStatus = .normal
    let mainMenuItems: [String]
    let subMenuItems: [[String]]

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

protocol DoubleDropMenuTableViewCellDelegate: AnyObject {
    func didSelect(_ cell: DoubleDropMenuTableViewCell, values: [String])
    func didTapMenuView(_ cell: DoubleDropMenuTableViewCell)
    func didTapDone(_ cell: DoubleDropMenuTableViewCell)
    func didTapCancel(_ cell: DoubleDropMenuTableViewCell, values: [String])
}

class DoubleDropMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var dropMenuView: UIStackView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var itemNameLabel2: UILabel!
    @IBOutlet weak var dropMenuView2: UIStackView!
    @IBOutlet weak var dropDownImageView2: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewHeight: NSLayoutConstraint!

    lazy var pickerView: CustomPickerView = {
        let pickerView = CustomPickerView()
        pickerView.delegate = self
        return pickerView
    }()

    var mainMenuItems: [String] = []
    var subMenuItems: [[String]] = [[]]
    var initMainRow: Int = 0
    var initSubRow: Int = 0
    var dropMainMenuRow: Int = 0 {
        didSet {
            pickerView.picker.reloadComponent(1)
        }
    }
    var dropSubMenuRow: Int = 0

    weak var delegate: DoubleDropMenuTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: DoubleDropMenuTableViewCellModel) {
        mainMenuItems = model.mainMenuItems
        subMenuItems = model.subMenuItems

        dropMainMenuRow = mainMenuItems.index(of: model.mainValue) ?? 0
        dropSubMenuRow = subMenuItems[dropMainMenuRow].index(of: model.subValue) ?? 0

        titleLabel.text = model.title
        itemNameLabel.text = model.mainText
        itemNameLabel2.text = model.subText
        updateWhenStatusChenge(status: model.status)

        dropMenuView.addTap(target: self, action: #selector(didTapMenuView))
        dropMenuView2.addTap(target: self, action: #selector(didTapMenuView))
    }

    func updateWhenStatusChenge(status: DoubleDropMenuTableViewCellModel.DropMenuStatus) {
        borderView.backgroundColor = status.borderColor
        borderViewHeight.constant = status.borderHeight
    }

    @objc func didTapMenuView() {
        guard mainMenuItems.count > 0 else {
            print("DropMenuTableViewCell menu is empty")
            return
        }
        guard let superView = self.superview as? UITableView else {
            print("DropMenuTableViewCell superview is not UITableView")
            return
        }
        initMainRow = dropMainMenuRow
        initSubRow = dropSubMenuRow

        delegate?.didTapMenuView(self)

        pickerView.openView(view: superView.superview)
        pickerView.picker.delegate = self
        pickerView.picker.dataSource = self
        pickerView.picker.selectRow(dropMainMenuRow, inComponent: 0, animated: false)
        pickerView.picker.selectRow(dropSubMenuRow, inComponent: 1, animated: false)
    }
    
}

extension DoubleDropMenuTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1:
            return subMenuItems[safe: dropMainMenuRow]?.count ?? 0
        default:
            return mainMenuItems.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 1:
            return subMenuItems[safe: dropMainMenuRow]?[safe: row]
        default:
            return mainMenuItems[safe: row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var mainIndex = dropMainMenuRow
        var subIndex = dropSubMenuRow
        switch component {
        case 1:
            subIndex = row
        default:
            mainIndex = row
        }
        let mainValue = mainMenuItems[safe: mainIndex] ?? ""
        let subValue = subMenuItems[safe: mainIndex]?[safe: subIndex] ?? ""
        delegate?.didSelect(self, values: [mainValue, subValue])
    }

}

extension DoubleDropMenuTableViewCell: CustomPickerViewDelegate {
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
        let mainValue = mainMenuItems[safe: initMainRow] ?? ""
        let subValue = subMenuItems[safe: initMainRow]?[safe: initSubRow] ?? ""
        delegate?.didTapCancel(self, values: [mainValue, subValue])
    }
}
