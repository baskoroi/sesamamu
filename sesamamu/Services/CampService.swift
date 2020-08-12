//
//  CampService.swift
//  sesamamu
//
//  Created by Davia Belinda Hidayat on 03/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum CampServiceError: Error {
    case invalidInput(String)
    case campIsFull(String)
    case failedProcessing(String)
}

class CampService: ObservableObject {
    var campReference = Database.database().reference().child("camps")
    let playerService = PlayerService()
    var campHandle: UInt?
    
    func findCamp(withCode campCode: String,
                  completion: @escaping(CampViewModel?) -> Void) {
        
        campReference.child(campCode).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any],
                let maxPlayers = value["maxPlayers"] as? Int,
                let playerCount = value["playerCount"] as? Int else {
                
                print("Camp is not found")
                completion(nil)
                return
            }
            
            let campViewModel = CampViewModel(
                maxPlayers: maxPlayers,
                playerCount: playerCount,
                campCode: campCode)
            print("Camp is found:", campViewModel)
            completion(campViewModel)
        }
    }
    
    // escaping closure parameters:
    // 1. current number of players in the camp
    // 2. max players in the camp
    // 3. the camp service error and its message
    func countPlayersInCamp(campCode: String, completion: @escaping (Int?, Int?) -> Void) {
        // intentionally .observe() to capture streams of values
        campReference.child(campCode).observe(.value) { (snapshot) in
            
            // get current data snapshot
            guard let value = snapshot.value as? [String: Any],
                let playerCount = value["playerCount"] as? Int,
                let maxPlayers = value["maxPlayers"] as? Int else {
                
                // skip the error and assume as joinable, as nil value might mean we could get the non-nil snapshots in near future
                completion(nil, nil)
                return
            }
            
            completion(playerCount, maxPlayers)
        }
    }
    
    // check whether the stage name is available,
    // the trailing closure parameters are:
    // 1. whether the stage name is available (true) or taken (false)
    // 2. the error that might need some capturing
    func checkStageNameAvailability(stageName: String,
                                    campCode: String,
                                    completion: @escaping (Bool, CampServiceError?) -> Void) {
        if stageName.isEmpty || campCode.isEmpty { return }
        
        playerService.findPlayerBy(stageName: stageName, campCode: campCode) { (player) in
            if player != nil {
                completion(false, .invalidInput("Nama panggungnya udah diambil orang lain. Bikin baru dong :)"))
                return
            }
            
            completion(true, nil)
        }
    }
    
    func joinCamp(withCode campCode: String,
                  playerCount: Int,
                  playerViewModel: PlayerViewModel,
                  // parameters: (is camp joinable?, camp code, error w/ message)
                  completion: @escaping(Bool, String, CampServiceError?) -> Void) {
        
        playerService.createPlayer(viewModel: playerViewModel) { (player) in
            if player == nil {
                completion(false, campCode, .failedProcessing("Yah servernya blum bisa buatin playermu. Cek koneksi atau coba lagi... :("))
                return
            }
            
            self.campReference.child(campCode).updateChildValues([
                "playerCount": playerCount + 1
            ])
            completion(true, campCode, nil)
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
            "maxPlayers": maxPlayers,
            "playerCount": 1, // start from the host first
            "isStarted": false
        ])
        
        let campViewModel = CampViewModel(maxPlayers: maxPlayers, playerCount: 1, campCode: campID)
        
        completion(campViewModel, playerViewModel)
        
    }
    
    deinit {
        if let handle = campHandle {
            campReference.removeObserver(withHandle: handle)
        }
    }
}
