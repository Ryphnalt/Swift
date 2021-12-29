//
//  TextFieldTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

import UIKit

struct TextFieldTableViewCellModel {
    let title: String
    var text: String = ""
    var value: String = ""
    let placeholder: String
    let keyboardType: UIKeyboardType
    var status: TextFieldStatus = .normal

    enum TextFieldStatus {
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

protocol TextFieldTableViewCellDelegate: AnyObject {
    func textFieldDidBeginEditing(_ cell: TextFieldTableViewCell)
    func textFieldDidEndEditing(_ cell: TextFieldTableViewCell, text: String)
    func textFieldDidChange(_ cell: TextFieldTableViewCell, text: String)
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewHeight: NSLayoutConstraint!

    weak var delegate: TextFieldTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: TextFieldTableViewCellModel) {
        titleLabel.text = model.title
        editTextField.text = model.text
        editTextField.autocorrectionType = .yes
        editTextField.attributedPlaceholder = NSAttributedString(
            string: model.placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        editTextField.keyboardType = model.keyboardType
        editTextField.delegate = self
        updateWhenStatusChenge(status: model.status)
    }

    func updateWhenStatusChenge(status: TextFieldTableViewCellModel.TextFieldStatus) {
        borderView.backgroundColor = status.borderColor
        borderViewHeight.constant = status.borderHeight
    }

}

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateWhenStatusChenge(status: .focus)
        delegate?.textFieldDidBeginEditing(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateWhenStatusChenge(status: .done)
        delegate?.textFieldDidEndEditing(self, text: textField.text ?? "")
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text, let range = Range(range, in: text) else {
            print("TextFieldTableViewCell shouldChangeCharactersIn error")
            return true
        }
        delegate?.textFieldDidChange(self, text: text.replacingCharacters(in: range, with: string))
        return true
    }
}
