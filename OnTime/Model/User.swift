//
//  User.swift
//  OnTime
//
//  
//

import Foundation


struct  User {
    let fullname : String
    let email : String
    var uid : String
    
    init(uid:String,dictionary:[String:Any]) {
        self.uid = uid
        self.fullname = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
                
    }
}

