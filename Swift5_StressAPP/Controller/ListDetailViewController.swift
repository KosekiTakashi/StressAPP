//
//  ListDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/04.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import RealmSwift

class ListDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var URLTextField: UITextField!
    
    
    var name : String = ""
    var detail : String = ""
    var urlString : String = ""
    var number : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = name
        detailTextView.text = detail
        URLTextField.text = urlString
        print(number)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    func list(){
        // Realmのインスタンスを取得
        let realm = try! Realm()
        
        let mylistArray = realm.objects(Mylist.self)
        mylistArray.first?.titleName = name

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
