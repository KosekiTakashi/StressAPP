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
    
    
    @IBOutlet weak var titlenameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var urlStringLabel: UILabel!
    
    
    var titleName : String = ""
    var detail : String = ""
    var urlString : String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlenameLabel.text = titleName
        detailLabel.text = detail
        urlStringLabel.text = urlString
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    
    @IBAction func change(_ sender: Any) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "ListChange") as! ListChangeViewController
        nextVC.titleName = titleName
        nextVC.detail = detail
        nextVC.urlString = urlString
    
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
