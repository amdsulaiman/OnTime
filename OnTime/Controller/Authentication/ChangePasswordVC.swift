//
//  ChangePasswordVC.swift
//  OnTime
//
//  
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var changePassBtnRef: UIButton!
    var isVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    func setupUI(){
        emailView.layer.cornerRadius = 12
        changePassBtnRef.layer.cornerRadius = 12
        emailView.layer.borderWidth = 0.7
        emailView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
    }
    func setupvalidation(){
         if emailTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Email", controller: self)
        }
        else if !(GlobalObj.isValidEmail(testStr: emailTxt.text.unsafelyUnwrapped)){
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Valid Email", controller: self)
        }
        else {
            //Call Firebase change Pass Function
            print("Success")
            handleChangePassword(with: emailTxt.text.unsafelyUnwrapped)
        }
    }
    func handleChangePassword(with email:String){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
          if let error = error  {
            print(error)
          } else {
            print("Reset password email has been successfully sent")
            GlobalObj.displayAlertWithHandler(with: "Success", message: "A Password reset email has been sent", buttons: ["OK"], viewobj: self, buttonStyles: [.cancel]) { String in
                self.dismiss(animated: true, completion: nil)
            }
          }
        }
    }
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickChangePass(_ sender: Any) {
        setupvalidation()
    }
    
}
