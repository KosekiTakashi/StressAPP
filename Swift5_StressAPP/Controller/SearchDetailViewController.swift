//
//  SearchDetailViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase


class SearchDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var deatailLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var userLogoImageView: UIImageView!
    
    @IBOutlet var urlTapButton: UITapGestureRecognizer!
    
    var userName :String = ""
    var titleName :String = ""
    var detail :String = ""
    var urlString :String = ""
    var count = Int()
    var userLogoImageViewString = ""
    
    var searchNameArray = [TimeLineData]()
    
    var content:TimeLineData!
    let userData = UserData()
    var userID = ""
    var timeuserID = ""
    var good = 0
    var goodUsers = [String]()
    var myListManeger = MyListManeger()
    
    var contents:TimeLineData!{
           didSet{
               userName = contents.userNameString
               count = contents.count
               titleName = contents.titleNameString
               detail = contents.detail
               urlString = contents.urlString
               timeuserID = contents.userID
               goodUsers = contents.goodUser
                userLogoImageViewString = contents.userProfileImage
            
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = userName
        titleNameLabel.text = titleName
        deatailLabel.text = detail
        urlLabel.text = urlString
        countLabel.text = "ダウンロード数：\(count)"
        print(userLogoImageViewString)
        userLogoImageView.layer.cornerRadius = userLogoImageView.frame.height/2
        userLogoImageView.sd_setImage(with: URL(string: userLogoImageViewString), completed: nil)
        
        let name = "https"
        if name.prefix(4) != urlString.prefix(4){
            urlTapButton.isEnabled = false
        }else{
            urlTapButton.isEnabled = true
            urlLabel.textColor = .systemBlue
        }
        
        userID = userData.userID()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in goodUsers{
            if i == userID{
                good = 1
            }
        }
        if good == 1 || timeuserID == userID{
            
            addButton.isEnabled = false
            addButton.title = "追加済み"
        }else{
            addButton.isEnabled = true
        }
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        myListManeger.mylistAdd(userID: userID, titleName: titleName, detail: detail, urlString: urlString, count: 0)
        
        addButton.isEnabled = false
        addButton.title = "追加済み"
        
        contents.pluslike()
        countLabel.text = "ダウンロード数：\(count)"
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! WebViewController
        nextVC.urlString = urlString
    }
    
    @IBAction func webAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "webView", sender: nil)
    }
    
}
