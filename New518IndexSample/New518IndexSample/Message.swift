//
//  Message.swift
//  New518IndexSample
//
//  Created by Mars Lee on 2017/7/8.
//  Copyright © 2017年 Mars Lee. All rights reserved.
//

import UIKit

class Message: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var info:[String] = ["現在填寫履歷到80分，立即送您Line點數","數字科技股份有限公司讀取了您的履歷","您主動應徵了數字科技股份有限公司的行銷企劃","數字科技股份有限公司想邀請您來面試","數字科技股份有限公司說：「請問您有在找工作嗎？」"]
    
    var detail:[String] = ["廣告","1分鐘前","1小時前","3小時前","1天前"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = .clear
        button.setTitle("全部通知", for: .normal)
        button.addTarget(self, action: #selector(titleClick), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        // 註冊 cell
        //listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // 設置委任對象
        listTableView.delegate = self
        listTableView.dataSource = self
        
        
        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
        listTableView.separatorInset = .zero
        
        listTableView.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
    }
    
    func titleClick() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "列表切換",
            message: "列表想用哪種方式呈現？",
            preferredStyle: .actionSheet)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "依職缺分組",
            style: .default,
            handler: nil)
        alertController.addAction(okAction)
        
        let threeAction = UIAlertAction(
            title: "只看信件通知",
            style: .default,
            handler: nil)
        alertController.addAction(threeAction)
        
        let fiveAction = UIAlertAction(
            title: "只看來訪紀錄",
            style: .default,
            handler: nil)
        alertController.addAction(fiveAction)
        
        let fourAction = UIAlertAction(
            title: "只看線上詢問",
            style: .default,
            handler: nil)
        alertController.addAction(fourAction)
        
        let twoAction = UIAlertAction(
            title: "只看主動應徵",
            style: .default,
            handler: nil)
        alertController.addAction(twoAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            // 取得 tableView 目前使用的 cell
            //var cell = tableView.dequeueReusableCell(withIdentifier: "CellSubtitle") as! UITableViewCell
            
            let cellIdentifier = "Cell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            }
           
            
            //if (cell == nil) {
            //    cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "reuseIdentifier")
            //}
 
            //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
            
            // 設置 Accessory 按鈕樣式
            cell?.accessoryType = .disclosureIndicator
            
            cell?.backgroundColor = .clear
            
            // 顯示的內容
            if let titleLabel = cell?.textLabel {
                titleLabel.text = "\(info[indexPath.row])\n"
                titleLabel.numberOfLines = 0
            }
            
            if let detailLabel = cell?.detailTextLabel {
                detailLabel.text = "\(detail[indexPath.row])"
            }
            
            return cell!
    }
    
    // 點選 cell 後執行的動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRow(at: indexPath, animated: true)
        
        let name = info[indexPath.row]
        print("選擇的是 \(name)")
    }
}
