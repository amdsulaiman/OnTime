//
//  NotesVC.swift
//  OnTime
//
//  
//

import UIKit
struct NotesStruct : Codable {
    var title  : String
    var description : String
    var isPinned : String
    var date : String
}
class NotesVC: UIViewController, UITextViewDelegate {
    //MARK:- IBOutlets
    @IBOutlet weak var baseview: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var pinBtnRef: UIButton!
    @IBOutlet weak var saveBtnRef: UIButton!
    //MARK:- Userdefined
    var isPinned = "false"
    var isVisible = true
    var todayDate = ""
    var isFromAddNotes = ""
    var titleValue = ""
    var descriptionValue = ""
    var pinValue = ""
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        callfunc()
    }
    //MARK:- setup Notes
    func callfunc(){
        configUI()
        getCurrentDate()
    }
    //MARK:- config UI
    func configUI(){
        if isFromAddNotes == "0" {
            titleTextView.isUserInteractionEnabled = true
            descriptionTextView.isUserInteractionEnabled = true
            pinBtnRef.isEnabled = true
            saveBtnRef.isHidden = false
        }
        else if isFromAddNotes == "1" {
            titleTextView.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
            saveBtnRef.isHidden = true
            titleTextView.text = titleValue
            descriptionTextView.text = descriptionValue
            titleTextView.textColor = UIColor.white
            descriptionTextView.textColor = UIColor.white
            if pinValue == "true"{
                pinBtnRef.setImage(UIImage(named: "pin"), for: .normal)
            }
            else if pinValue == "false"{
                pinBtnRef.setImage(UIImage(named: "unpin"), for: .normal)
            }
        }
        titleTextView.textColor = UIColor.white
        titleTextView.returnKeyType = .done
        titleTextView.delegate = self
        descriptionTextView.textColor = UIColor.white
        descriptionTextView.returnKeyType = .done
        descriptionTextView.delegate = self
        descriptionTextView.isScrollEnabled = false
        titleTextView.isScrollEnabled = false
        saveBtnRef.layer.cornerRadius = 12
    }
    @IBAction func onClickDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        notesValidation()
    }
    @IBAction func onclickPinNotes(_ sender: UIButton) {
        if isFromAddNotes == "0"{
            if(isVisible == true) {
                pinBtnRef.setImage(#imageLiteral(resourceName: "unpin"), for: .normal)
                isPinned = "false"
            } else {
                pinBtnRef.setImage(#imageLiteral(resourceName: "pin"), for: .normal)
                isPinned = "true"
            }
            isVisible = !isVisible
        }
        else if isFromAddNotes == "1"{
            
        }
    }
    //MARK:- UITextViewDelegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            if textView.text == "Title" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
        else if textView == descriptionTextView {
            if textView.text == "Add Description" {
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
        else if textView == descriptionTextView {
            if textView.text == "Add Description" {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- get Today Date
    func getCurrentDate(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let dateString = "Today, \(df.string(from: date))"
        todayDate = df.string(from: date)
    }
    //MARK:- Firebase Func to Upload Notes to Database
    func uploadNotestoFirebase(with title:String,description:String,isPinned:String,date:String){
        FirebaseService.shared.uploadNotes(with: title, description: description, isPinned: isPinned, date: date, completion: { (err, ref) in
            if let error = err {
                print("failed to Uplaod Trip : \(error.localizedDescription)")
                return
            }
        })
        print("Successfully uploaded")
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Input Field Validation and Upload data to Database
    func notesValidation(){
        if titleTextView.text == "" &&  descriptionTextView.text == "" {
            GlobalObj.showAlert(title: "Alert", message: "Please Enter All fields", controller: self)
        }
        else if descriptionTextView.text == "" {
            GlobalObj.showAlert(title: "Alert", message: "Please Enter description", controller: self)
        }
        else if  titleTextView.text == "" {
            GlobalObj.showAlert(title: "Alert", message: "Please Enter title", controller: self)
        }
        else if  titleTextView.text == "Title" {
            GlobalObj.showAlert(title: "Alert", message: "Please Enter title", controller: self)
        }
        else if descriptionTextView.text == "Add Description" {
            GlobalObj.showAlert(title: "Alert", message: "Please Enter description", controller: self)
        }
        else {
            uploadNotestoFirebase(with: titleTextView.text.unsafelyUnwrapped, description: descriptionTextView.text.unsafelyUnwrapped, isPinned: isPinned, date: todayDate)
        }
    }
}
