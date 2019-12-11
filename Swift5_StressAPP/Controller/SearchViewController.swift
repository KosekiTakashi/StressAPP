//
//  SearchViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchNameArray = [TimeLineData]()
    var userName = String()
    var titleName = String()
    var count = Int()
    var urlString = String()
    var goodUser = [String]()
    
    var searchTitleNameResults:[String] = []
    var searchUserNameResults:[String] = []
    var searchCountResults:[String] = []
    
    var nameArray:[String] = []
    var number = 0
    var numberArray = [Int]()
    
    var content = [TimeLineData]()
    //var tapupcount = Int()
    let timeLinesref = Database.database().reference().child("timeLines")
    var timeLineData: TimeLineData!
    var maneger = TimeLineManeger()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        maneger.delegate = self
       
        title = "TimeLine"
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = true
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height
        
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + 20, width: 414, height: 725)
            
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        myListArray.removeAll()
//        myList.removeAll()
//        manegar.delegate = self
//        self.manegar.fetch()
        searchNameArray.removeAll()
        nameArray.removeAll()
        maneger.fetch()
        
        
    }
}
//MARK: - DataFetch
extension SearchViewController: TimeLineDataFetchDelegate{
    func didFetch(List: TimeLineData, titleNameList: String) {
        
        self.searchNameArray.insert(List, at: 0)
        self.nameArray.insert(titleNameList, at: 0)
        self.tableView.reloadData()
    }
    
    
}

//MARK: - TableView
extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
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
    }
            
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SerchTabViewCell

        if numberArray != []{
            for j in 0...numberArray.count - 1{
                number = numberArray[j]
            }
            number = numberArray[indexPath.row]
            timeLineData = searchNameArray[number]
            cell.content = timeLineData
            print("number_\(number)")
        } else {
            print(searchNameArray[indexPath.row])
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
}
//MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate{
    //cancelの実施
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        self.tableView.reloadData()
        searchBar.isHidden = true
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height
        
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + 20 , width: 414, height: 725)
    }
    //searchの実施
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
        self.tableView.reloadData()
    }
    
    //bottan
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.placeholder = "タイトル名を入力してください"
        
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height
        print(navigationBarHeight!)
        let searchBarHeight = searchBar.frame.size.height
        
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + searchBarHeight + 20 , width: 414, height: 681)
        
    }
}

