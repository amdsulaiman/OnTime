//
//  NotificationVC.swift
//  OnTime
//
//  
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var notificationsTableview: UITableView!
    let backgroundImage = UIImage(named: "gradientbg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callFunc()

        
    }
    func callFunc(){
        setupTableview()
    }
    func setupTableview(){
        notificationsTableview.register(NotificationsTableViewCell.nib(), forCellReuseIdentifier: "NotificationsTableViewCell")
        notificationsTableview.backgroundColor = .white
        notificationsTableview.delegate = self
        notificationsTableview.dataSource = self
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.notificationsTableview.backgroundView = imageView
        notificationsTableview.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: notificationsTableview.frame.size.width, height: notificationsTableview.frame.size.height))
        notificationsTableview.tableFooterView = UIView()
    }
    
    @IBAction func onClickDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = notificationsTableview.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.identifier, for: indexPath) as! NotificationsTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

}
