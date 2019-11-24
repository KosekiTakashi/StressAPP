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
    
    var searchTitleNameResults:[String] = []
    var searchUserNameResults:[String] = []
    var searchCountResults:[String] = []
    
    var nameArray:[String] = []
    var userNameArray:[String] = []
    var userCountArray:[Int] = []
    var number = 0
    var numberArray = [Int]()
    
    var content = [Contents]()
    //var tapupcount = Int()
    let timeLinesref = Database.database().reference().child("timeLines")
    var contentTest: Contents!
        
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
                
                let content2 = Contents(snapshot: childSnapshoto).userNameString
                self.userNameArray.insert(content2, at: 0)
                
                let content3 = Contents(snapshot: childSnapshoto).count
                self.userCountArray.insert(content3, at: 0)
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
        if searchBar.text != "" && numberArray != [] {
            return numberArray.count
        } else {
            return searchNameArray.count
        }
//        return searchNameArray.count
    }
        
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SerchTabViewCell

        if searchBar.text != "" &&  numberArray != []{
            for j in 0...numberArray.count - 1{
                number = numberArray[j]
            }
            print("indexpath_cell_\(indexPath.row)")
            number = numberArray[indexPath.row]
            contentTest = searchNameArray[number]
            cell.content = contentTest
            print("number_\(number)")
            
        } else {
            let content = searchNameArray[indexPath.row]
            cell.content = content
        }
        return cell
    }
        
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
        
        
    //セルをタッチで画面遷移（searchDetailViewController）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = storyboard?.instantiateViewController(identifier: "SearchDetail") as! SearchDetailViewController
        
        let content = searchNameArray[indexPath.row]
        nextVC.contents = content
      
        if  searchBar.text == "" && numberArray == []{
            print("no")
            let content = searchNameArray[indexPath.row]
            nextVC.contents = content
        } else {
            print("yes")
            number = numberArray[indexPath.row]
            let contentNumber = searchNameArray[number]
            nextVC.contents = contentNumber
            
            
            
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
            
            
    //検索機能の実施
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
        self.view.endEditing(true)
        
        searchTitleNameResults = nameArray.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        numberArray.removeAll()
        for i in 0...searchNameArray.count - 1{
            if  nameArray[i].lowercased().contains(searchBar.text!){
                number = i
                numberArray.append(number)
                
            }
            
        }
        print("numberArray_\(numberArray)")
        self.tableView.reloadData()
        
    }
        
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.placeholder = "タイトル名を入力してください"
        tableView.frame = CGRect(x: 0, y: 132 , width: 414, height: 681)
        searchBar.text = ""
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


