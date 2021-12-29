//
//  UploadPhotoTableViewCell.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/2.
//

import UIKit
import Photos
import PhotosUI
import Firebase
import Kingfisher

struct UploadPhotoTableViewCellModel {
    var photoName: String = ""
}

protocol UploadPhotoTableViewCellDelegate: AnyObject {
    func presentVC(_ viewController: UIViewController)
    func updatePhoto(_ cell: UploadPhotoTableViewCell, photoName: String)
    func deletePhoto(_ cell: UploadPhotoTableViewCell)
    func uploading(_ cell: UploadPhotoTableViewCell)
    func uploadSuccess(_ cell: UploadPhotoTableViewCell)
}

class UploadPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var uploadPhotoImageView: UIImageView! {
        didSet {
            uploadPhotoImageView.addTap(target: self, action: #selector(didTapUploadPhoto))
        }
    }

    @IBOutlet weak var loadingMaskView: UIView! {
        didSet {
            loadingMaskView.isHidden = true
        }
    }

    @IBOutlet weak var loadingProgressView: UIProgressView! {
        didSet {
            loadingProgressView.isHidden = true
        }
    }

    weak var delegate: UploadPhotoTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(model: UploadPhotoTableViewCellModel) {
        if !model.photoName.isEmpty {
            let storageRef = Storage.storage().reference()
            let imagesRef = storageRef.child("photos/\(model.photoName)")
            imagesRef.downloadURL { url, error in
                if let error = error {
                    print(error)
                } else {
                    self.uploadPhotoImageView.kf.setImage(with: url, placeholder: UIImage(named: "imgPhotoPlaceholder"))
                }
            }
        }
    }

    @objc func didTapUploadPhoto() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "開啟相機", style: .default, handler: { _ in
            self.delegate?.presentVC(self.initImagePickerViewController())
        })
        controller.addAction(deleteAction)
        let editAction = UIAlertAction(title: "從相簿選取", style: .default, handler: { _ in
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        DispatchQueue.main.async {
                            self.delegate?.presentVC(self.initPHPickerViewController())
                        }
                    }
                }
            case .authorized:
                self.delegate?.presentVC(self.initPHPickerViewController())
            default:
                print("請到設定開啟相簿權限")
            }
        })
        controller.addAction(editAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        delegate?.presentVC(controller)
    }

    private func initImagePickerViewController() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
//        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }

    private func initPHPickerViewController() -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }
}

extension UploadPhotoTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        let previousImage = uploadPhotoImageView.image
        guard let image = info[.originalImage] as? UIImage,
              uploadPhotoImageView.image == previousImage else {
            return
        }
        uploadPhotoImageView.image = image
        delegate?.deletePhoto(self)
        uploadPhoto(image: image)
    }

    private func uploadPhoto(image: UIImage) {
        let photoName = "\(Date().timeIntervalSince1970).jpg"
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("photos/\(photoName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        guard let data = image.jpegData(compressionQuality: 1.0) else { return }

        loadingMaskView.isHidden = false
        loadingProgressView.isHidden = false

        let uploadTask = imagesRef.putData(data, metadata: metadata)

        uploadTask.observe(.resume) { snapshot in
            print("UploadTask resume:")
            print(snapshot)
        }

        uploadTask.observe(.pause) { snapshot in
            print("UploadTask pause:")
            print(snapshot)
        }

        uploadTask.observe(.progress) { snapshot in
            print("UploadTask progress:")
            self.delegate?.uploading(self)
            let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount)
            / Float(snapshot.progress!.totalUnitCount)
            print(percentComplete)
            self.loadingProgressView.progress = percentComplete
        }

        uploadTask.observe(.success) { snapshot in
            print("UploadTask success:")
            print(snapshot)
            self.loadingMaskView.isHidden = true
            self.loadingProgressView.isHidden = true
            self.delegate?.updatePhoto(self, photoName: photoName)
            self.delegate?.uploadSuccess(self)
        }

        uploadTask.observe(.failure) { snapshot in
            print("UploadTask failure:")
            print(snapshot)
            self.loadingMaskView.isHidden = true
            self.loadingProgressView.isHidden = true
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File doesn't exist.")
                case .unauthorized:
                    print("User doesn't have permission to access file.")
                case .cancelled:
                    print("User canceled the upload.")
                case .unknown:
                    print("Unknown error occurred, inspect the server response.")
                default:
                    print("A separate error occurred. This is a good place to retry the upload.")
                }
            }
        }
    }
}

extension UploadPhotoTableViewCell: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = uploadPhotoImageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage,
                          self.uploadPhotoImageView.image == previousImage else {
                        return
                    }
                    self.uploadPhotoImageView.image = image
                    self.delegate?.deletePhoto(self)
                    self.uploadPhoto(image: image)
                }
            }
        }
    }

}
