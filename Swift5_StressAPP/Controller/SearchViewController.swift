//
//  SearchViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var searchNameArray = ["d","e","f"]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.delegate = self
            tableView.dataSource = self
            print(searchNameArray)
            
            UserDefaults.standard.set(searchNameArray, forKey: "serachNameArray")

        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            
            if UserDefaults.standard.object(forKey: "serachNameArray") != nil{
                searchNameArray = UserDefaults.standard.object(forKey: "serachNameArray") as! [String]
                print(searchNameArray)
                tableView.reloadData()
            }
            
            tableView.reloadData()
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
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            
            cell.textLabel?.text = searchNameArray[indexPath.row]
            
            return cell
        }
        
        //セルの高さ
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return view.frame.size.height/5
        }
        
        
        //セルをタッチで画面遷移（ListDetailViewController）
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let nextVC = storyboard?.instantiateViewController(identifier: "SearchDetail") as! SearchDetailViewController
            
            nextVC.name = searchNameArray[indexPath.row]
            print(indexPath.row)
            nextVC.number = indexPath.row
            
            navigationController?.pushViewController(nextVC, animated: true)
            
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

