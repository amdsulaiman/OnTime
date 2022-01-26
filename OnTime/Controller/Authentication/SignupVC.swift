//
//  SignupVC.swift
//  OnTime
//
//  
//

import UIKit
import Firebase

class SignupVC: UIViewController {
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordtTxt: UITextField!
    @IBOutlet weak var passwordRefBtn: UIButton!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var confirmPasswordBtnRef: UIButton!
    @IBOutlet weak var signUpBtnRef: UIButton!
    var isVisible = true
    var isVisible1 = true
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    func setupUI(){
        confirmPasswordView.layer.cornerRadius = 12
        fullNameView.layer.cornerRadius = 12
        emailView.layer.cornerRadius = 12
        passwordView.layer.cornerRadius = 12
        signUpBtnRef.layer.cornerRadius = 12
        emailView.layer.borderWidth = 0.7
        emailView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
        passwordView.layer.borderWidth = 0.7
        passwordView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
        confirmPasswordView.layer.borderWidth = 1
        fullNameView.layer.borderWidth = 0.7
        fullNameView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
        confirmPasswordView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
    }
    //MARK: - Check Logged In
    func isLoggedIn(){
        if UserDefaults.standard.bool(forKey: "ISLOGGEDIN") == true {
            GlobalObj.setRootToHome()
        }
        else {
            GlobalObj.setRootToLogin()
        }
    }
    func setupvalidation(){
        if emailTxt.text == "" && passwordtTxt.text == "" && fullNameTxt.text == "" && confirmPasswordTxt.text == ""  {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter All Feilds", controller: self)
        }
        else if emailTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Email", controller: self)
        }
        else if passwordtTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Password", controller: self)
        }
        else if fullNameTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Full Name", controller: self)
        }
        else if confirmPasswordTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Confirm Password", controller: self)
        }
        else if !(GlobalObj.isValidEmail(testStr: emailTxt.text.unsafelyUnwrapped)){
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Valid Email", controller: self)
        }
        else if !(confirmPassword(password: passwordtTxt.text.unsafelyUnwrapped, confirmPassword: confirmPasswordTxt.text.unsafelyUnwrapped)) {
            GlobalObj.showAlertVC(title: "Oops", message: "Password Mistmatch", controller: self)
        }
        else {
            //Call Firebase Register Func
            print("Success")
            handleSignup(username: fullNameTxt.text.unsafelyUnwrapped, email: emailTxt.text.unsafelyUnwrapped, password: passwordtTxt.text.unsafelyUnwrapped)
        }
    }
    func handleSignup(username:String,email:String,password:String){
        Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
            if let error = error {
                print("DEBUG: Failed t oregister user with error \(error)")
                return
            }
            guard let uid = result?.user.uid else { return }
            let values = ["email": email, "fullName": username] as [String: Any]
            uploadUserDataAndShowHomeController(values: values, uid: uid)
    }
    }
    // MARK: - Helper Functions
    func uploadUserDataAndShowHomeController(values: [String: Any], uid: String) {
        REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
            if error == nil {
                print("Data saved successfully \(ref)")
                UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
                GlobalObj.setRootToHome()
                self.isLoggedIn()

            }
            else {
                print(error?.localizedDescription)
            }
        }
    }

    @IBAction func onClickPassword(_ sender: UIButton) {
        if(isVisible == true) {
            passwordtTxt.isSecureTextEntry = false
            passwordRefBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        } else {
            passwordtTxt.isSecureTextEntry = true
            passwordRefBtn.setImage(#imageLiteral(resourceName: "eyeInvisible"), for: .normal)
        }
        isVisible = !isVisible
    }
    
    @IBAction func onClickConfirmPassword(_ sender: UIButton) {
        if(isVisible1 == true) {
            confirmPasswordTxt.isSecureTextEntry = false
            confirmPasswordBtnRef.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        } else {
            confirmPasswordTxt.isSecureTextEntry = true
            confirmPasswordBtnRef.setImage(#imageLiteral(resourceName: "eyeInvisible"), for: .normal)
        }
        
        isVisible1 = !isVisible1
    }
    @IBAction func onClickSignup(_ sender: Any) {
        setupvalidation()
    }
    @IBAction func onClickLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func confirmPassword(password:String,confirmPassword:String) -> Bool{
        if password == confirmPassword {
            return true
        }else {
            return false
        }
    }
    
}
