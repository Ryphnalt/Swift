//
//  OrderTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/30.
//

import UIKit
import Firebase
import Kingfisher

struct OrderTableViewCellModel {
    var id: String = ""
    var source: OrderSource = .shopee
    var name: String = ""
    var price: String = ""
    var content: String = ""
    var deadline: String = ""
    var status: OrderStatus = .normal
    var sendType: OrderSendType = .mailing
    var photoName: String = ""
}

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var borderView: UIView! {
        didSet {
            borderView.backgroundColor = .darkBlue30
        }
    }
    @IBOutlet weak var tagView: UIView! {
        didSet {
            tagView.backgroundColor = .hex54090C
            tagView.setCorner(radius: 5.0, clipsToBounds: true)
        }
    }
    @IBOutlet weak var tagLabel: UILabel! {
        didSet {
            tagLabel.textColor = .white
            tagLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
    }

    @IBOutlet weak var contentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: OrderTableViewCellModel) {
        dateLabel.text = model.deadline
        nameLabel.text = model.name
        sourceLabel.text = model.source.text
        priceLabel.text = model.price
        tagLabel.text = model.sendType.text
        contentTextView.text = model.content
        if !model.photoName.isEmpty {
            let storageRef = Storage.storage().reference()
            let imagesRef = storageRef.child("photos/\(model.photoName)")
            imagesRef.downloadURL { url, error in
                if let error = error {
                    print(error)
                } else {
                    self.photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "imgPhotoPlaceholder"))
                }
            }
        } else {
            photoImageView.image = UIImage(named: "imgPhotoPlaceholder")
        }
    }
}
