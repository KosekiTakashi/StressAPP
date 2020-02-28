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
        
        maneger.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
       
        title = "TimeLine"
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchNameArray.removeAll()
        maneger.fetch()
        searchBar.isHidden = true
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + 20, width: 414, height: 725)

    }
}
//MARK: - DataFetch
extension SearchViewController: TimeLineDataFetchDelegate{
    
    func didFetch(List: TimeLineData, titleNameList: String) {
        
        searchNameArray.removeAll()
        nameArray.removeAll()
        
        DispatchQueue.main.async{
            self.searchNameArray.insert(List, at: 0)
            self.nameArray.insert(titleNameList, at: 0)
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
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
            if numberArray.count != 0{
                number = numberArray[indexPath.row]
                if searchNameArray.count != 0{
                    timeLineData = searchNameArray[number]
                    cell.content = timeLineData
                }
            }
            
            
            
        } else {
            if searchNameArray.count != 0 {
                let content = self.searchNameArray[indexPath.row]
                cell.content = content
            }
            
            
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
        numberArray.removeAll()
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
        let searchBarHeight = searchBar.frame.size.height
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + searchBarHeight + statusHeight , width: width, height: height)
        
    }
}

