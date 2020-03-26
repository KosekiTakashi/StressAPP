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
    
    var myList = [MyListData]()
    var numberArray = [Int]()
    var number = 0
    
    let MyListref = Database.database().reference().child("MyList")
    var manegar = MyListManeger()
    
    let userData = UserData()
    var userID = ""
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        userID = userData.userID()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userID = userData.userID()
        
        searchBar.isHidden = true
        
        if let navigationBarHeight = navigationController?.navigationBar.frame.size.height{
            let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let tabbarHeight = tabBarController!.tabBar.frame.size.height
            tableView.frame = CGRect(x: 0, y: navigationBarHeight + statusHeight  , width: width, height: height - navigationBarHeight - statusHeight - tabbarHeight  )
            
        }
        
        manegar.fetch(userID: userID) { (data) in
            print("fetch_ex")
            print(data)
            self.myList = data
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
                
            }
        }
        
        
    }
    
    //MARK: - Search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        numberArray.removeAll()
        tableView.reloadData()
        
        if let navigationBarHeight = navigationController?.navigationBar.frame.size.height{
            
            let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let tabbarHeight = tabBarController!.tabBar.frame.size.height
            tableView.frame = CGRect(x: 0, y: navigationBarHeight + statusHeight  , width: width, height: height - navigationBarHeight - statusHeight - tabbarHeight  )
        }
        searchBar.isHidden = true
    }
    
    
    //検索機能の実施
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        numberArray.removeAll()
        
        for (i,value) in myList.enumerated() {
            
            if value.titleNameString.contains(searchBar.text!){
                number = i
                numberArray.append(i)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func searchPressed(_ sender: Any) {
        searchBar.isHidden = false
        searchBar.placeholder = "タイトル名を入力してください"
        
        if let navigationBarHeight = navigationController?.navigationBar.bounds.size.height{
            let searchBarHeight = searchBar.frame.size.height
            let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            tableView.frame = CGRect(x: 0, y: navigationBarHeight + searchBarHeight + statusHeight , width: width, height: height)
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
        
        if numberArray.isEmpty{
            return myList.count
        }else{
            return numberArray.count
        }
        
    }
    
    //cellの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as? MyListCell
        else{
            fatalError("not found")
        }
        
        if numberArray.isEmpty{
            cell.titleLabel.text = myList[indexPath.row].titleNameString
            cell.evaluationLabel.text = "使用回数：\(myList[indexPath.row].usedCount)"
        }else{
            number = numberArray[indexPath.row]
            cell.titleLabel.text = myList[number].titleNameString
            cell.evaluationLabel.text = "使用回数：\(myList[number].usedCount)"
        }
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/7
    }
    
    //セルをタッチで画面遷移（ListDetailViewController）
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "next")
            as! ListDetailViewController
        
        if  numberArray.isEmpty {
            nextVC.indexNumber = indexPath.row
        }else{
            number = numberArray[indexPath.row]
            nextVC.indexNumber = number
        }
    
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if numberArray.isEmpty{
            //Firebase削除
            let listTitleName = myList[indexPath.row].titleNameString
            let listDetail = myList[indexPath.row].detail
            let ref = MyListref.child(userID).child("List")
            ref.queryOrdered(byChild: "titleName")
                .queryEqual(toValue: listTitleName).observe(.childAdded) { (snapshot) in
                    
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    for child in result {
                        let orderID = child.value as? String//get autoID
                        if orderID == listDetail{
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
            
        }else{
            //Firebase削除
            let listTitleName = myList[number].titleNameString
            let listDetail = myList[number].detail
            let ref = MyListref.child(userID).child("List")
            
            ref.queryOrdered(byChild: "titleName").queryEqual(toValue: listTitleName)
                .observe(.childAdded) { (snapshot) in
                    
                if let result = snapshot.children.allObjects as? [DataSnapshot] {

                    for child in result {

                        let orderID = child.value as? String//get autoID
                        if orderID == listDetail{
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
        }
        //tableView削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}


