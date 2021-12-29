//
//  ShoppingRecordsViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/9.
//

import UIKit

class ShoppingRecordsViewController: BaseTableViewController {

    @IBOutlet weak var tableView: UITableView!  {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerTableViewCell(identifiers: [
                String(describing: ShoppingRecordTableViewCell.self)
            ])
        }
    }

    let viewModel: ShoppingRecordsViewModel = ShoppingRecordsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        viewModel.input.loadData()
    }

    func setupUI() {
        title = "購買紀錄"

        let addBarItemButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem = addBarItemButton

        let searchBarItemButton = UIBarButtonItem(barButtonSystemItem: .search,
                                               target: self,
                                               action: #selector(didTapSearch))
        navigationItem.leftBarButtonItem = searchBarItemButton
    }

    func bindViewModel() {
        var outputs = viewModel.output

        outputs.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }

        outputs.presentEditRecordVC = { [weak self] recordID in
            let viewModel: AddShoppingRecordViewModel = AddShoppingRecordViewModel(recordID: recordID)
            let viewController = AddShoppingRecordViewController(viewModel: viewModel)
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
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            self?.present(controller, animated: true, completion: nil)
        }
    }

    @objc func didTapAdd() {
        let viewModel: AddShoppingRecordViewModel = AddShoppingRecordViewModel(recordID: "")
        let viewController = AddShoppingRecordViewController(viewModel: viewModel)
        let navigationController = MainNavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc func didTapSearch() {
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil

        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }

}

extension ShoppingRecordsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        searchBar.resignFirstResponder()
        viewModel.input.loadData(with: keyword)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        setupUI()
    }

}

extension ShoppingRecordsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShoppingRecordTableViewCell = tableView.makeCell(indexPath: indexPath)
        cell.configure(model: viewModel.output.list[indexPath.row])
//        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.didTapCell(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.input.nextPage(indexPath: indexPath)
    }
}
