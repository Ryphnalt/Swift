//
//  NotificationExtension.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/1.
//

import Foundation

protocol NotificationRepresentable {}

extension NotificationRepresentable {

    // 跟通知相關的鍵與名稱
    static var notificationName: Notification.Name {
        // 以實際型別的框架＋名稱來當通知名稱，避免撞名
        return Notification.Name(String(reflecting: Self.self))
    }

    static var userInfoKey: String {
        return "UserInfo"
    }

    // 將通知的隨附資訊解開成特殊型別的便利建構式
    init?(notification: Notification) {
        // 使用 Self 以取得實際上的型別（套用此協定的型別）
        guard let value = notification.userInfo?[Self.userInfoKey] as? Self else { return nil }
        self = value
    }

}

extension Notification.Name {
    static let ordersChanged = OrdersUserInfo.notificationName
    static let orderStatusChanged = OrderStatusUserInfo.notificationName
    static let shoppingRecordsChanged = ShoppingRecordsUserInfo.notificationName
    static let stockChanged = StockUserInfo.notificationName
}

extension NotificationCenter {

    // 傳送通知用的便利方法
    // T 即是代表實際被送出去的型別
    func post<T>(_ notificationRepresentable: T, object: Any? = nil) where T: NotificationRepresentable {
        post(name: T.notificationName, object: object, userInfo: [T.userInfoKey : notificationRepresentable])
    }

}

// 訂單列表改變通知事件
struct OrdersUserInfo: NotificationRepresentable {
    var isSuccess: Bool
}

// 訂單狀態改變通知事件
struct OrderStatusUserInfo: NotificationRepresentable {
    var status: OrderStatus
}

// 購買紀錄列表改變通知事件
struct ShoppingRecordsUserInfo: NotificationRepresentable {
    var isSuccess: Bool
}

// 庫存改變通知事件
struct StockUserInfo: NotificationRepresentable {
    var isSuccess: Bool
}
