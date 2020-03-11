//
//  SearchTableViewCell.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/10/19.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SerchTabViewCell: UITableViewCell {
    
   
    var tapcount = 0
    var tapdowncount = 0
    var timeuserID = ""
    var userID = ""
    var goodUser = [String]()
    var good = 0
    var test = ""
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    var content:TimeLineData!{
        didSet{
            userNameLabel.text = content.userNameString
            titleNameLabel.text = content.titleNameString
            
            countLabel.text = ("ダウンロード数：\(content.count)")
            
            userImageView.layer.cornerRadius = userImageView.frame.height/2
            userImageView.sd_setImage(with: URL(string: content.userProfileImage), completed: nil)
            
       }
    }
}

