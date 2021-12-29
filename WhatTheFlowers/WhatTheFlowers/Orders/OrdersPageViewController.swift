//
//  OrdersPageViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/25.
//

import UIKit
import Parchment
import Firebase

class OrdersPageViewController: UIViewController {

    let orders: [OrderStatus] = [
        .normal,
        .notFaceToFace,
        .notMailing,
        .finished
    ]

    var ordersCount: [Int?] = [
        0,
        0,
        0,
        nil,
    ]

    lazy var pagingViewController: PagingViewController = {
        let pagingViewController = PagingViewController()
        pagingViewController.menuItemSize = .fixed(width: 110, height: 40)
        pagingViewController.selectedTextColor = .hexEF6A6F
        pagingViewController.indicatorColor = .hexEF6A6F
        pagingViewController.dataSource = self
        pagingViewController.select(index: 0)
        return pagingViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "訂單紀錄"

        let addBarItemButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem = addBarItemButton

        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(self.ordersNotification(notification:)), name: .ordersChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orderStatusNotification(notification:)), name: .orderStatusChanged, object: nil)

        loadOrdersCount()
    }

    @objc func ordersNotification(notification: Notification) {
        guard let _ = OrdersUserInfo(notification: notification) else {
            return
        }
        loadOrdersCount()
    }

    @objc func orderStatusNotification(notification: Notification) {
        guard let info = OrderStatusUserInfo(notification: notification) else {
            return
        }
        guard let status = Int(info.status.rawValue), status > 0 else {
            return
        }
        pagingViewController.select(index: status - 1, animated: true)
    }

    @objc func didTapAdd() {
        let viewModel: AddOrderViewModel = AddOrderViewModel(orderID: "")
        let viewController = AddOrderViewController(viewModel: viewModel)
        let navigationController = MainNavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    func loadOrdersCount() {
        let db = Firestore.firestore()
        db.collection("orders")
            .whereField("status", in: OrderStatus.allCases.map { $0.rawValue } )
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    var ordersCount1 = 0
                    var ordersCount2 = 0
                    var ordersCount3 = 0
                    for document in documents {
                        let dic = document.data()
                        if let status = dic["status"] as? String {
                            switch status {
                            case "1":
                                ordersCount1 += 1
                            case "2":
                                ordersCount2 += 1
                            case "3":
                                ordersCount3 += 1
                            case "4":
                                continue
                            default:
                                fatalError("status not exists")
                            }
                        }
                    }
                    self.ordersCount[0] = ordersCount1
                    self.ordersCount[1] = ordersCount2
                    self.ordersCount[2] = ordersCount3

                    self.pagingViewController.reloadMenu()
                }
        }
    }

}

extension OrdersPageViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return orders.count
    }

    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let viewModel = OrdersViewModel(orderStatus: orders[index])
        let viweController = OrdersViewController(viewModel: viewModel)
        return viweController
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        var title = orders[index].text
        if let count = ordersCount[index] {
            title += "(\(count))"
        }
        return PagingIndexItem(index: index, title: title)
    }
}
