//
//  ListViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/04.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var nameArray = ["a","b","c"]
    
    var titleName = String()
    var detail = String()
    var urlString = String()
    
   
    var realm : Realm!
    var mylistArray: Results<Mylist>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        UserDefaults.standard.set(nameArray, forKey: "namearray")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.title = String(nameArray.count)
        print(titleName)
        
        if UserDefaults.standard.object(forKey: "namearray") != nil{
            nameArray = UserDefaults.standard.object(forKey: "namearray") as! [String]
            tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var token: NotificationToken!
        realm = try! Realm()
        mylistArray = realm.objects(Mylist.self)
        print(mylistArray as Any)
        token = mylistArray.observe { [weak self] _ in
            self?.reload()
          }

    }

    func reload() {
      tableView.reloadData()
    }

    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mylistArray.count
    }
    
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = mylistArray[indexPath.row].titleName
        
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.height/5
    }
    
    
    //セルをタッチで画面遷移（ListDetailViewController）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "next") as! ListDetailViewController
        
        nextVC.name = mylistArray[indexPath.row].titleName
        nextVC.detail = mylistArray[indexPath.row].detail
        nextVC.urlString = mylistArray[indexPath.row].urlString
        
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
