//
//  Global.swift
//  OnTime
//
//  
//

import Foundation
import Foundation
import UIKit
let GlobalObj = Global()
class Global {
    let gradient1 = UIColor.init(red: 42.0/255.0, green: 42.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    let gradient2 = UIColor.init(red: 31.0/255.0, green: 19.0/255.0, blue: 56.0/255.0, alpha: 1.0)
    let gradient3 = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    //MARK: - Show alert method
       func showAlertVC(title:String,message:String,controller:UIViewController) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let subView = alertController.view.subviews.first!
           let alertContentView = subView.subviews.first!
           alertContentView.backgroundColor = UIColor.gray
           alertContentView.layer.cornerRadius = 20
           let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(OKAction)
           controller.present(alertController, animated: true, completion: nil)
        
       }
    func showAlert(title:String,message:String,controller:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Dismiss = UIAlertAction(title: "Retry", style: .cancel, handler: nil)
        alert.addAction(Dismiss)
        controller.present(alert, animated: true, completion: nil)
    }
    //MARK:- Alert with completion handler and alert style
    func displayAlertWithHandler(with title: String?, message: String?, buttons: [String], viewobj:UIViewController,buttonStyles: [UIAlertAction.Style] = [], handler: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for i in 0 ..< buttons.count {
                let style: UIAlertAction.Style = buttonStyles.indices.contains(i) ? buttonStyles[i] : .default
                let buttonTitle = buttons[i]
                let action = UIAlertAction(title: buttonTitle, style: style) { (_) in
                    handler(buttonTitle)
                }
                alertController.addAction(action)
            }
            viewobj.present(alertController, animated: true)
        }
    }
    //MARK: - String To Date
    func strToDate(strDate:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let date = formatter.date(from: strDate)
        if date != nil{
            return date ?? Date()
        }else{
            return Date()
        }
    }
    //MARK: - serverFormateWithCP
    class func serverFormateWithCP()->DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")!
        return dateFormatter
    }
    //MARK: - Get Today Date
    func getCurrentDate() ->String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd MMM"
        let dateString = "Today, \(df.string(from: date))"
        return dateString
    }
    //MARK: - Check Valid Email
    func isValidEmail(testStr:String) -> Bool {
                print("validate emilId: \(testStr)")
                let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
                return result
            }
    //MARK: - Set Initial Root VC to Login
    func setRootToLogin(){
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        UIApplication.shared.windows.first?.rootViewController = rootVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    //MARK: - Set Initial Root VC to Home
    func setRootToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        UIApplication.shared.windows.first?.rootViewController = rootVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
}
extension UIView {
    
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        self.layer.addSublayer(gradientLayer)
    }
}
