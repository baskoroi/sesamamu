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
    
    let ref = Database.database().reference().child("members")
    
    func createPlayer(viewModel: PlayerViewModel, completion: @escaping(PlayerViewModel?) -> Void){
        
        guard let stageName = viewModel.stageName,
            let realName = viewModel.realName ,
            let avatarURL = viewModel.avatarURL ,
            let campID = viewModel.campID else {
                completion(nil)
                return }
        
        let isHost = viewModel.isHost
        
        ref.child("\(campID)->\(stageName)").setValue([
            "realName": realName,
            "stageName": stageName,
            "avatarURL": avatarURL,
            "isHost": isHost
        ])
        completion(viewModel)
    }
    
}
