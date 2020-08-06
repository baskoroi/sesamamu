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
    
    func calculateBondingMeterScore(campID: String, completion: @escaping (Int) -> Void ) {
        let ref = getDBReferenceForRoom(campID: campID).child("bondingMeterScore")
        var playerScores:[Int] = []
        
        
        bondMeterScoreHandle = ref.observe(.value, with: { (score) in
            if let score = score.value as? [String:Any] {
                
            }
//            completion(totalScore)
                
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    private func getDBReferenceForRoom(campID: String) -> DatabaseReference {
        
        return roomRef.child(campID)
    }
}

