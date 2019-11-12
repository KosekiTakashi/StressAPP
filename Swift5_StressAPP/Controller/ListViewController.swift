//
//  ListViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/04.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleName = String()
    var detail = String()
    var urlString = String()
    var usedcount = Int()
    
    var realm : Realm!
    
    
    var MyList = [FireMyList]()
    var userID  =  ""
    var userName = ""
    let MyListref = Database.database().reference().child("MyList")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        title = "\(userName)'sリスト (\(MyList.count))"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(userID)
        
        userID = (Auth.auth().currentUser?.uid)!
        
        if Auth.auth().currentUser?.displayName != nil{
            userName = (Auth.auth().currentUser?.displayName)!
        }
        
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
            self.MyList.removeAll()
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
                let content = FireMyList(snapshot: childSnapshoto)
                self.MyList.insert(content, at: 0)
                    
            }
            self.tableView.reloadData()
            self.navigationController?.title = String(self.MyList.count)
        }
        
        title = "\(userName)'sリスト (\(MyList.count))"
        
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
        return MyList.count
    }
    
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = MyList[indexPath.row].titleNameString
        
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.height/6
    }
    
    
    //セルをタッチで画面遷移（ListDetailViewController）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "next") as! ListDetailViewController
        
        let mylist = MyList[indexPath.row]
        nextVC.myLists = mylist
        nextVC.indexNumber = indexPath.row
        
        
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
