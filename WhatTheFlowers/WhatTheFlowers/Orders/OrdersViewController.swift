//
//  OrdersViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/26.
//

import UIKit

class OrdersViewController: BaseTableViewController {
    
    @IBOutlet weak var tableView: UITableView!  {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerTableViewCell(identifiers: [
                String(describing: OrderTableViewCell.self)
            ])
        }
    }

    let viewModel: OrdersViewModel

    init(viewModel: OrdersViewModel) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: OrdersViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.input.loadData()
    }

    func bindViewModel() {
        var outputs = viewModel.output

        outputs.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }

        outputs.presentEditOrderVC = { [weak self] orderID in
            let viewModel: AddOrderViewModel = AddOrderViewModel(orderID: orderID)
            let viewController = AddOrderViewController(viewModel: viewModel)
            let navigationController = MainNavigationController(rootViewController: viewController)
            self?.present(navigationController, animated: true, completion: nil)
        }

        outputs.didDeleteSuccess = { [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }

        outputs.startLoading = { [weak self] in
            self?.startLoading()
        }

        outputs.stopLoading = { [weak self] in
            self?.stopLoading()
        }

        outputs.popActionSheet = { [weak self] indexPath in
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "刪除", style: .destructive, handler: { _ in
                self?.viewModel.input.didTapDelete(indexPath: indexPath)
            })
            controller.addAction(deleteAction)
            let editAction = UIAlertAction(title: "編輯", style: .default, handler: { _ in
                self?.viewModel.input.didTapEdit(indexPath: indexPath)
            })
            controller.addAction(editAction)
            if let status = self?.viewModel.output.list[indexPath.row].status {
                switch status {
                case .normal:
                    let action = UIAlertAction(title: "改成已完成", style: .default, handler: { _ in
                        if let orderID = self?.viewModel.output.list[indexPath.row].id {
                            self?.viewModel.input.didChangeStatus(orderID: orderID, status: .finished)
                        }
                    })
                    controller.addAction(action)
                    if let sendType = self?.viewModel.output.list[indexPath.row].sendType {
                        switch sendType {
                        case .mailing:
                            let action = UIAlertAction(title: "改成待出貨", style: .default, handler: { _ in
                                if let orderID = self?.viewModel.output.list[indexPath.row].id {
                                    self?.viewModel.input.didChangeStatus(orderID: orderID, status: .notMailing)
                                }
                            })
                            controller.addAction(action)
                        case .faceToFace:
                            let action = UIAlertAction(title: "改成待面交", style: .default, handler: { _ in
                                if let orderID = self?.viewModel.output.list[indexPath.row].id {
                                    self?.viewModel.input.didChangeStatus(orderID: orderID, status: .notFaceToFace)
                                }
                            })
                            controller.addAction(action)
                        }
                    }
                case .notFaceToFace, .notMailing:
                    let action = UIAlertAction(title: "改成已完成", style: .default, handler: { _ in
                        if let orderID = self?.viewModel.output.list[indexPath.row].id {
                            self?.viewModel.input.didChangeStatus(orderID: orderID, status: .finished)
                        }
                    })
                    controller.addAction(action)
                default:
                    break
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self?.present(controller, animated: true, completion: nil)
        }
    }

}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderTableViewCell = tableView.makeCell(indexPath: indexPath)
        cell.configure(model: viewModel.output.list[indexPath.row])
//        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.didTapCell(indexPath: indexPath)
    }
}
