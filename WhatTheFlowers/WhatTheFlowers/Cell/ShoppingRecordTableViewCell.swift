//
//  ShoppingRecordTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/13.
//

import UIKit
import Firebase
import Kingfisher

struct ShoppingRecordTableViewCellModel {
    var id: String = ""
    var name: String = ""
    var type: String = ""
    var color: String = ""
    var place: String = ""
    var size: String = ""
    var price: String = ""
    var quantity: String = ""
    var content: String = ""
    var date: String = ""
    var photoName: String = ""
}

class ShoppingRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
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

    func configure(model: ShoppingRecordTableViewCellModel) {
        nameLabel.text = model.name
        typeLabel.text = model.type
        dateLabel.text = model.date
        placeLabel.text = model.place
        priceLabel.text = model.price
        unitLabel.text = model.quantity
        tagLabel.text = model.color
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
