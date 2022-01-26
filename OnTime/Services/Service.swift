//
//  Service.swift
//  OnTime
//
//  
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let REF_USERS =  DB_REF.child("users")
let REF_NOTES = DB_REF.child("notes")
let REF_SCHEDULE = DB_REF.child("schedule")

struct FirebaseService {
    static let shared = FirebaseService()
    
    func fetchUserData(uid:String,completion : @escaping(User) -> Void){
        guard let currentUId = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(currentUId).observeSingleEvent(of: .value) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            print(user)
            completion(user)
        }
    }
    func uploadNotes(with title:String,description:String,isPinned:String,date:String,completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [
            "title": title,
            "description": description,
            "isPinned": isPinned,
            "Date" : date] as [String: Any]
        let thisNotesRef = REF_NOTES.child(uid).childByAutoId()
        thisNotesRef.setValue(values, withCompletionBlock: completion)
    }
    
    func uploadSchedule(with dateasID : String, title:String,fullday:String,startTime:String,endTime:String,isrepeat:String,remainder:String,notes:String,priority:String,place:String,completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [
            "serverDate" : dateasID,
            "title"  : title,
            "fullday" : fullday,
            "startTime" : startTime,
            "endTime" : endTime,
            "repeat" : isrepeat,
            "remainder" : remainder,
            "notes" : notes,
            "priority" : priority,
            "place" : place
        ] as [String:Any]

        let thisScheduleRef = REF_SCHEDULE.child(uid).childByAutoId().child(dateasID)
        thisScheduleRef.setValue(values, withCompletionBlock: completion)
    }
}

