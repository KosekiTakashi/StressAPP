//
//  SearchViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchNameArray = [Contents]()
    var userName = String()
    var titleName = String()
    var count = Int()
    var urlString = String()
    var goodUser = [String]()
    
    //var tapupcount = Int()
    let timeLinesref = Database.database().reference().child("timeLines")
        
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       
        
            
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
            
        title = "TimeLine"
        
        }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetchData()
            
            
        //新しい受け取り
        timeLinesref.observe(.value) { (snapshot) in
            self.searchNameArray.removeAll()
                
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
                let content = Contents(snapshot: childSnapshoto)
                self.searchNameArray.insert(content, at: 0)
                    
            }
            
            self.tableView.reloadData()
        }
            
        }
        
        //セクションの数
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1

        }
        
        
        //セルの数
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchNameArray.count
        }
        
        //cellの設定
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SerchTabViewCell
            let content = searchNameArray[indexPath.row]
            cell.content = content
            //tapupcount = cell.tapcount
            //print(tapupcount)
            return cell
        }
        
        //セルの高さ
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 170
        }
        
        
        //セルをタッチで画面遷移（ListDetailViewController）
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let nextVC = storyboard?.instantiateViewController(identifier: "SearchDetail") as! SearchDetailViewController
            
            nextVC.searchNameArray = searchNameArray
            nextVC.timeuserID = searchNameArray[indexPath.row].userID
            //nextVC.goodUsers = searchNameArray[indexPath.row].goodUser
            let content = searchNameArray[indexPath.row]
            nextVC.contents = content
            //nextVC.tapupcount = tapupcount
            
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
