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
        
        maneger.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //受け取り
        myListArray.removeAll()
        self.userID = userData.userID()
        self.maneger.fetch(userID: self.userID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titlenameLabel.text = myListArray[indexNumber].titleNameString
        
        detailLabel.text = myListArray[indexNumber].detail
        
        urlStringLabel.text = myListArray[indexNumber].urlString
        //URLの形か確認
        let name = "https"
        let urlString = myListArray[indexNumber].urlString
        if name.prefix(4) != urlString.prefix(4){
            urlTapButton.isEnabled = false
            
        }else{
            urlTapButton.isEnabled = true
            urlStringLabel.textColor = .systemBlue
        }
        
        //平均
        let usedCount = myListArray[indexNumber].usedCount
        let evaluation = myListArray[indexNumber].evaluation
        
        if usedCount != 0{
            let ave = Double(evaluation) / Double(usedCount)
            evaluationLabel.text = String(format: "%.1f", ave)
            usedLabel.text = "使用回数：\(usedCount)"
            
        }else{
            evaluationLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
            evaluationLabel.text = "カレンダー画面から使ってみよう!!"
            usedLabel.text = ""
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

//MARK: - fetch
extension ListDetailViewController : MyListFeatchDelegate{
    func didFetch(List: MyListData, titleNameList: String) {
        self.myListArray.insert(List, at: 0)
        print(myListArray)
    }
    
}
