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

class CalenderViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    
    @IBOutlet weak var Calender: FSCalendar!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var test = ["a", "b", "c","d"]
    
    var currentDataTime: Date!
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd  HH:mm"
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Calender.delegate = self
        Calender.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: Date())
        let month = tmpDate.component(.month, from: Date())
        let day = tmpDate.component(.day, from: Date())
        let selectday = "\(year)-\(month)-\(day)"
        DateLabel.text = selectday
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        print("day\(day)")
        let selectday = "\(year)-\(month)-\(day)"
        DateLabel.text = selectday
    }
    
   
    
    
    //曜日判定
    func judgeWeek(_ date: Date) -> Int{
        
        let tmpCalender = Calendar(identifier: .gregorian)
        return tmpCalender.component(.weekday, from: date)
        
    }
    
    //休日判定
       func judgeHoliday(_ date: Date) -> Bool{
           let tmpCalender = Calendar(identifier: .gregorian)
           let year = tmpCalender.component(.year, from: date)
           let month = tmpCalender.component(.month, from: date)
           let day = tmpCalender.component(.day, from: date)
           
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalenderViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = test[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    
}
