//
//  OrdersViewModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/26.
//

import Foundation
import Firebase

protocol OrdersViewModelInput {
    func loadData()
    func didTapCell(indexPath: IndexPath)
    func didTapDelete(indexPath: IndexPath)
    func didTapEdit(indexPath: IndexPath)
    func didChangeStatus(orderID: String, status: OrderStatus)
}

protocol OrdersViewModelOutput {
    var list: [OrderTableViewCellModel] { get }
    var startLoading: (() -> Void)? { get set }
    var stopLoading: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var popActionSheet: ((IndexPath) -> Void)? { get set }
    var presentEditOrderVC: ((String) -> Void)? { get set }
    var didDeleteSuccess: ((IndexPath) -> Void)? { get set }
}

class OrdersViewModel: OrdersViewModelInput, OrdersViewModelOutput {
    var input: OrdersViewModelInput { return self }
    var output: OrdersViewModelOutput { return self }

    var reloadData: (() -> Void)?
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?
    var popActionSheet: ((IndexPath) -> Void)?
    var presentEditOrderVC: ((String) -> Void)?
    var didDeleteSuccess: ((IndexPath) -> Void)?

    private let orderStatus: OrderStatus
    private(set) var list: [OrderTableViewCellModel] = []
    private var currentPage: Int = 1

    init(orderStatus: OrderStatus) {
        self.orderStatus = orderStatus

        NotificationCenter.default.addObserver(self, selector: #selector(self.ordersNotification(notification:)), name: .ordersChanged, object: nil)
    }

    func loadData() {
        startLoading?()
        let db = Firestore.firestore()
        let query = db.collection("orders")
            .whereField("status", isEqualTo: orderStatus.rawValue)
        if orderStatus == .finished {
            query.order(by: "deadline").end(at: [(currentPage-1)*30])
        } else {
            query.order(by: "deadline").start(at: [(currentPage-1)*30])
        }
        query.limit(to: 30).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard var documents = querySnapshot?.documents else {
                    return
                }
                documents.sort { a, b in
                    let deadlineA: TimeInterval = a.data()["deadline"] as? TimeInterval ?? TimeInterval()
                    let deadlineB: TimeInterval = b.data()["deadline"] as? TimeInterval ?? TimeInterval()
                    return deadlineA >= deadlineB
                }
                for document in documents {
                    let orderModel = OrderModel(dictionary: document.data())
                    self.list.append(orderModel.transformCellModel(orderID: document.documentID))
                }
                self.reloadData?()
                self.stopLoading?()
            }
        }
    }

    func didTapCell(indexPath: IndexPath) {
        popActionSheet?(indexPath)
    }

    func didTapDelete(indexPath: IndexPath) {
        startLoading?()
        let db = Firestore.firestore()
        db.collection("orders").document(list[indexPath.row].id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.list.remove(at: indexPath.row)
                self.didDeleteSuccess?(indexPath)
                self.stopLoading?()
            }
        }
    }

    func didTapEdit(indexPath: IndexPath) {
        presentEditOrderVC?(list[indexPath.row].id)
    }

    func didChangeStatus(orderID: String, status: OrderStatus) {
        let db = Firestore.firestore()
        db.collection("orders").document(orderID).updateData([
            "status": status.rawValue
        ]) { err in
            if let err = err {
                print("Error update document: \(err)")
            } else {
                NotificationCenter.default.post(OrdersUserInfo(isSuccess: true))
                NotificationCenter.default.post(OrderStatusUserInfo(status: status))
            }
        }
    }

    @objc func ordersNotification(notification: Notification) {
        guard let _ = OrdersUserInfo(notification: notification) else {
            return
        }
        refreshData()
    }

    private func refreshData() {
        list = []
        loadData()
    }

}
