//
//  HomeVC.swift
//  OnTime
//
//  
//

import UIKit
import Foundation
import Firebase
import Floaty
import FSCalendar
import EventKit
import KRProgressHUD
import ProgressHUD

class HomeVC: UIViewController,  FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var notificationsBtnRef: UIButton!
    @IBOutlet weak var settingsBtnRef: UIButton!
    @IBOutlet weak var segmentBtnRef: UISegmentedControl!
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var noScheduleView: UIView!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var noScheduleLbl: UILabel!
    @IBOutlet weak var scheduleDataView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var scheduleLbl: UILabel!
    @IBOutlet weak var noNotesView: UIView!
    @IBOutlet weak var noNoteslbl: UILabel!
    var scheduleArray = [String:Any]()
    let backgroundImage = UIImage(named: "gradientbg")
    var dateFormatter = DateFormatter()
    var datesWithEvent = [String]()
    var datesWithMultipleEvents = [String]()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    var user : User?
    var selectedIndex = 0
    var firebaseNotesArray = [NotesStruct]()
    var firebaseScheduleArray = [ScheduleStruct]()
    var todayDate = ""
    var selectedDate = ""
    let store = EKEventStore()
    var scheduleEventArray = [String]()
    var userDefaultsScheduleData = [ScheduleStruct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        print("HomeVC")
        callFunctions()
       print(convertDateFormat(inputDate: self.userDefaultsScheduleData[0].startTime))
    }
    func callFunctions(){
        getCurrentDate()
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        configUI()
        getUserData()
        configFloatbutton()
        setupNotesTableview()
        ProgressHUD.show()
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorAnimation = #colorLiteral(red: 0.5699532032, green: 0.4998087287, blue: 1, alpha: 1)
        retriveSchedule(with: selectedDate)
        retrieveEventDates()
        self.setupTableview()
        self.TakeLocalNotificationPermisiion()
        setupNotification()
        do {
            let storedObjItem = UserDefaults.standard.object(forKey: "userDefaultsScheduleData")
            if storedObjItem == nil {
                print("No Data in userDefaults")
            }
            else {
                let storedItems = try JSONDecoder().decode(ScheduleStruct.self, from: storedObjItem as! Data)
                self.userDefaultsScheduleData.append(storedItems)
                print("Retrieved items: \(storedItems)")
                
            }
        } catch let err {
            print(err)
        }
    }
    func TakeLocalNotificationPermisiion(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound]) { (granted, error) in
            if granted {
                print("User gave permissions for local Notifications")
            }else{
                
            }
        }
    }
    func configUI(){
        let font = UIFont(name: "Montserrat-Medium", size: 18.0)
        segmentBtnRef.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentBtnRef.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentBtnRef.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        noScheduleLbl.layer.cornerRadius = 12
        scheduleDataView.layer.cornerRadius = 12
        noScheduleLbl.layer.masksToBounds = true
        noNoteslbl.layer.cornerRadius = 12
        noNoteslbl.layer.masksToBounds = true
        noScheduleView.isHidden = true
        if selectedIndex == 0 {
            fsCalendar.isHidden = false
            scheduleView.isHidden = false
            scheduleLbl.isHidden = false
            notesView.isHidden = true
            searchBar.isHidden = true
            notesTableView.isHidden = true
        }
        else if selectedIndex == 1 {
            fsCalendar.isHidden = true
            scheduleView.isHidden = true
            scheduleLbl.isHidden = true
            notesView.isHidden = false
            searchBar.isHidden = false
            notesTableView.isHidden = false
        }
        self.searchBar.layer.borderWidth = 2.0;
        self.searchBar.layer.cornerRadius = 15.0
        self.searchBar.barTintColor = #colorLiteral(red: 0.8385053873, green: 0.8123152852, blue: 0.9973960519, alpha: 1)
        self.searchBar.backgroundColor = #colorLiteral(red: 0.8385053873, green: 0.8123152852, blue: 0.9973960519, alpha: 1)
    }
    func setupTableview(){
        scheduleTableView.register(ScheduleTableViewCell.nib(), forCellReuseIdentifier: "ScheduleTableViewCell")
        scheduleTableView.backgroundColor = .clear
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.tableFooterView = UIView()
    }
    func setupNotesTableview(){
        notesTableView.register(NotesTableViewCell.nib(), forCellReuseIdentifier: "NotesTableViewCell")
        notesTableView.backgroundColor = .white
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.tableFooterView = UIView()
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.notesTableView.backgroundView = imageView
        notesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: notesTableView.frame.size.width, height: scheduleDataView.frame.size.height))
        notesTableView.tableFooterView = UIView()
    }
    func configFloatbutton(){
        let floaty = Floaty()
        floaty.buttonColor = #colorLiteral(red: 0.4941176471, green: 0.3921568627, blue: 1, alpha: 1)
        floaty.itemButtonColor = #colorLiteral(red: 0.4941176471, green: 0.3921568627, blue: 1, alpha: 1)
        floaty.plusColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floaty.itemSize = 48
        floaty.itemSpace = 24
        floaty.addItem("Notes", icon: UIImage(named: "notes")!, handler: { item in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
            vc.modalPresentationStyle = .fullScreen
            vc.isFromAddNotes = "0"
            self.present(vc, animated:true)
            floaty.close()
        })
        floaty.addItem("Schedule", icon: UIImage(named: "calendar")!, handler: { item in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
            vc.modalPresentationStyle = .fullScreen
            vc.isFromNewSchedule = "1"
            self.present(vc, animated:true)
            floaty.close()
        })
        self.view.addSubview(floaty)
    }
    func getUserData(){
        guard let currentUId = Auth.auth().currentUser?.uid else { return}
        FirebaseService.shared.fetchUserData(uid: currentUId) { (user) in
            self.user = user
            print(user)
        }
    }
    @IBAction func onClickNotifications(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:true)
    }
    
    @IBAction func onClickSettings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:true)
    }
    
    @IBAction func segmentBtnAction(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 0 {
            fsCalendar.isHidden = false
            scheduleView.isHidden = false
            scheduleLbl.isHidden = false
            notesView.isHidden = true
            searchBar.isHidden = true
            notesTableView.isHidden = true
            noNotesView.isHidden = true
        }
        else if sender.selectedSegmentIndex == 1 {
            ProgressHUD.show()
            ProgressHUD.animationType = .circleRotateChase
            ProgressHUD.colorHUD = .systemGray
            ProgressHUD.colorAnimation = #colorLiteral(red: 0.5699532032, green: 0.4998087287, blue: 1, alpha: 1)
            self.firebaseNotesArray.removeAll()
            retriveNotes()
            fsCalendar.isHidden = true
            scheduleView.isHidden = true
            scheduleLbl.isHidden = true
        }
    }
    func retriveNotes(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_NOTES.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("exists")
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    let postKey = snap.key
                    let title = dict["title"] as! String
                    let description = dict["description"] as! String
                    let isPinned = dict["isPinned"] as! String
                    let date = dict["Date"] as! String
                    let notes = NotesStruct(title: title, description: description, isPinned: isPinned, date: date)
                    self.firebaseNotesArray.append(notes)
                    print("The data is \(self.firebaseNotesArray)")
                    if self.firebaseNotesArray.isEmpty {
                        ProgressHUD.dismiss()
                        self.notesView.isHidden = false
                        self.notesTableView.isHidden = true
                        self.searchBar.isHidden = true
                        self.noNotesView.isHidden = false
                        print("No Notes Dta")
                        
                    }
                    else {
                        ProgressHUD.dismiss()
                        self.noNotesView.isHidden = true
                        self.notesTableView.isHidden = false
                        self.notesView.isHidden = false
                        self.searchBar.isHidden = false
                        self.notesTableView.isHidden = false
                        self.notesTableView.reloadData()
                    }
                }
                
            }
            else {
                ProgressHUD.dismiss()
                self.notesView.isHidden = false
                self.notesTableView.isHidden = true
                self.searchBar.isHidden = true
                self.noNotesView.isHidden = false
            }
        }
    }
    func retriveSchedule(with selectedDate : String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_SCHEDULE.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                for user_child in (snapshot.children) {
                    let user_snap = user_child as! DataSnapshot
                    for schedule in user_snap.children {
                        let scheduleSnap = schedule as! DataSnapshot
                        let dict = scheduleSnap.value as! [String: String]
                        if scheduleSnap.key == selectedDate {
                            let schedule = ScheduleStruct(serverDate: dict["serverDate"] as! String, title: dict["title"] as! String, fullday: dict["fullday"] as! String, startTime: dict["startTime"] as! String, endTime: dict["endTime"] as! String, repeatTime: dict["repeat"] as! String, remainder: dict["remainder"] as! String, notes: dict["notes"] as! String, priority: dict["priority"] as! String, place: dict["place"] as! String)
                            self.firebaseScheduleArray.append(schedule)
                            let data : ScheduleStruct = ScheduleStruct.init(serverDate: dict["serverDate"] as! String, title: dict["title"] as! String, fullday: dict["fullday"] as! String, startTime: dict["startTime"] as! String, endTime: dict["endTime"] as! String, repeatTime: dict["repeat"] as! String, remainder: dict["remainder"] as! String, notes: dict["notes"] as! String, priority: dict["priority"] as! String, place: dict["place"] as! String)
                            self.userDefaultsScheduleData.append(data)
                            if let encoded = try? JSONEncoder().encode(data) {
                                UserDefaults.standard.set(encoded, forKey: "userDefaultsScheduleData")
                            }
                            if self.firebaseScheduleArray.isEmpty {
                                ProgressHUD.dismiss()
                                self.noScheduleView.isHidden = false
                                self.scheduleDataView.isHidden = true
                            }
                            else {
                                ProgressHUD.dismiss()
                                self.noScheduleView.isHidden = true
                                self.scheduleDataView.isHidden = false
                                self.scheduleTableView.reloadData()
                            }
                        }
                        else {
                            print(" NO DATA ")
                            ProgressHUD.dismiss()
                            if self.firebaseScheduleArray.isEmpty {
                                self.noScheduleView.isHidden = false
                                self.scheduleDataView.isHidden = true
                            }
                            else {
                                ProgressHUD.dismiss()
                                self.noScheduleView.isHidden = true
                                self.scheduleDataView.isHidden = false
                                self.scheduleTableView.reloadData()
                            }
                        }
                    }
                }
            }
            else {
                ProgressHUD.dismiss()
                self.noScheduleView.isHidden = false
                self.scheduleDataView.isHidden = true
            }
        }
    }
    func retrieveEventDates(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_SCHEDULE.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            for data in snapshot.children {
                let datas = data as! DataSnapshot
                for dates in datas.children {
                    let allDates = dates as! DataSnapshot
                    self.scheduleEventArray.append(allDates.key)
                    print(self.scheduleEventArray)
                    self.fsCalendar.reloadData()
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    //MARK:- get Today Date
    func getCurrentDate(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let dateString = "Today, \(df.string(from: date))"
        todayDate = df.string(from: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.scheduleEventArray.contains(dateString) {
            return 2
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter2.string(from: date)
        if self.scheduleEventArray.contains(key) {
            return [UIColor.white,#colorLiteral(red: 0.6203927398, green: 0.5687631369, blue: 1, alpha: 1)]
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        self.selectedDate = result
        self.firebaseScheduleArray.removeAll()
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorAnimation = #colorLiteral(red: 0.5699532032, green: 0.4998087287, blue: 1, alpha: 1)
        ProgressHUD.show()
        self.retriveSchedule(with: selectedDate)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == scheduleTableView){
            return firebaseScheduleArray.count
        }
        else if (tableView == notesTableView){
            return firebaseNotesArray.count
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == scheduleTableView){
            let cell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.titleLbl.text = self.firebaseScheduleArray[indexPath.row].title
            cell.timeLbl.text  = self.firebaseScheduleArray[indexPath.row].startTime
            cell.placeLbl.text = self.firebaseScheduleArray[indexPath.row].place
            cell.notesLbl.text = self.firebaseScheduleArray[indexPath.row].notes
            return cell
        }
        else if (tableView == notesTableView){
            let cell = notesTableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
            cell.titleLbl.text = firebaseNotesArray[indexPath.row].title
            cell.subTitleLbl.text = firebaseNotesArray[indexPath.row].description
            cell.dateLbl.text = firebaseNotesArray[indexPath.row].date
            if firebaseNotesArray[indexPath.row].isPinned == "true" {
                cell.pinIcon.image = UIImage(named: "pin")
            }
            else {
                cell.pinIcon.image = UIImage(named: "unpin")
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  (tableView == scheduleTableView){
            return 156
        }
        else if (tableView == notesTableView){
            return UITableView.automaticDimension
        }
        return 100
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == scheduleTableView){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleVC
            vc.modalPresentationStyle = .fullScreen
            vc.isFromNewSchedule = "0"
            vc.titleValue = firebaseScheduleArray[indexPath.row].title
            vc.fulldayValue = firebaseScheduleArray[indexPath.row].fullday
            vc.startValue = firebaseScheduleArray[indexPath.row].startTime
            vc.finishValue = firebaseScheduleArray[indexPath.row].endTime
            vc.repeatValue = firebaseScheduleArray[indexPath.row].repeatTime
            vc.remainderValue = firebaseScheduleArray[indexPath.row].remainder
            vc.notesValue = firebaseScheduleArray[indexPath.row].notes
            vc.placeValue = firebaseScheduleArray[indexPath.row].place
            vc.priorityValue = firebaseScheduleArray[indexPath.row].priority
            self.present(vc, animated:true)
        }
        else if (tableView == notesTableView){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
            vc.isFromAddNotes = "1"
            vc.titleValue = firebaseNotesArray[indexPath.row].title
            vc.descriptionValue = firebaseNotesArray[indexPath.row].description
            vc.pinValue = firebaseNotesArray[indexPath.row].isPinned
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated:true)
        }
    }
    func setupNotification(){
        let content = UNMutableNotificationContent()
        content.title = "onTime"
        content.subtitle = "Be onTime "
        content.sound = UNNotificationSound.default
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        // Friday
        dateComponents.weekday = 4
        dateComponents.hour = 18
        dateComponents.minute =  53
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        print("We can.......")
        UNUserNotificationCenter.current().add(request)
    }
    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "E , d MMM yyy h:mm a"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "dd-MM-yyyy"
         return convertDateFormatter.string(from: oldDate!)
    }
}
extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
