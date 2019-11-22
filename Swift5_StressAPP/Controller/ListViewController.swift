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

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var titleName = String()
    var detail = String()
    var urlString = String()
    var usedcount = Int()
    var searchResults:[String] = []
    var myListArray:[String] = []
    var realm : Realm!
    var MyList = [FireMyList]()
    var userID  =  ""
    var userName = ""
    let MyListref = Database.database().reference().child("MyList")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        title = "\(userName)'sリスト (\(MyList.count))"
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = true
        tableView.frame = CGRect(x: 0, y: 88 , width: 414, height: 725)
        
        userID = (Auth.auth().currentUser?.uid)!
        if Auth.auth().currentUser?.displayName != nil{
            userName = (Auth.auth().currentUser?.displayName)!
        }
        
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
            self.MyList.removeAll()
            self.myListArray.removeAll()
            for child in snapshot.children{
                let childSnapshoto = child as! DataSnapshot
                
                let content = FireMyList(snapshot: childSnapshoto)
                self.MyList.insert(content, at: 0)
                
                let content1 = FireMyList(snapshot: childSnapshoto).titleNameString
                self.myListArray.insert(content1, at: 0)
                
            }

            self.tableView.reloadData()
            self.navigationController?.title = String(self.MyList.count)
            self.title = "\(self.userName)'sリスト (\(self.MyList.count))"
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
        
        if searchBar.text != "" {
            return searchResults.count
        } else {
            return MyList.count
        }
    }
    
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        if searchBar.text != "" {
            cell.textLabel!.text = "\(searchResults[indexPath.row])"
        } else {
            cell.textLabel?.text = MyList[indexPath.row].titleNameString
        }
        
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.height/7
    }
    
    
    //セルをタッチで画面遷移（ListDetailViewController）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "next") as! ListDetailViewController
        
        let mylist = MyList[indexPath.row]
        
        var number = 0
        if searchBar.text != "" {
            print(indexPath.row)
            for i in 0...MyList.count - 1{
                let search = searchResults[indexPath.row]
                if  MyList[i].titleNameString.contains(search){
                    number = i
                    print(i)
                }
            }
            print(MyList[number].titleNameString)
        }
        if number == 0{
            nextVC.myLists = mylist
            nextVC.indexNumber = indexPath.row
        }else{
            //仮の値
            nextVC.myLists = MyList[number]
            nextVC.indexNumber = number
        }
    
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
//        myListArray.removeAll()
        
        self.tableView.reloadData()
        searchBar.isHidden = true
        tableView.frame = CGRect(x: 0, y: 88 , width: 414, height: 725)
    }
    
    
    //検索機能の実施
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        searchResults = myListArray.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
            
        }
        print("---------------------------------------")
        print(searchResults)
        
//        searchBar.text = ""
        
        self.tableView.reloadData()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
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
