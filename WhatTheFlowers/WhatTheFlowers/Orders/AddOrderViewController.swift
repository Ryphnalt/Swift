//
//  AddOrderViewController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/26.
//

import UIKit

class AddOrderViewController: BaseEditViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerTableViewCell(identifiers: [
                String(describing: TextFieldTableViewCell.self),
                String(describing: TextViewTableViewCell.self),
                String(describing: DropMenuTableViewCell.self),
                String(describing: DatePickerTableViewCell.self),
                String(describing: UploadPhotoTableViewCell.self)
            ])
        }
    }

    let viewModel: AddOrderViewModel

    init(viewModel: AddOrderViewModel) {
        self.viewModel = viewModel

        super.init(nibName: String(describing: AddOrderViewController.self), bundle: nil)
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

        viewModel.input.saveOrder()
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource {

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
            case .source(let cellModel):
                let cell: DropMenuTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .name(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .price(let cellModel):
                let cell: TextFieldTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .content(let cellModel):
                let cell: TextViewTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .sendType(let cellModel):
                let cell: DropMenuTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .deadline(let cellModel):
                let cell: DatePickerTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            case .status(let cellModel):
                let cell: DropMenuTableViewCell = tableView.makeCell(indexPath: indexPath)
                cell.configure(model: cellModel)
                cell.delegate = self
                return cell
            }
        }
    }
}

extension AddOrderViewController: UploadPhotoTableViewCellDelegate {
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

extension AddOrderViewController: DropMenuTableViewCellDelegate {
    func didSelect(_ cell: DropMenuTableViewCell, rowIndex: Int) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateSelect(indexPath, rowIndex: rowIndex)
    }

    func didTapMenuView(_ cell: DropMenuTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        removeFirstResponder()
        setTableViewContentInset(bottomInset: cell.pickerView.picker.frame.size.height)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func didTapDone(_ cell: DropMenuTableViewCell) {
        setTableViewContentInset(bottomInset: 0)
    }

    func didTapCancel(_ cell: DropMenuTableViewCell, rowIndex: Int) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        setTableViewContentInset(bottomInset: 0)
        viewModel.input.updateSelect(indexPath, rowIndex: rowIndex)
    }
}

extension AddOrderViewController: DatePickerTableViewCellDelegate {
    func didSelect(_ cell: DatePickerTableViewCell, date: Date) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateDate(indexPath, value: date)
    }

    func didTapMenuView(_ cell: DatePickerTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        removeFirstResponder()
        setTableViewContentInset(bottomInset: cell.pickerView.picker.frame.size.height + 80)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func didTapDone(_ cell: DatePickerTableViewCell) {
        setTableViewContentInset(bottomInset: 0)
    }

    func didTapCancel(_ cell: DatePickerTableViewCell, date: Date) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        setTableViewContentInset(bottomInset: 0)
        viewModel.input.updateDate(indexPath, value: date)
    }
}

extension AddOrderViewController: TextFieldTableViewCellDelegate {
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

extension AddOrderViewController: TextViewTableViewCellDelegate {
    func textViewDidBeginEditing(_ cell: TextViewTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        removePickerView()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func textViewDidEndEditing(_ cell: TextViewTableViewCell, text: String) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateText(indexPath, text: text)
    }

    func textViewDidChange(_ cell: TextViewTableViewCell, text: String) {
        guard let indexPath = tableView.indexPath(for: cell)  else { return }
        viewModel.input.updateText(indexPath, text: text)
    }
}
