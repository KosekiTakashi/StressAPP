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
    var MyList = [FireMyList]()
    
    var userID  =  ""
    var userName = ""
    
    var searchResults:[String] = []
    var numberArray = [Int]()
    var number = 0
    var myListArray:[String] = []
    
    let MyListref = Database.database().reference().child("MyList")
        
    var testList = [FireMyList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        print(testList)
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        self.tableView.reloadData()
        searchBar.isHidden = true
        numberArray.removeAll()
        tableView.frame = CGRect(x: 0, y: 88 , width: 414, height: 725)
    }
    
    
    //検索機能の実施
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        
        searchResults = myListArray.filter{
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        
        numberArray.removeAll()
        for i in 0...MyList.count - 1{
            if  MyList[i].titleNameString.contains(searchBar.text!){
                number = i
                numberArray.append(i)
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.placeholder = "タイトル名を入力してください"
        tableView.frame = CGRect(x: 0, y: 132 , width: 414, height: 681)
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
            return MyList.count
        }
    }
    
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        if  numberArray != [] {
            number = numberArray[indexPath.row]
            cell.textLabel!.text = MyList[number].titleNameString
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
        print(numberArray)
        if  numberArray == []{
            nextVC.myLists = mylist
            nextVC.indexNumber = indexPath.row
        }else{
            number = numberArray[indexPath.row]
            nextVC.myLists = MyList[number]
            nextVC.indexNumber = number
        }
    
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if searchBar.text != "" && numberArray != []{
            print("-------------------------test2")
            print("searchResults.count_1_\(searchResults.count)")
            searchResults.remove(at: indexPath.row)
            //Firebase削除
            let listTitleName = MyList[number].titleNameString
            let listDetail = MyList[number].detail
            let ref = MyListref.child(userID).child("List")
            
            ref.queryOrdered(byChild: "titleName").queryEqual(toValue: listTitleName).observe(.childAdded) { (snapshot) in
                print("====================")
                print(snapshot.children.allObjects)
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
            MyList.remove(at: number)
            print("searchResults.count_2_\(searchResults.count)")
            
        }else{
            //Firebase削除
            let listTitleName = MyList[indexPath.row].titleNameString
            let listDetail = MyList[indexPath.row].detail
            let ref = MyListref.child(userID).child("List")
            ref.queryOrdered(byChild: "titleName").queryEqual(toValue: listTitleName).observe(.childAdded) { (snapshot) in
                print("====================")
                print(snapshot.children.allObjects)
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
            MyList.remove(at: indexPath.row)
        }
        //tableView削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}


