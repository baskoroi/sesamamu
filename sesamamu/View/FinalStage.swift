//
//  FinalStage.swift
//  sesamamu
//
//  Created by dwitama alfred on 29/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct FinalStage: View {
    
    @State var page = "opening"
    @State var correctAnswer:Double = 0
    @EnvironmentObject var globalStore: GlobalStore
    @ObservedObject var playerScoreService = PlayerScoreService()
    
    var body: some View {
        
        NavigationView{
            GeometryReader { geometry in
                
                ZStack(alignment: .bottom){
                    Image("background-night")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    
                    if self.page == "opening" {
                        FinalStage_0()
                    }else if self.page == "guessingPage" {
                        FinalStage1()
                    }else{
                        FinalStage_2()
                    }
                    
                    
                    Spacer()
                    VStack(alignment: .center){
                        if self.page == "opening"{
                            VStack{
                                Button(action: {
                                    self.page = "guessingPage"
                                }) {
                                    
                                    Image("tebakPemain-button")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 250, alignment: .center)
                                }
                                
                                NavigationLink(destination: HomeView()){
                                    
                                    Image("mainLagi-button")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 250, alignment: .center)
                                }
                                
                            }.offset(y:-(UIScreen.main.bounds.size.height*0.1))
                            
                        }
                        else if self.page == "guessingPage" {
                            Button(action: {
//                                self.globalStore.bondingMeterScore = 0
                                let sortedAnswer = self.globalStore.inGamePlayer.sorted { $0.number < $1.number }
                                print("this is the sorted answer")
                                print(sortedAnswer)
                                
                                for i in 0..<sortedAnswer.count-1 {
                                    if sortedAnswer[i].name == sortedAnswer[i+1].correctAnswer && sortedAnswer[i].correctAnswer == sortedAnswer[i+1].name && sortedAnswer[i].number == sortedAnswer[i+1].number {
                                        self.correctAnswer += 1
                                    }
                                }
                                
                                self.globalStore.bondingMeterScore = Int(Double(self.correctAnswer)/Double(self.globalStore.inGamePlayer.count/2) * 100)
                                
                                self.playerScoreService.sendScore(campID: "room1", score: self.globalStore.bondingMeterScore, playerName: "baskoro")
                                
                                
                                self.page = "bondingMeter"
                            }) {
                                Image("button-finish")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, alignment: .center)

                            }.offset(y:-(UIScreen.main.bounds.size.height*0.1))
                        }
                        
                    }
                }
            }
        }
    }
    
    struct FinalStage_Previews: PreviewProvider {
        static var previews: some View {
            FinalStage()
        }
    }
}
