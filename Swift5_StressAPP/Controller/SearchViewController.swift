//
//  SearchViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var searchNameArray = [Contents]()
    var userName = String()
    var titleName = String()
    var count = Int()
    var urlString = String()
    var goodUser = [String]()
    
    var searchNameResults:[String] = []
    var searchUserIDResults:[String] = []
    var nameArray:[String] = []
    var userIDArray:[String] = []
    var number = 0
    
    //var tapupcount = Int()
    let timeLinesref = Database.database().reference().child("timeLines")
        
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
       
        title = "TimeLine"
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = true
        tableView.frame = CGRect(x: 0, y: 88 , width: 414, height: 725)
            
        //新しい受け取り
        timeLinesref.observe(.value) { (snapshot) in
            self.searchNameArray.removeAll()
                
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
                
                let content = Contents(snapshot: childSnapshoto)
                self.searchNameArray.insert(content, at: 0)
                
                let content1 = Contents(snapshot: childSnapshoto).titleNameString
                self.nameArray.insert(content1, at: 0)
                
                let content2 = Contents(snapshot: childSnapshoto).userID
                self.userIDArray.insert(content1, at: 0)
                    
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
//        if searchBar.text != "" {
//            return searchResults.count
//        } else {
//            return searchNameArray.count
//        }
        return searchNameArray.count
            
    }
        
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SerchTabViewCell
//
//        if searchBar.text != "" {
//            cell.textLabel!.text = "\(searchResults[indexPath.row])"
//        } else {
//            let content = searchNameArray[indexPath.row]
//            cell.content = content
//        }
        
        let content = searchNameArray[indexPath.row]
        cell.content = content
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
        
        for i in 0...searchNameArray.count - 1{
            let name = searchNameResults[indexPath.row]
            let userID = searchUserIDResults[indexPath.row]
            
            if  searchNameArray[i].titleNameString.contains(name) && searchNameArray[i].userID.contains(userID)  {
                number = i
                print(i)
            }else{
                print("一致なし")
            }
        }
        
            
        navigationController?.pushViewController(nextVC, animated: true)
            
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
       
        self.tableView.reloadData()
        searchBar.isHidden = true
        tableView.frame = CGRect(x: 0, y: 88 , width: 414, height: 725)
    }
            
            
    //検索機能の実施(まだ未使用)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        self.view.endEditing(true)
                
        searchNameResults = nameArray.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        searchUserIDResults = nameArray.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        self.tableView.reloadData()
        
    }
        
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.text = "まだ使えない"
        tableView.frame = CGRect(x: 0, y: 132 , width: 414, height: 681)
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


