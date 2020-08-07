//
//  BondingMeter.swift
//  sesamamu
//
//  Created by dwitama alfred on 29/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import SwiftUI

struct playerAnswer {
    var name : String
    var correctAnswer : String
//    var choosenPair : String = ""
    var status : Bool = false
    var number : Int = 0
}



class GlobalStore: ObservableObject {
    
    @Published var bondingMeterScore = 0
    @Published var correctChoices = []
    
    // TODO rename to `campCode`
    @Published var roomName:String = "room1"
    //@Published var playerName:String = "Markus"
    //@Published var isHost:Bool = true

    @Published var currentPlayer: PlayersAvailable = PlayersAvailable(avatarURL: "", isHost: false, realName: "", stageName: "")
    var isHost: Bool { self.currentPlayer.isHost }

    @Published var playerAnswerName : [playerAnswer] = [] //ini tiap buttonnya masuk
    
    
    @Published var players:[PlayersAvailable] = [
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: ""),
         PlayersAvailable(avatarURL: "", isHost:false, realName :"",stageName: "")
     ]
    
    func clearPlayers() {
        self.players = Array(
            repeating: PlayersAvailable(avatarURL: "", isHost: false, realName: "",stageName: ""),
            count: 15)
    }
    
    
    @Published var inGamePlayer:[playerAnswer] = [
//        playerAnswer(name: "real1", correctAnswer: "stage1"),
//        playerAnswer(name: "real2", correctAnswer: "stage2"),
//        playerAnswer(name: "real3", correctAnswer: "stage3"),
//        playerAnswer(name: "real4", correctAnswer: "stage4"),
//        playerAnswer(name: "real5", correctAnswer: "stage5"),
//        playerAnswer(name: "real6", correctAnswer: "stage6"),
//        playerAnswer(name: "real7", correctAnswer: "stage7"),
//        playerAnswer(name: "real8", correctAnswer: "stage8"),
//        playerAnswer(name: "real9", correctAnswer: "stage9"),
//        playerAnswer(name: "real10", correctAnswer: "stage10"),
//        playerAnswer(name: "real11", correctAnswer: "stage11"),
//        playerAnswer(name: "real12", correctAnswer: "stage12"),
//        playerAnswer(name: "real13", correctAnswer: "stage13"),
//        playerAnswer(name: "real14", correctAnswer: "stage14"),
//        playerAnswer(name: "real15", correctAnswer: "stage15"),
//                playerAnswer(name: "stage1", correctAnswer: "real1"),
//                playerAnswer(name: "stage2", correctAnswer: "real2"),
//                playerAnswer(name: "stage3", correctAnswer: "real3"),
//                playerAnswer(name: "stage4", correctAnswer: "real4"),
//                playerAnswer(name: "stage5", correctAnswer: "real5"),
//                playerAnswer(name: "stage6", correctAnswer: "real6"),
//                playerAnswer(name: "stage7", correctAnswer: "real7"),
//                playerAnswer(name: "stage8", correctAnswer: "real8"),
//                playerAnswer(name: "stage9", correctAnswer: "real9"),
//                playerAnswer(name: "stage10", correctAnswer: "real10")
//                playerAnswer(name: "stage11", correctAnswer: "real11"),
//                playerAnswer(name: "stage12", correctAnswer: "real12"),
//                playerAnswer(name: "stage13", correctAnswer: "real13"),
//                playerAnswer(name: "stage14", correctAnswer: "real14"),
//                playerAnswer(name: "stage15", correctAnswer: "real15")
    ].shuffled()
}
