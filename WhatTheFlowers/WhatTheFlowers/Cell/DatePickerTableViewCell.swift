//
//  DatePickerTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

import UIKit

struct DatePickerTableViewCellModel {
    var title: String
    var text: Date
    var value: Date
    let placeholder: String
    var status: DatePickerStatus = .normal

    enum DatePickerStatus {
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

protocol DatePickerTableViewCellDelegate: AnyObject {
    func didSelect(_ cell: DatePickerTableViewCell, date: Date)
    func didTapMenuView(_ cell: DatePickerTableViewCell)
    func didTapDone(_ cell: DatePickerTableViewCell)
    func didTapCancel(_ cell: DatePickerTableViewCell, date: Date)
}

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var dropMenuView: UIStackView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewHeight: NSLayoutConstraint!

    lazy var pickerView: CustomDatePickerView = {
        let pickerView = CustomDatePickerView()
        pickerView.delegate = self
        return pickerView
    }()

    var initDate: Date = Date()
    var currentDate: Date = Date()

    weak var delegate: DatePickerTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: DatePickerTableViewCellModel) {
        currentDate = model.value

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY / MM / dd"
        itemNameLabel.text = dateFormatter.string(from: model.text)
        titleLabel.text = model.title
        updateWhenStatusChenge(status: model.status)
        
        dropMenuView.addTap(target: self, action: #selector(didTapMenuView))
    }

    func updateWhenStatusChenge(status: DatePickerTableViewCellModel.DatePickerStatus) {
        borderView.backgroundColor = status.borderColor
        borderViewHeight.constant = status.borderHeight
    }

    @objc func didTapMenuView() {
        guard let superView = self.superview as? UITableView else {
            print("DatePickerTableViewCell superview is not UITableView")
            return
        }
        initDate = currentDate

        delegate?.didTapMenuView(self)

        pickerView.openView(view: superView.superview)
        pickerView.picker.date = currentDate
        pickerView.picker.addTarget(self,
                                    action: #selector(datePickerChanged),
                                    for: .valueChanged)
    }

    @objc func datePickerChanged(datePicker: UIDatePicker) {
        delegate?.didSelect(self, date: datePicker.date)
    }
    
}

extension DatePickerTableViewCell: CustomDatePickerViewDelegate {
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
        delegate?.didTapCancel(self, date: initDate)
    }
}
