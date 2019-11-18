//
//  CalendarAddViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class CalendarAddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventNameTextView: UITextView!
    @IBOutlet weak var stressLabel: UILabel!
    @IBOutlet weak var myListPicker: UIPickerView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var myListNameLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var animationView2: AnimationView!
    @IBOutlet weak var animationView3: AnimationView!
    @IBOutlet weak var animationView4: AnimationView!
    @IBOutlet weak var animationView5: AnimationView!
    
    let animation = Animation.named("star1")
    var dateString = ""
    var timeString = ""
    var titleName = String()
    var stresscount:Int = 0
    var selectedList = String()
    var result = String()
    var evaluation:Int = 0
    var userID = (Auth.auth().currentUser?.uid)!
    
    var MyList = [FireMyList]()
    let MyListref = Database.database().reference().child("MyList")
    var indexNumber = 0
    var select : FireMyList?
    
    var diary: Diary!
    let dp = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myListPicker.delegate = self
        myListPicker.dataSource = self
        dateTextField.delegate = self
        dp.datePickerMode = UIDatePicker.Mode.dateAndTime
        dp.timeZone = NSTimeZone.local
        dp.locale = Locale.current
        dp.addTarget(self, action: #selector(datechange), for: .valueChanged)
        dateTextField.inputView = dp
        dateTextField.inputView = dp
        
        eventNameTextView.delegate = self
        resultTextView.delegate = self
        
        animationView.animation = animation
        animationView2.animation = animation
        animationView3.animation = animation
        animationView4.animation = animation
        animationView5.animation = animation
        
    }
    
    @objc func datechange(sender:UIDatePicker){
        let dateformatter = DateFormatter()
        let timeformatter1 = DateFormatter()
        let formatter = DateFormatter()
        
        timeformatter1.dateFormat = "hh:mm"
        dateformatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        
        dateString = "\(dateformatter.string(from: sender.date))"
        timeString = "\(timeformatter1.string(from: sender.date))"
        dateTextField.text = "\(formatter.string(from: sender.date))"
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        titleName = eventNameTextView.text!
        result = resultTextView.text!
        
        dateTextField.resignFirstResponder()
        eventNameTextView.resignFirstResponder()
        resultTextView.resignFirstResponder()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MyListを追加
        let userID = (Auth.auth().currentUser?.uid)!
        MyListref.child(userID).child("List").observe(.value) { (snapshot) in
           self.MyList.removeAll()
           for child in snapshot.children{
               let childSnapshoto = child as! DataSnapshot
               let content = FireMyList(snapshot: childSnapshoto)
               self.MyList.insert(content, at: 0)
           }
            print(self.MyList)
            self.myListPicker.reloadAllComponents()
        }
    }
   
    @IBAction func stressSlider(_ sender: UISlider) {
        
        stresscount = Int(sender.value)
        stressLabel.text = String(stresscount)
        
        //colorChange
        switch stresscount {
        case 0...3:
            sender.tintColor = .yellow
        case 4...7:
            sender.tintColor = .orange
        case 8...10:
            sender.tintColor = .red
        default:
            print("error")
        }
    }
    
    //Pickerの設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MyList.count
        //return testArray.count
    }
    
    //表示する文字列を指定する
    //PickerViewに表示する配列の要素数を設定する
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return MyList[row].titleNameString
        //return testArray[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedList = MyList[row].titleNameString
        select = MyList[row]
        myListNameLabel.text = selectedList
        
    }
    
   
  

    @IBAction func star(_ sender: UIButton) {
        
        let starcount =  sender.currentTitle!
        
        //もっと綺麗に書きたい
        switch starcount {
        case "1":
            evaluation = 1
            animationView.play()
            animationView2.animation = animation
            animationView3.animation = animation
            animationView4.animation = animation
            animationView5.animation = animation
        case "2":
            evaluation = 2
            animationView.play()
            animationView2.play()
            animationView3.animation = animation
            animationView4.animation = animation
            animationView5.animation = animation
        case "3":
            evaluation = 3
            animationView.play()
            animationView2.play()
            animationView3.play()
            animationView4.animation = animation
            animationView5.animation = animation
        case "4":
            evaluation = 4
            animationView.play()
            animationView2.play()
            animationView3.play()
            animationView4.play()
            animationView5.animation = animation
        case "5":
            evaluation = 5
            animationView.play()
            animationView2.play()
            animationView3.play()
            animationView4.play()
            animationView5.play()
        default:
            print("error")
        }
       
    }
    
    @IBAction func getData(_ sender: Any) {
        let myListDB = Database.database().reference().child("MyList").child(String(userID)).child("Diary").child(dateString).childByAutoId()
        
        let mylistInfo = ["titleName":self.titleName as Any, "stressCount": stresscount  as Any,"selectedList":selectedList as Any,"result":result as Any, "evaluation":evaluation as Any,"timeString":timeString as Any] as [String:Any]
        myListDB.updateChildValues(mylistInfo)
        
        select?.usedEvaluation(eva: evaluation)
        
        dismiss(animated: true, completion: nil)
        
    
        
    }
}