//
//  ListDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/04.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class ListDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titlenameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var urlStringLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet var urlTapButton: UITapGestureRecognizer!
    
    
    var myListArray = [MyListData]()
    var myList: MyListData!
    var maneger = MyListManeger()
    let MyListref = Database.database().reference().child("MyList")
    
    //前の画面からの引き継ぎ
    var indexNumber = 0
    
    //UserData
    let userData = UserData()
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.userID = userData.userID()
        
        self.maneger.fetch(userID: self.userID) { (data) in
            self.myListArray = data
            self.titlenameLabel.text = self.myListArray[self.indexNumber].titleNameString
            self.detailLabel.text = self.myListArray[self.indexNumber].detail
            
            self.urlStringLabel.text = self.myListArray[self.indexNumber].urlString
            //URLの形か確認
            let name = "https"
            let urlString = self.myListArray[self.indexNumber].urlString
            if name.prefix(4) != urlString.prefix(4){
                self.urlTapButton.isEnabled = false
                
            }else{
                self.urlTapButton.isEnabled = true
                self.urlStringLabel.textColor = .systemBlue
            }
            
            //平均
            let usedCount = self.myListArray[self.indexNumber].usedCount
            let evaluation = self.myListArray[self.indexNumber].evaluation
            
            if usedCount != 0{
                let ave = Double(evaluation) / Double(usedCount)
                self.evaluationLabel.text = String(format: "%.1f", ave)
                self.usedLabel.text = "使用回数：\(usedCount)"
                
            }else{
                self.evaluationLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
                self.evaluationLabel.text = "カレンダー画面から使ってみよう!!"
                self.usedLabel.text = ""
            }
        }
    }
    
    @IBAction func change(_ sender: Any) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "ListChange") as! ListChangeViewController
        let mylist = myListArray[indexNumber]
        nextVC.myLists = mylist
        
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! WebViewController
        nextVC.urlString = "https://www.apple.com"
        let mylist = myListArray[indexNumber]
        nextVC.urlString = mylist.urlString
    }
    
    @IBAction func webAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "webView", sender: nil)
    }
    
}

