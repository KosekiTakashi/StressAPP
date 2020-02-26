//
//  DiarViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/14.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit

class DiarDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stressCountLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    
    
    var titleName = String()
    var stresscount:Int = 0
    var selectedList = String()
    var result = String()
    var evaluation:Int = 0
    
    var diary:Diary!{
        didSet{
            titleName = diary.titleName
            stresscount = diary.stressCount
            selectedList = diary.selectedList
            result = diary.result
            evaluation = diary.evaluation
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleName
        stressCountLabel.text = "\(stresscount)"
        listLabel.text = selectedList
        resultLabel.text = result
        evaluationLabel.text = "\(evaluation)"
    }
    
}
