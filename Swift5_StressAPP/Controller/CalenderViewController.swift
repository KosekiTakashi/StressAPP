//
//  CalenderViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/11/01.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import Firebase

class CalenderViewController: UIViewController {

    
    @IBOutlet weak var Calender: FSCalendar!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentDataTime: Date!
    var diary = [Diary]()
    var userID = ""
    let MyListref = Database.database().reference().child("MyList")
    var eventCount = 0
    var maneger = DiaryManeger()
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    let dateFormatter = DateFormatter()
    let date = Date()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Calender.delegate = self
        Calender.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        maneger.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        DateLabel.text = dateString
        
        
        if let userID = (Auth.auth().currentUser?.uid){
            self.userID = userID
            maneger.fetch(userID: userID, selectday: dateString)
        }
        
    }

}
//MARK: - DataFetch
extension CalenderViewController: DiaryDataFetchDelegate{
    func didFetch(List: [Diary]) {
        
        self.diary = List
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - tableView
extension CalenderViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diary.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = diary[indexPath.row].timeString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVC = storyboard?.instantiateViewController(identifier: "Diary") as! DiarDetailViewController
        let contents = diary[indexPath.row]
        nextVC.diary = contents
        
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
}

//MARK: - Calendar
extension CalenderViewController: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
     }
     
     func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
         return 0
     }
    
     
     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        diary.removeAll()
        maneger.fetch(userID: userID, selectday: dateString)
             
        tableView.reloadData()
        DateLabel.text = "\(dateString) の出来事"
     }
     //曜日判定
     func judgeWeek(_ date: Date) -> Int{
         
         let tmpCalendar = Calendar(identifier: .gregorian)
         return tmpCalendar.component(.weekday, from: date)
         
     }
     
     //休日判定
        func judgeHoliday(_ date: Date) -> Bool{
            let tmpCalendar = Calendar(identifier: .gregorian)
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)
            
            let holiday = CalculateCalendarLogic()
            
            return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        }
     
     //休日の色変え
     func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
         
         //祝日
         if self.judgeHoliday(date){
             return UIColor.red
         }
         
         //日曜　週始めだから
         let weekday = self.judgeWeek(date)
         if weekday == 1 {
             return UIColor.red
         //土曜
         }else if weekday == 7{
             return UIColor.blue
         }
         
         return nil
     }
 
     func getDay(_ date:Date) -> (Int,Int,Int){
         let tmpCalendar = Calendar(identifier: .gregorian)
         let year = tmpCalendar.component(.year, from: date)
         let month = tmpCalendar.component(.month, from: date)
         let day = tmpCalendar.component(.day, from: date)
         return (year,month,day)
     }
}
