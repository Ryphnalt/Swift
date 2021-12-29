//
//  TextViewTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

import UIKit

struct TextViewTableViewCellModel {
    let title: String
    var text: String = ""
    var value: String = ""
    let placeholder: String
    var status: TextViewStatus = .normal

    enum TextViewStatus {
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

protocol TextViewTableViewCellDelegate: AnyObject {
    func textViewDidBeginEditing(_ cell: TextViewTableViewCell)
    func textViewDidEndEditing(_ cell: TextViewTableViewCell, text: String)
    func textViewDidChange(_ cell: TextViewTableViewCell, text: String)
}

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editTextView: CustomTextView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var borderViewHeight: NSLayoutConstraint!

    weak var delegate: TextViewTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: TextViewTableViewCellModel) {
        titleLabel.text = model.title
        editTextView.text = model.text
        editTextView.delegate = self
        updateWhenStatusChenge(status: model.status)
    }

    func updateWhenStatusChenge(status: TextViewTableViewCellModel.TextViewStatus) {
        borderView.backgroundColor = status.borderColor
        borderViewHeight.constant = status.borderHeight
    }
    
}

extension TextViewTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateWhenStatusChenge(status: .focus)
        delegate?.textViewDidBeginEditing(self)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateWhenStatusChenge(status: .done)
        delegate?.textViewDidEndEditing(self, text: textView.text)
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(self, text: textView.text)
    }
}
