//
//  PlayerScoreService.swift
//  sesamamu
//
//  Created by dwitama alfred on 05/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PlayerScoreService: ObservableObject {
    
    var roomRef = Database.database().reference().child("camps")
    var bondMeterScoreHandle: UInt?
    
    
    func sendScore(campID: String, score: Int, playerName: String) {
        
        let ref = getDBReferenceForRoom(campID: campID)
        
        ref.child("bondingMeterScore").childByAutoId().setValue([
            "player" :  "\(playerName)",
            "score" : score
        ])
    }
    
    func calculateBondingMeterScore(campID: String, completion: @escaping (BondingMeterModel?) -> Void ) {
        let ref = getDBReferenceForRoom(campID: campID).child("bondingMeterScore")
//        var playerScores:[BondingMeterModel] = []
        
        
        bondMeterScoreHandle = ref.observe(.value, with: { snapshot in
            let value = snapshot.value as? [String:Any]
                
            value?.forEach({(key,value) in
                if let newValue = value as? [String:Any],
                    let name = newValue["player"] as? String,
                    let score = newValue["score"] as? Int {
                    
                    let viewModel = BondingMeterModel(name: name, score: score)
                    
//                    playerScores.append(viewModel)
                    
//                    print(playerScores)
                    completion(viewModel)
                    
                }else{
                    completion(nil)
                }
            })
//            completion(totalScore)
        })
        
        
    }
    
    private func getDBReferenceForRoom(campID: String) -> DatabaseReference {
        
        return roomRef.child(campID)
    }
}

