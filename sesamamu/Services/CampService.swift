//
//  CampService.swift
//  sesamamu
//
//  Created by Davia Belinda Hidayat on 03/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CampService: ObservableObject {

    var campReference = Database.database().reference().child("camps")
    var campHandle: UInt?
    
    func findCamp(withCode campCode: String,
                  completion: @escaping(CampViewModel?) -> Void) {
        
        campHandle = campReference.child(campCode).observe(.value) { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any],
                  let maxPlayers = value["maxPlayers"] as? Int else {
                
                print("Camp is not found")
                completion(nil)
                return
            }
            
            let campViewModel = CampViewModel(maxPlayers: maxPlayers, campCode: campCode)
            print("Camp is found:", campViewModel)
            completion(campViewModel)
        }
        
    }
    
    func createCamp(playerViewModel: PlayerViewModel,
                    maxPlayers: Int,
                    completion: @escaping(CampViewModel?, PlayerViewModel) -> Void){
        
        guard let stageName = playerViewModel.stageName else {
            completion(nil, playerViewModel)
            return }
        
        var playerViewModel = playerViewModel
        
        let campID = String(Int.random(in: 100000...999999))
        playerViewModel.campID = campID
        
        let hostName = "\(campID)->\(stageName)"
        campReference.child(campID).setValue([
            "host": hostName,
            "maxPlayers": maxPlayers
        ])
        
        let campViewModel = CampViewModel(maxPlayers: maxPlayers, campCode: campID)
        
        completion(campViewModel, playerViewModel)
        
    }
    
    deinit {
        if let handle = campHandle {
            campReference.removeObserver(withHandle: handle)
        }
    }
}

