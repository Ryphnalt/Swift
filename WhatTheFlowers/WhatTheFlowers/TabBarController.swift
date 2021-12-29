//
//  TabBarController.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/22.
//

import UIKit

enum TabbarVC: String {
    case homePage = "首頁"
    case shoppingRecords = "購買紀錄"
    case searchStock = "庫存查詢"
    case orderRecords = "訂單記錄"
    case countCost = "成本計算"

    var subVCName: String {
        switch self {
        case .homePage:
            return String(describing: ViewController.self)
        case .shoppingRecords:
            return String(describing: ShoppingRecordsViewController.self)
        case .searchStock:
            return String(describing: StockViewController.self)
        case .orderRecords:
            return String(describing: OrdersPageViewController.self)
        case .countCost:
            return String(describing: ViewController.self)
        }
    }

    var iconName: String {
        switch self {
        case .homePage:
            return "icTabHomepage"
        case .shoppingRecords:
            return "icTabShopping"
        case .searchStock:
            return "icTabStock"
        case .orderRecords:
            return "icTabOrder"
        case .countCost:
            return "icTabCost"
        }
    }

    func createVC() -> UIViewController {
        let ns = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls:AnyClass? = NSClassFromString(ns + "." + subVCName)
        let vcClass = cls as! UIViewController.Type
        let vc = vcClass.init()

        let image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        vc.tabBarItem.image = image
        vc.tabBarItem.title = self.rawValue

        return vc
    }
}



class TabBarController: UITabBarController {

    let subVCs: [TabbarVC] = [.homePage, .orderRecords, .shoppingRecords, .searchStock, .countCost]
    private var tabBarItems: [UITabBarItem] = []
    private var selectedVC: TabbarVC = .homePage

    override func viewDidLoad() {
        super.viewDidLoad()

        confgiureUI()
        addChildViewControllers()
    }

    private func confgiureUI() {
        tabBar.unselectedItemTintColor = .darkBlue30
        tabBar.tintColor = .hexEF6A6F
        // 當present的時候會造成tabbar有個奇怪的動畫，必須加上isTranslucent=false才不會出現
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        // 移除頂部預設邊線，這邊不使用clipsToBounds，因為這樣陰影也會不出現
        //        tabBar.clipsToBounds = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        // 添加頂部陰影
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        tabBar.layer.shadowColor = UIColor(red: 1.0/255.0, green: 31.0/255.0, blue: 63.0/255.0, alpha: 0.5).cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowRadius = 1.0

    }

    func addChildViewControllers() {
        for type in subVCs {
            let nav = MainNavigationController()
            nav.addChild(type.createVC())
            addChild(nav)
        }
    }

//    func updateChatTabbarBadge() {
//        guard let index = subVCs.firstIndex(of: .Chat) else { return }
//        let tabItem = tabBarItems[index]
//        let unreadNum = fetchUnreadQuest()
//
//        appearBadgeValue(unreadNum: unreadNum, item: tabItem)
//    }
//
//    func updateBadgeWhenTapUnreadItem() {
//
//        switch selectedVC {
//        case .notify:
//            guard let index = subVCs.firstIndex(of: .notify) else { return }
//            let tabItem = tabBarItems[index]
//            let unreadNum = fetchUnreadNotification()
//
//            appearBadgeValue(unreadNum: unreadNum, item: tabItem)
//        case .Chat:
//            guard let index = subVCs.firstIndex(of: .Chat) else { return }
//            let tabItem = tabBarItems[index]
//            let unreadNum = fetchUnreadQuest()
//
//            appearBadgeValue(unreadNum: unreadNum, item: tabItem)
//        default:
//            break
//        }
//    }

    private func appearBadgeOnDeselectItem(items: [UITabBarItem], vc: TabbarVC) {
//        switch vc {
//        case .Chat:
//            guard let index = subVCs.firstIndex(of: .notify) else { return }
//            let tabItem = items[index]
//            let unreadNum = fetchUnreadNotification()
//
//            appearBadgeValue(unreadNum: unreadNum, item: tabItem)
//        case .notify:
//            guard let index = subVCs.firstIndex(of: .Chat) else { return }
//            let tabItem = items[index]
//            let unreadNum = fetchUnreadQuest()
//
//            appearBadgeValue(unreadNum: unreadNum, item: tabItem)
//        default:
//            break
//        }
    }

    private func appearBadgeValue(unreadNum: Int, item: UITabBarItem) {
        guard unreadNum > 0 else { return }
        item.badgeValue = String(unreadNum)
    }

    private func fetchUnreadNotification() -> Int {
//        let letterUnreadNum = Defaults[.letterUnreadNum] ?? 0
//        let visitUnreadNum = Defaults[.visitUnreadNum] ?? 0
//        let unreadNum = letterUnreadNum + visitUnreadNum

        return 0
    }

    private func fetchUnreadQuest() -> Int {
        return 0
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //        if tabBar.selectedItem == item {
        //            item.badgeValue = nil
        //        }

        if let items = tabBar.items,
           let index = items.firstIndex(of: item) {
            self.tabBarItems = items
            self.selectedVC = subVCs[index]
            //            appearBadgeOnDeselectItem(items: items, vc: subVCs[index])
            detectWhichTabBarIsPressed(vc: subVCs[index])
        }
    }

    func changeTab(_ subVC: TabbarVC) {
        guard let index = subVCs.firstIndex(of: subVC) else { return }
        self.selectedIndex = index
    }

    private func detectWhichTabBarIsPressed(vc: TabbarVC) {

        switch vc {

        case .homePage:
//            FirebaseAdapter.logEvent(parameter: .init(screen: .none), "click_tabbar_findjob")
            break

        case .shoppingRecords:
//            FirebaseAdapter.logEvent(parameter: .init(screen: .none), "click_tabbar_message")
            break

        case .searchStock:
//            FirebaseAdapter.logEvent(parameter: .init(screen: .none), "click_tabbar_alert")
            break

        case .orderRecords:
//            FirebaseAdapter.logEvent(parameter: .init(screen: .none), "click_tabbar_member")
            break

        case .countCost:
            break
        }
    }
}
