//
//  PHPhotoLibraryUtil.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/8.
//

import UIKit
import Photos

enum PHPhotoLibraryUtilResult {
    case success, error, denied
}
class PHPhotoLibraryUtil {

    class func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized ||
            PHPhotoLibrary.authorizationStatus() == .notDetermined
    }

    static func saveImageInAlbum(image: UIImage, albumName: String = "",
                          completion: ((_ result: PHPhotoLibraryUtilResult) -> ())?) {
        if !isAuthorized() {
            completion?(.denied)
            return
        }
       var assetAlbum: PHAssetCollection?

       //如果指定的相册名称为空，则保存到相机胶卷。（否则保存到指定相册）
       if albumName.isEmpty {
           let list = PHAssetCollection
               .fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary,
                                              options: nil)
           assetAlbum = list[0]
       } else {
           //看保存的指定相册是否存在
           let list = PHAssetCollection
               .fetchAssetCollections(with: .album, subtype: .any, options: nil)
           list.enumerateObjects({ (album, index, stop) in
               let assetCollection = album
               if albumName == assetCollection.localizedTitle {
                   assetAlbum = assetCollection
                   stop.initialize(to: true)
               }
           })
           //不存在的话则创建该相册
           if assetAlbum == nil {
               PHPhotoLibrary.shared().performChanges({
                   PHAssetCollectionChangeRequest
                       .creationRequestForAssetCollection(withTitle: albumName)
               }, completionHandler: { (isSuccess, error) in
                self.saveImageInAlbum(image: image, albumName: albumName, completion: completion)
               })
               return
           }
       }

       //保存图片
       PHPhotoLibrary.shared().performChanges({
           //添加的相机胶卷
           let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
           //是否要添加到相簿
           if !albumName.isEmpty {
               let assetPlaceholder = result.placeholderForCreatedAsset
               let albumChangeRequset = PHAssetCollectionChangeRequest(for:
                   assetAlbum!)
               albumChangeRequset!.addAssets([assetPlaceholder!]  as NSArray)
           }
       }) { (isSuccess: Bool, error: Error?) in
           if isSuccess {
               completion?(.success)
           } else{
               print(error!.localizedDescription)
               completion?(.error)
           }
       }
    }
}

