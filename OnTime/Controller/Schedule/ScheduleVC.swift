//
//  ScheduleVC.swift
//  OnTime
//
//  

import UIKit
struct ScheduleStruct : Codable {
    var serverDate : String
    var title : String
    var fullday : String
    var startTime : String
    var endTime : String
    var repeatTime : String
    var remainder : String
    var notes : String
    var priority : String
    var place : String
}

class ScheduleVC: UIViewController, UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var startFromView: UIView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var remainderView: UIView!
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var placeTextView: UITextView!
    @IBOutlet weak var selectDateTxt: UITextField!
    @IBOutlet weak var finishTimeTxt: UITextField!
    @IBOutlet weak var remainderTxt: UITextField!
    @IBOutlet weak var repeatTxt: UITextField!
    @IBOutlet weak var saveBtnref: UIButton!
    @IBOutlet weak var fullDaySwitchRef: UISwitch!
    @IBOutlet weak var priorityTxt: UITextField!
    var todayDate = ""
    let datePicker = UIDatePicker()
    let finishDatePicker = UIDatePicker()
    let remainderPickerView = UIPickerView()
    let repeatPickerView = UIPickerView()
    let priorityPickerView = UIPickerView()
    let beforeArray = ["Before 5 minutes","Before 10 minutes","Before 15 minutes","Before 30 minutes","Before 1 hour"]
    let repeatArray = ["None","True"]
    let priorityArray = ["Low","Medium","High"]
    var selectedRemainder : String?
    var selectedRepeated : String?
    var selectedPriority : String?
    var todayDateID = ""
    var fullDay = "false"
    var isFromNewSchedule = ""
    var titleValue = ""
    var fulldayValue = ""
    var startValue = ""
    var finishValue = ""
    var remainderValue = ""
    var repeatValue = ""
    var priorityValue = ""
    var notesValue = ""
    var placeValue = ""
    var scheduleDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScheduleView()
    }
    func  setupScheduleView(){
        self.dismissKeyboard()
        getCurrentDate()
        configUI()
    }
    func configUI(){
        titleTextView.textColor = UIColor.white
        titleTextView.delegate = self
        notesTextView.textColor = UIColor.white
        notesTextView.delegate = self
        notesTextView.isScrollEnabled = false
        titleTextView.isScrollEnabled = false
        placeTextView.isScrollEnabled = false
        placeTextView.textColor = UIColor.white
        placeTextView.delegate = self
        placeTextView.layer.cornerRadius = 8
        titleTextView.layer.cornerRadius = 8
        notesTextView.layer.cornerRadius = 8
        saveBtnref.layer.cornerRadius = 12
        remainderPickerView.delegate = self
        remainderTxt.inputView = remainderPickerView
        repeatPickerView.delegate = self
        repeatTxt.inputView = repeatPickerView
        remainderPickerView.tag = 1
        repeatPickerView.tag = 2
        priorityPickerView.delegate = self
        priorityTxt.inputView = priorityPickerView
        priorityPickerView.tag = 3
        if isFromNewSchedule == "0" {
            titleTextView.isUserInteractionEnabled = false
            fullDaySwitchRef.isUserInteractionEnabled = false
            selectDateTxt.isUserInteractionEnabled = false
            finishTimeTxt.isUserInteractionEnabled = false
            repeatView.isUserInteractionEnabled = false
            remainderTxt.isUserInteractionEnabled = false
            notesTextView.isUserInteractionEnabled = false
            priorityTxt.isUserInteractionEnabled = false
            placeTextView.isUserInteractionEnabled = false
            saveBtnref.isHidden = true
            titleTextView.text = titleValue
            if fulldayValue == "true" {
                fullDaySwitchRef.isOn = true
            }
            else {
                fullDaySwitchRef.isOn = false
            }
            selectDateTxt.text = startValue
            finishTimeTxt.text = finishValue
            remainderTxt.text = remainderValue
            repeatTxt.text =  repeatValue
            priorityTxt.text = priorityValue
            notesTextView.text = notesValue
            placeTextView.text = placeValue
        }
        else if isFromNewSchedule == "1" {
            setupScheduleViewData()
            createDatePicker()
            createFinishDatePicker()
            getCurrentDateID()
            titleTextView.isUserInteractionEnabled = true
            fullDaySwitchRef.isUserInteractionEnabled = true
            selectDateTxt.isUserInteractionEnabled = true
            finishTimeTxt.isUserInteractionEnabled = true
            repeatView.isUserInteractionEnabled = true
            remainderTxt.isUserInteractionEnabled = true
            notesTextView.isUserInteractionEnabled = true
            priorityTxt.isUserInteractionEnabled = true
            placeTextView.isUserInteractionEnabled = true
            saveBtnref.isHidden = false
        }
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       remainderTxt.inputAccessoryView = toolBar
       repeatTxt.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    func getCurrentDate(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "E , d MMM yyy h:mm a"
        let dateString = "Today, \(df.string(from: date))"
        todayDate = df.string(from: date)
    }
    func setupScheduleViewData(){
        selectDateTxt.text = "\(todayDate)"
        finishTimeTxt.text = "\(todayDate)"
        remainderTxt.text = "Before 5 minutes"
        repeatTxt.text = "none"
        priorityTxt.text = "Low"
    }
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donebuttonPressed))
        toolbar.setItems([doneButton], animated: true)
        selectDateTxt.inputAccessoryView = toolbar
        selectDateTxt.inputView = datePicker
        selectDateTxt.inputAccessoryView = toolbar
        selectDateTxt.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(donebuttonPressed), for:.allTouchEvents)
    }
    @objc func donebuttonPressed(){
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd-MM-yyyy"
        scheduleDate = formatter2.string(from:  datePicker.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "E , d MMM yyy h:mm a"
        selectDateTxt.text = formatter.string(from:  datePicker.date)
        self.view.endEditing(true)
        self.selectDateTxt.resignFirstResponder()
    }
    func createFinishDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donebuttonPressed2))
        toolbar.setItems([doneButton], animated: true)
        finishTimeTxt.inputAccessoryView = toolbar
        finishTimeTxt.inputView = finishDatePicker
        finishTimeTxt.inputAccessoryView = toolbar
        finishTimeTxt.inputView = finishDatePicker
        finishDatePicker.datePickerMode = .dateAndTime
        finishDatePicker.preferredDatePickerStyle = .compact
        finishDatePicker.addTarget(self, action: #selector(donebuttonPressed2), for:.allTouchEvents)
    }
    @objc func donebuttonPressed2(){
        let formatter = DateFormatter()
        formatter.dateFormat = "E , d MMM yyy h:mm a"
        finishTimeTxt.text = formatter.string(from:  finishDatePicker.date)
        self.view.endEditing(true)
        self.finishTimeTxt.resignFirstResponder()
    }
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fullDaySwitchAction(_ sender: UISwitch) {
        if fullDaySwitchRef.isOn == true {
            fullDay = "true"
        }
        else {
            fullDay = "false"
        }
    }
    @IBAction func onClickSave(_ sender: UIButton) {
        setupValidation()
    }
    
    //MARK:- UITextViewDelegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "Title" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
        else if textView == notesTextView {
            if textView.text == "Add Notes" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
        else if textView == placeTextView {
            if textView.text == "Add Place" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "Title" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
        else if textView == notesTextView {
            if textView.text == "Add Notes" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
        else if textView == placeTextView {
            if textView.text == "Add Place" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return beforeArray.count
        }
       else if pickerView.tag == 2 {
        return repeatArray.count
        }
       else if pickerView.tag == 3 {
        return priorityArray.count
       }
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return beforeArray[row]
        }
       else if pickerView.tag == 2 {
        return repeatArray[row]
        }
       else if pickerView.tag == 3 {
        return priorityArray[row]
       }
        return beforeArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedRemainder = beforeArray[row] // selected item
            remainderTxt.text = selectedRemainder
        }
       else if pickerView.tag == 2 {
        selectedRepeated = repeatArray[row] // selected item
        repeatTxt.text = selectedRepeated
        }
       else if pickerView.tag == 3 {
        selectedPriority = priorityArray[row] // selected item
        priorityTxt.text = selectedPriority
        }
   
    }
    func uploadScheduleToDatabase(with dateasID : String, title:String,fullday:String,startTime:String,endTime:String,isrepeat:String,remainder:String,notes:String,priority:String,place:String){
        
        FirebaseService.shared.uploadSchedule(with: dateasID, title: title, fullday: fullday, startTime: startTime, endTime: endTime, isrepeat: isrepeat, remainder: remainder, notes: notes, priority: priority, place: place, completion: { (err, ref) in
            if let error = err {
                print("failed to Uplaod Trip : \(error.localizedDescription)")
                return
            }
            print("Schedule Uploaded Succesfully")
            self.dismiss(animated: true, completion: nil)
    })
}
    //MARK:- get Today Date
    func getCurrentDateID(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let dateString = "Today, \(df.string(from: date))"
        todayDateID = df.string(from: date)
    }
    func setupValidation(){
        if titleTextView.text == "" && notesTextView.text == "" && placeTextView.text == "" {
            GlobalObj.showAlertVC(title: "Alert", message: "Please Enter all fields", controller: self
            )
        }
        else if titleTextView.text == "" {
            GlobalObj.showAlertVC(title: "Alert", message: "Please Enter title", controller: self
            )
        }
        else if notesTextView.text == "" {
            GlobalObj.showAlertVC(title: "Alert", message: "Please Enter notes", controller: self)
        }
        else if placeTextView.text == "" {
            GlobalObj.showAlertVC(title: "Alert", message: "Please Enter place", controller: self
            )
        }
        else {
            uploadScheduleToDatabase(with: scheduleDate, title: titleTextView.text.unsafelyUnwrapped, fullday: fullDay, startTime: selectDateTxt.text.unsafelyUnwrapped, endTime: finishTimeTxt.text.unsafelyUnwrapped, isrepeat: repeatTxt.text.unsafelyUnwrapped, remainder: remainderTxt.text.unsafelyUnwrapped, notes: notesTextView.text.unsafelyUnwrapped, priority: priorityTxt.text.unsafelyUnwrapped, place: placeTextView.text.unsafelyUnwrapped)
        }
    }
}
