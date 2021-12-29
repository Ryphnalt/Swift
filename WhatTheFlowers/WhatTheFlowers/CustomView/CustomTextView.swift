//
//  CustomTextView.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/29.
//

import UIKit

@IBDesignable
class CustomTextView: UITextView {

    var labelTop: NSLayoutConstraint?
    var labelBottom: NSLayoutConstraint?
    var labelLeft: NSLayoutConstraint?
    var labelRight: NSLayoutConstraint?
    var labelWidth: NSLayoutConstraint?

    public let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @IBInspectable open var placeholder: String? = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    @IBInspectable open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    open override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }

    open override var text: String! {
        didSet {
            postTextViewDidChange()
        }
    }

    open override var attributedText: NSAttributedString! {
        didSet {
            postTextViewDidChange()
        }
    }

    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    open override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderInsets = textContainerInset
        }
    }

    var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }

    // MARK: - Init
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() {
        self.tintColor = .hex54090C

        addSubview(placeholderLabel)

        labelTop = placeholderLabel.topAnchor.constraint(equalTo: topAnchor,
                                                         constant: 8)
        labelTop?.isActive = true

        labelBottom = placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                               constant: -8)
        labelBottom?.isActive = true

        labelLeft = placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                                           constant: 4)
        labelLeft?.isActive = true

        labelRight = placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                                             constant: -4)
        labelRight?.isActive = true

        labelWidth = placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor,
                                                             constant: -8)
        labelWidth?.isActive = true

        textViewTextDidChange()
        font = placeholderLabel.font

        let sel = #selector(textViewTextDidChange)
        let name = UITextView.textDidChangeNotification
        NotificationCenter.default.addObserver(self, selector: sel,
                                               name: name, object: nil)
    }

    private func updateConstraintsForPlaceholderLabel() {
        labelTop?.constant = placeholderInsets.top
        labelBottom?.constant = -placeholderInsets.bottom
        labelLeft?.constant = placeholderInsets.left + 4
        labelRight?.constant = -placeholderInsets.right - 4

        let width = frame.width
        let w = width - width - placeholderInsets.left - placeholderInsets.right
        labelWidth?.constant = w
    }

    private func postTextViewDidChange() {
        let name = UITextView.textDidChangeNotification
        NotificationCenter.default.post(name: name, object: self)
    }

    @objc
    private func textViewTextDidChange() {
        let isPlaceholderHidden = !text.isEmpty
        placeholderLabel.isHidden = isPlaceholderHidden
    }
}
