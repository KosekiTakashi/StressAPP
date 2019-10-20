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
    var tapupcount = Int()
    let timeLinesref = Database.database().reference().child("timeLines")
        
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        print(searchNameArray)
            
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
            
        title = "timeLine"
        
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
            tapupcount = cell.tapcount
            print(tapupcount)
            return cell
            
            /*
            let userName = cell.viewWithTag(1) as! UILabel
            userName.text = searchNameArray[indexPath.row].userNameString
            
            let titleName = cell.viewWithTag(2) as! UILabel
            titleName.text = searchNameArray[indexPath.row].titleNameString
            return cell
            */
        }
        
        //セルの高さ
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 170
        }
        
        
        //セルをタッチで画面遷移（ListDetailViewController）
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let nextVC = storyboard?.instantiateViewController(identifier: "SearchDetail") as! SearchDetailViewController
            
            nextVC.userName = searchNameArray[indexPath.row].userNameString
            nextVC.titleName = searchNameArray[indexPath.row].titleNameString
            nextVC.detail = searchNameArray[indexPath.row].detail
            nextVC.urlString = searchNameArray[indexPath.row].urlString
            nextVC.count = searchNameArray[indexPath.row].count
            nextVC.searchNameArray = searchNameArray
            nextVC.number = indexPath.row
            nextVC.tapupcount = tapupcount
            
            navigationController?.pushViewController(nextVC, animated: true)
            
        }
    
        
    //もう使ってない
    func fetchData(){
            let ref = Database.database().reference().child("timeLine").queryLimited(toLast: 20).queryOrdered(byChild: "postDate").observe(.value) { (snapShot) in
                
                self.searchNameArray.removeAll()
                
                if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapShot{
                        
                        if let postData = snap.value as? [String:Any]{
                            print("--------------------")
                            let userName = postData["userName"] as? String
                            let titleName = postData["titleName"] as? String
                            let detail = postData["detail"] as? String
                            let urlstring = postData["URL"] as? String
                            let count = postData["count"] as? Int
                            
                            var postDate:CLong?
                            
                            if let postedDate = postData["postData"] as? CLong{
                                postDate = postedDate
                            }
                        
                            self.searchNameArray.append(Contents.init(userName: userName! , titleName: titleName!, detail: detail!, urlString: urlstring!,count: count!))
                        }
                    }
                }
                
                self.tableView.reloadData()
                
                let indexPath = IndexPath(row: self.searchNameArray.count - 1, section: 0)
                if self.searchNameArray.count >= 5{
                    self.tableView.scrollToRow(at: indexPath , at: .bottom, animated: true)
                }
            }
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
