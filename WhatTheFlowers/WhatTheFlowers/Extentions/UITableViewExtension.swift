//
//  UITableViewExtension.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

import UIKit

extension UITableView {

    func registerTableViewCell(identifiers: [String]) {
        for identifier in identifiers {
            let nibCell = UINib(nibName: identifier, bundle: nil)
            self.register(nibCell, forCellReuseIdentifier: identifier)
        }
    }

    func registerTableViewHeaderFooter(identifiers: [String]) {
        for identifier in identifiers {
            let nibCell = UINib(nibName: identifier, bundle: nil)
            self.register(nibCell, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    func createCell<T: UITableViewCell>(indexPath: IndexPath) -> T {

        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {

            fatalError("遺失 \(String(describing: T.self)) 註冊檔")
        }

        return cell
    }

    func makeCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
//        print(String(describing: T.self))
        guard let cell = dequeueReusableCell(
                withIdentifier: String(describing: T.self),
                for: indexPath
            ) as? T else {
                fatalError("遺失 \(String(describing: T.self)) 註冊檔")
        }

        return cell
    }

    func register(forCellReuseIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            let nibCell = UINib(nibName: identifier, bundle: nil)
            register(nibCell, forCellReuseIdentifier: identifier)
        }
    }

    func register(forHeaderFooterViewReuseIdentifiers identifiers: [String]) {
        for identifier in identifiers {
            let nibCell = UINib(nibName: identifier, bundle: nil)
            register(nibCell, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }

    func makeHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: T.self)
            ) as? T else {
                fatalError("遺失 \(String(describing: T.self)) 註冊檔")
        }

        return view
    }
}
