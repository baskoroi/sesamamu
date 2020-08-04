//
//  inRoomService.swift
//  sesamamu
//
//  Created by dwitama alfred on 04/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class InRoomService: ObservableObject {
    
    var inRoomRef = Database.database().reference().child("members")
    var inRoomHandle: UInt?
    
    func observeInRoomPlayers(campID: String, completion: @escaping (PlayersAvailable?) -> Void) {
        let ref = getDBReferenceForInRoom(campID: campID)
        
        inRoomHandle = ref.observe(.value, with: { snapshot in
            let value = snapshot.value as! [String:Any]
            
            print(value)
//            let newDict = value.values
            value.forEach({(key,value) in
                if let newValue = value as? [String:Any],
                let realName = newValue["realName"] as? String,
                let stageName = newValue["stageName"] as? String,
                let isHost = newValue["isHost"] as? Bool,
                    let avatarUrl = newValue["avatarURL"] as? String {
                    
                    let viewModel = PlayersAvailable(avatarURL: avatarUrl, isHost: isHost, realName: realName, stageName: stageName)
                    
                    print(newValue)
                    completion(viewModel)
                } else {
                    completion(nil)
                }
            })
        })
        
        
        
    }
    
    
    private func getDBReferenceForInRoom(campID: String) -> DatabaseReference {
        
        return inRoomRef.child(campID)
    }
    
}
