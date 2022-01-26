//
//  SettingsVC.swift
//  OnTime
//
//  
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var settingsTableview: UITableView!
    let backgroundImage = UIImage(named: "gradientbg")
    var settingsArr = ["Notifications","Audio","Notification bar","Extras","Help","About"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        callfunc()

       
    }
    func callfunc(){
        setupTableview()
    }
    func configUI(){
        
    }
    func setupTableview(){
        settingsTableview.register(SettingsTableViewCell.nib(), forCellReuseIdentifier: "SettingsTableViewCell")
        settingsTableview.backgroundColor = .white
        settingsTableview.delegate = self
        settingsTableview.dataSource = self
        settingsTableview.tableFooterView = UIView()
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.settingsTableview.backgroundView = imageView
        settingsTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableview.frame.size.width, height: settingsTableview.frame.size.height))
        settingsTableview.isScrollEnabled = false
    }

    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableview.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0  {
            cell.bottomLbl.isHidden = false
        }
        else if indexPath.row == 3 {
            cell.bottomLbl.isHidden = false
        }
        else {
            cell.bottomLbl.isHidden = true
        }
        cell.titleLbl.text = settingsArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated:true)
        }
    }
    

}
