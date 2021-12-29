//
//  AddStockViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/15.
//

import UIKit

class AddStockViewController: BaseEditViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerTableViewCell(identifiers: [
                String(describing: TextFieldTableViewCell.self),
                String(describing: DoubleDropMenuTableViewCell.self),
                String(describing: UploadPhotoTableViewCell.self)
            ])
        }
    }
    
    let viewModel: AddStockViewModel

    init(viewModel: AddStockViewModel) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: AddStockViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.output.title

        setupUI()
        bindViewModel()
        viewModel.input.loadData()
    }

    func setupUI() {
        baseTableView = tableView

        let closeBarItemButton = UIBarButtonItem(barButtonSystemItem: .close,
                                                 target: self,
                                                 action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = closeBarItemButton

        let saveBarItemButton = UIBarButtonItem(barButtonSystemItem: .save,
                                                target: self,
                                                action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = saveBarItemButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func bindViewModel() {
        var outputs = viewModel.output

        outputs.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }

        outputs.closeVC = { [weak self] in
            self?.didTapClose()
        }

        outputs.changeSaveButtonStatus = { [weak self] isEnabled in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }

        outputs.startLoading = { [weak self] in
            self?.startLoading()
        }

        outputs.stopLoading = { [weak self] in
            self?.stopLoading()
        }
    }

    @objc func didTapSave() {
        navigationItem.rightBarButtonItem?.isEnabled = false

        removeFirstResponder()

        viewModel.input.saveStock()
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddStockViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.output.sections[section] {
        case .basic(let rows):
            return rows.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.output.sections[indexPath.section] {
        case .basic(let rows):
            let row = rows[indexPath.row]
            switch row {
            case .photo(let cellModel):
                let cell: UploadPhotoTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .name(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .color(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .length(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .width(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .height(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .goodsType(let cellModel):
                let cell: DoubleDropMenuTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .price(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .quantity(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .unit(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            }
        }
    }
}

extension AddStockViewController: UploadPhotoTableViewCellDelegate {
    func presentVC(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func updatePhoto(_ cell: UploadPhotoTableViewCell, photoName: String) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updatePhoto(indexPath, photoName: photoName)
    }

    func deletePhoto(_ cell: UploadPhotoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.deletePhoto(indexPath)
    }

    func uploading(_ cell: UploadPhotoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.uploading(indexPath)
    }

    func uploadSuccess(_ cell: UploadPhotoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.uploadSuccess(indexPath)
    }
}

extension AddStockViewController: DoubleDropMenuTableViewCellDelegate {
    func didSelect(_ cell: DoubleDropMenuTableViewCell, values: [String]) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateMultiSelect(indexPath, values: values)
    }

    func didTapMenuView(_ cell: DoubleDropMenuTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        removeFirstResponder()
        setTableViewContentInset(bottomInset: cell.pickerView.picker.frame.size.height)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func didTapDone(_ cell: DoubleDropMenuTableViewCell) {
        setTableViewContentInset(bottomInset: 0)
    }

    func didTapCancel(_ cell: DoubleDropMenuTableViewCell, values: [String]) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        setTableViewContentInset(bottomInset: 0)
        viewModel.input.updateMultiSelect(indexPath, values: values)
    }
}

extension AddStockViewController: TextFieldTableViewCellDelegate {
    func textFieldDidBeginEditing(_ cell: TextFieldTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        removePickerView()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func textFieldDidEndEditing(_ cell: TextFieldTableViewCell, text: String) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateText(indexPath, text: text)
    }

    func textFieldDidChange(_ cell: TextFieldTableViewCell, text: String) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateText(indexPath, text: text)
    }
}
