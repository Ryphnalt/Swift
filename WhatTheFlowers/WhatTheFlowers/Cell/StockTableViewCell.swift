//
//  StockTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/16.
//

import UIKit
import Firebase
import Kingfisher

struct StockTableViewCellModel {
    var id: String = ""
    var name: String = ""
    var type: String = ""
    var color: String = ""
    var size: String = ""
    var price: String = ""
    var quantity: String = ""
    var date: String = ""
    var photoName: String = ""
}

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: StockTableViewCellModel) {
        nameLabel.text = model.name
        dateLabel.text = model.date
        priceLabel.text = model.price
        sizeLabel.text = model.size
        quantityLabel.text = model.quantity
        tagLabel.text = model.color
        tagView.isHidden = model.color.isEmpty
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
