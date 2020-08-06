//
//  PlayerService.swift
//  sesamamu
//
//  Created by Davia Belinda Hidayat on 03/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PlayerService: ObservableObject{
    
    var playerReference = Database.database().reference().child("members")
    var playerHandle: UInt?
    
    func createPlayer(viewModel: PlayerViewModel, completion: @escaping (PlayerViewModel?) -> Void) {
        
        guard let stageName = viewModel.stageName,
            let realName = viewModel.realName ,
            let avatarURL = viewModel.avatarURL ,
            let campID = viewModel.campID else {
                completion(nil)
                return
        }
        
        let isHost = viewModel.isHost
        
        playerReference.child(campID).child(stageName).setValue([
            "realName": realName,
            "stageName": stageName,
            "avatarURL": avatarURL,
            "isHost": isHost
        ])
        completion(viewModel)
    }
    
    func findPlayerBy(stageName: String, campCode: String, completion: @escaping (PlayerViewModel?) -> Void) {
        playerHandle = playerReference.child(campCode).child(stageName).observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any],
                let avatarURL = value["avatarURL"] as? String,
                let isHost = value["isHost"] as? Bool,
                let realName = value["realName"] as? String,
                let stageName = value["stageName"] as? String else {
                
                print("Player cannot be found")
                completion(nil)
                return
            }
            
            let viewModel = PlayerViewModel(stageName: stageName,
                                            realName: realName,
                                            avatarURL: avatarURL,
                                            isHost: isHost,
                                            campID: campCode)
            print("Player is found:", viewModel)
            completion(viewModel)
        }
    }
    
    deinit {
        if let handle = playerHandle {
            playerReference.removeObserver(withHandle: handle)
        }
    }
}
