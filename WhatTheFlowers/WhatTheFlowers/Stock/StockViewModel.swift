//
//  StockViewModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/15.
//

import Foundation
import Firebase

protocol StockViewModelInput {
    func loadData()
    func loadData(with keyword: String)
    func didTapCell(indexPath: IndexPath)
    func didTapDelete(indexPath: IndexPath)
    func didTapEdit(indexPath: IndexPath)
    func nextPage(indexPath: IndexPath)
}

protocol StockViewModelOutput {
    var list: [StockTableViewCellModel] { get }
    var startLoading: (() -> Void)? { get set }
    var stopLoading: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var popActionSheet: ((IndexPath) -> Void)? { get set }
    var presentEditStockVC: ((String) -> Void)? { get set }
    var didDeleteSuccess: ((IndexPath) -> Void)? { get set }
}

class StockViewModel: StockViewModelInput, StockViewModelOutput {
    var input: StockViewModelInput { return self }
    var output: StockViewModelOutput { return self }

    var reloadData: (() -> Void)?
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?
    var popActionSheet: ((IndexPath) -> Void)?
    var presentEditStockVC: ((String) -> Void)?
    var didDeleteSuccess: ((IndexPath) -> Void)?

    private(set) var list: [StockTableViewCellModel] = []
    private var lastQuery: Query? = nil
    private let perPage: Int = 30

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.stockNotification(notification:)), name: .stockChanged, object: nil)
    }

    func loadData() {
        startLoading?()
        let db = Firestore.firestore()
        var query = db.collection("stock").order(by: "name").limit(to: perPage)
        if let lastQuery = lastQuery {
            query = lastQuery
        }
        query.addSnapshotListener { (snapshot, error) in
            self.stopLoading?()
            guard let snapshot = snapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty.
                return
            }
            for document in snapshot.documents {
                let model = StockModel(dictionary: document.data())
                self.list.append(model.transformCellModel(stockID: document.documentID))
            }
            self.reloadData?()

            self.lastQuery = db.collection("stock").order(by: "name").start(afterDocument: lastSnapshot).limit(to: self.perPage)
        }
    }

    func loadData(with keyword: String) {
        let keywords = keyword.split(separator: " ")
        initData()
        reloadData?()
        startLoading?()
        let db = Firestore.firestore()
        let ref = db.collection("stock")
        let query = ref.whereField("keywords", arrayContainsAny: keywords)
        query.order(by: "name")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        return
                    }
                    for document in documents {
                        let model = StockModel(dictionary: document.data())
                        self.list.append(model.transformCellModel(stockID: document.documentID))
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
        db.collection("stock").document(list[indexPath.row].id).delete() { err in
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
        presentEditStockVC?(list[indexPath.row].id)
    }

    @objc func stockNotification(notification: Notification) {
        guard let _ = StockUserInfo(notification: notification) else {
            return
        }
        refreshData()
    }

    private func initData() {
        list = []
    }

    private func refreshData() {
        initData()
        loadData()
    }

    func nextPage(indexPath: IndexPath) {
        if indexPath.row == list.count - 5 {
            loadData()
        }
    }
}
