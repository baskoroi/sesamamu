//
//  StartGameService.swift
//  sesamamu
//
//  Created by dwitama alfred on 10/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class StartGameService: ObservableObject {
    
    var roomRef = Database.database().reference().child("camps")
    var campHandle: UInt?
    
    func updateIsStarted(campID: String) {
        
        let ref = roomRef.child(campID)
        
        ref.updateChildValues(["isStarted" : true])
    }
    
    func watchHost(withCode campCode: String,
                     completion: @escaping(Bool?) -> Void) {
           
           campHandle = roomRef.child(campCode).observe(.value) { (snapshot) in
               
               guard let value = snapshot.value as? [String: Any],
                   
                    let isStarted = value["isStarted"] as? Bool else {
                   
                   print("Camp is not found")
                   completion(nil)
                   return
               }
               
              let gameIsStarted = isStarted
            
               
               completion(gameIsStarted)
           }
       }
    
}
