//
//  CalendarAddViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/05.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import Firebase

class CalendarAddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var eventNameTextView: UITextView!
    @IBOutlet weak var stressLabel: UILabel!
    @IBOutlet weak var myListPicker: UIPickerView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var myListNameLabel: UILabel!
    
    var titleName = String()
    var MyList = [FireMyList]()
    let MyListref = Database.database().reference().child("MyList")
    var indexNumber = 0
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var myLists:FireMyList!{
        didSet{
            titleName = myLists.titleNameString
        }
    }
    
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
    
    }
    
    @objc func datechange(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        dateTextField.text = "\(formatter.string(from: sender.date))"
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dateTextField.resignFirstResponder()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = (Auth.auth().currentUser?.uid)!
        MyListref.child(userID).observe(.value) { (snapshot) in
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
        
        let count = Int(sender.value)
        stressLabel.text = String(count)
        
        switch count {
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
    
    
    @IBAction func evaluationSlider(_ sender: UISlider) {
        
        let count = Int(sender.value)
        
        sender.tintColor = .yellow
        evaluationLabel.text = String(count)
        
        switch count {
        case 0...1:
            sender.alpha = 0.3
        case 2...3:
            sender.alpha = 0.7
        case 4...5:
            sender.alpha = 1
        default:
            print("error")
        }
    }
    
    
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
        
        let text = MyList[row].titleNameString
        //let text = testArray[row]
        myListNameLabel.text = text
        
    }
    
    @IBAction func getData(_ sender: Any) {
       
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
