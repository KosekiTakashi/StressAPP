//
//  ListViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/04.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var titleName = String()
    var detail = String()
    var urlString = String()
    var usedcount = Int()
    var myList = [MyListData]()
    
    var userID  =  UserData.userID
    var userName = UserData.userName
    
    var searchResults:[String] = []
    var numberArray = [Int]()
    var number = 0
    var myListArray:[String] = []
    
    let MyListref = Database.database().reference().child("MyList")
    var manegar = MyListManeger()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manegar.delegate = self
//        self.manegar.fetch()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        print("viewDidLoad")
        print(self.myList)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manegar.fetch()
        searchBar.isHidden = true
        
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! , width: 414, height: 725)
        
        print("viewWillAppear")
        print(myList)
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        numberArray.removeAll()
        tableView.reloadData()
        
        searchBar.isHidden = true
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! , width: 414, height: 725)
    }
    
    
    //検索機能の実施
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        searchResults = myListArray.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        numberArray.removeAll()
        for i in 0...myList.count - 1{
            if  myList[i].titleNameString.contains(searchBar.text!){
                number = i
                numberArray.append(i)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.placeholder = "タイトル名を入力してください"
        
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height
        let searchBarHeight = searchBar.frame.size.height
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        
        tableView.frame = CGRect(x: 0, y: navigationBarHeight! + searchBarHeight + 20 , width: 414, height: 681)
    }
}

//MARK: - Fetch
extension ListViewController: MyListFeatchDelegate{
    
    func didFetch(List: MyListData, titleNameList: String) {
        
        myListArray.removeAll()
        myList.removeAll()
        
        DispatchQueue.main.async{
            self.myList.insert(List, at: 0)
            self.myListArray.insert(titleNameList, at: 0)
            let userData = UserData()
            let username = userData.userNameData()
            self.navigationController?.title = String(self.myList.count)
            self.title = "\(username)'sリスト (\(self.myList.count))"
        }
        
        
        DispatchQueue.main.async{
            print("protcol")
            print(self.myList)
            
            self.tableView.reloadData()
            
        }
        
    }
}

//MARK: - TableView

extension ListViewController: UITableViewDelegate,UITableViewDataSource{
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if numberArray != []  {
           return searchResults.count
            
        } else {
            return myList.count
        }
    }
    
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        if  numberArray != [] {
            number = numberArray[indexPath.row]
            cell.textLabel!.text = myList[number].titleNameString
        } else {
            cell.textLabel?.text = myList[indexPath.row].titleNameString
            
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
        let mylist = myList[indexPath.row]
        if  numberArray == []{
            nextVC.myLists = mylist
            nextVC.indexNumber = indexPath.row
            
        }else{
            number = numberArray[indexPath.row]
            nextVC.myLists = myList[number]
            nextVC.indexNumber = number
            
        }
    
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if numberArray != []{
            searchResults.remove(at: indexPath.row)
            //Firebase削除
            let listTitleName = myList[number].titleNameString
            let listDetail = myList[number].detail
            let ref = MyListref.child(userID).child("List")
            
            ref.queryOrdered(byChild: "titleName").queryEqual(toValue: listTitleName).observe(.childAdded) { (snapshot) in
                if let result = snapshot.children.allObjects as? [DataSnapshot] {

                    for child in result {

                        let orderID = child.value as? String//get autoID
                        if orderID == listDetail{
                            print(orderID!)
                            snapshot.ref.removeValue(completionBlock: { (error, reference) in
                                if error != nil {
                                    print("There has been an error:\(String(describing: error))")
                                }
                            })
                        }
                    }
                }
            }
            myList.remove(at: number)
            
        }else{
            
            //Firebase削除
            let listTitleName = myList[indexPath.row].titleNameString
            let listDetail = myList[indexPath.row].detail
            let ref = MyListref.child(userID).child("List")
            ref.queryOrdered(byChild: "titleName").queryEqual(toValue: listTitleName).observe(.childAdded) { (snapshot) in
                if let result = snapshot.children.allObjects as? [DataSnapshot] {

                    for child in result {

                        let orderID = child.value as? String//get autoID
                        if orderID == listDetail{
                            print(orderID!)
                            snapshot.ref.removeValue(completionBlock: { (error, reference) in
                                if error != nil {
                                    print("There has been an error:\(String(describing: error))")
                                }
                            })
                        }
                    }
                }
            }
            
            //List削除
            myList.remove(at: indexPath.row)
            print(myList.count)
            
        }
        //tableView削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}


