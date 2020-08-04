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
    
   
    
    var ref = Database.database().reference().child("camps")
    
    func createCamp(playerViewModel: PlayerViewModel, maxPlayers: Int, completion: @escaping(CampViewModel?, PlayerViewModel) -> Void){
        
        guard let stageName = playerViewModel.stageName else {
            completion(nil, playerViewModel)
            return }
        
        var playerViewModel = playerViewModel
        
        let campID = String(Int.random(in: 100000...999999))
        playerViewModel.campID = campID
        
        let hostName = "\(campID)->\(stageName)"
        ref.child(campID).setValue([
            "host": hostName,
            "maxPlayers": maxPlayers
        ])
        
        let campViewModel = CampViewModel(maxPlayers: maxPlayers, campCode: campID)
        
        completion(campViewModel, playerViewModel)
        
    }
}
