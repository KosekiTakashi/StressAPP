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
    
    
    var titleName : String = ""
    var detail : String = ""
    var urlString : String = ""
    var usedCount = 0
    var evaluation = 0
    
    var myListArray = [MyListData]()
    var myList: MyListData!
    var maneger = MyListManeger()
    
    let MyListref = Database.database().reference().child("MyList")
    var indexNumber = 0
    
    var myLists:MyListData!{
        didSet{
            titleName = myLists.titleNameString
            detail = myLists.detail
            urlString = myLists.urlString
            usedCount = myLists.usedCount
            evaluation = myLists.evaluation
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlenameLabel.text = titleName
        detailLabel.text = detail
        
        
        if usedCount != 0{
            let ave = evaluation / usedCount
            evaluationLabel.text = "\(ave) (使用回数：\(usedCount))"
            
        }else{
            evaluationLabel.text = "未使用です"
        }
        self.titlenameLabel.text = titleName
        self.detailLabel.text = detail
        self.urlStringLabel.text = urlString
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //受け取り
        myListArray.removeAll()
        self.maneger.fetch()
        print(myListArray)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(myListArray)
        


    }
    
    
    @IBAction func change(_ sender: Any) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "ListChange") as! ListChangeViewController
        let mylist = myListArray[indexNumber]
        nextVC.myLists = mylist
        
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
}

extension ListDetailViewController : MyListFeatchDelegate{
    func didFetch(List: MyListData, titleNameList: String) {
        self.myListArray.insert(List, at: 0)
        
    }
    
    
    
}
