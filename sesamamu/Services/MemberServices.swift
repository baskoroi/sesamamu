//
//  MemberServices.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 05/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MemberService {
    
    var memberRef = Database.database().reference().child("members")
    var memberRefHandle: UInt?
    
    func create(campCode: String, member: MemberViewModel) {
        let (isHost, stageName, realName, avatarURL) = (member.isHost,
                                                        member.stageName,
                                                        member.realName,
                                                        member.avatarURL)

        memberRef.child("\(campCode)->\(stageName)").updateChildValues([
            "isHost": isHost,
            "stageName": stageName,
            "realName": realName,
            "avatarURL": avatarURL,
        ])
    }
    
    func observeCreation(completion: @escaping (Bool) -> Void) {
        memberRef.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any],
                let _ = value["isHost"] as? Bool,
                let _ = value["stageName"] as? String,
                let _ = value["realName"] as? String,
                let _ = value["avatarURL"] as? String {
                
                completion(true)
                return
            }
        })
    }
    
    deinit {
        if let handle = memberRefHandle {
            memberRef.removeObserver(withHandle: handle)
        }
    }
    
}
