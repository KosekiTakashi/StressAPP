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
    var nameArray:[String] = []
    var number = 0
    var numberArray = [Int]()
    
    var content = [TimeLineData]()
    let timeLinesref = Database.database().reference().child("timeLines")
    var timeLineData: TimeLineData!
    var maneger = TimeLineManeger()
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
        
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
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let tabbarHeight = tabBarController!.tabBar.frame.size.height
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + statusHeight  , width: width, height: height - navigationBarHeight! - statusHeight - tabbarHeight  )
        
        maneger.fetch { (data) in
            self.searchNameArray = data
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
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
        if numberArray.isEmpty{
            return searchNameArray.count
        }else{
            return numberArray.count
        }
    }
            
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SerchTabViewCell
        
        if numberArray.isEmpty{
            let content = self.searchNameArray[indexPath.row]
            cell.content = content
        }else{
            number = numberArray[indexPath.row]
            timeLineData = searchNameArray[number]
            cell.content = timeLineData
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
          
        if  numberArray.isEmpty{
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
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let tabbarHeight = tabBarController!.tabBar.frame.size.height
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + statusHeight  , width: width, height: height - navigationBarHeight! - statusHeight - tabbarHeight  )
        
    }
    //searchの実施
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        numberArray.removeAll()
        
        for (i,value) in searchNameArray.enumerated() {
            if  value.titleNameString.lowercased().contains(searchBar.text!){
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
        
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + searchBarHeight + statusHeight , width: width, height: height)
        
    }
}

