//
//  LoginVC.swift
//  OnTime
//
//  
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var showPassBtnRef: UIButton!
    @IBOutlet weak var signinbtnRef: UIButton!
    var isVisible = true
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginVC")
        setupUI()
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
    func setupUI(){
        isLoggedIn()
        emailView.layer.cornerRadius = 12
        passwordView.layer.cornerRadius = 12
        signinbtnRef.layer.cornerRadius = 12
        emailView.layer.borderWidth = 0.7
        emailView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
        passwordView.layer.borderWidth = 0.7
        passwordView.layer.borderColor = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
    }
    func setupLoginvalidation(){
        if emailTxt.text == "" && passwordTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter All Feilds", controller: self)
        }
        else if emailTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Email", controller: self)
        }
        else if passwordTxt.text == "" {
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Password", controller: self)
        }
        else if !(GlobalObj.isValidEmail(testStr: emailTxt.text.unsafelyUnwrapped)){
            GlobalObj.showAlertVC(title: "Oops", message: "Please Enter Valid Email", controller: self)
        }
        else {
            //Call Firebase Login Function
            print("Success")
            handleLogin(email: emailTxt.text.unsafelyUnwrapped, password: passwordTxt.text.unsafelyUnwrapped)
            
        }
    }
    func handleLogin(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed To Login User with error \(error.localizedDescription)")
                return
            }
            print("Successfully logged in user")
            UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
            GlobalObj.setRootToHome()
            self.isLoggedIn()
        }
    }
    @IBAction func onClickShowPassword(_ sender: UIButton) {
        if(isVisible == true) {
            passwordTxt.isSecureTextEntry = false
            showPassBtnRef.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            
        } else {
            passwordTxt.isSecureTextEntry = true
            showPassBtnRef.setImage(#imageLiteral(resourceName: "eyeInvisible"), for: .normal)
        }
        isVisible = !isVisible
    }
    
    @IBAction func onClickForgetPassword(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    @IBAction func onClickLogin(_ sender: UIButton) {
        setupLoginvalidation()
    }
    @IBAction func onClickSignUp(_ sender: UIButton) {
        //SignupVC
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
}
