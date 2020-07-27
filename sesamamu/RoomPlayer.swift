//
//  RoomPlayer.swift
//  swiftUIPractice
//
//  Created by dwitama alfred on 22/07/20.
//  Copyright © 2020 Davia Belinda Hidayat. All rights reserved.
//

import SwiftUI

var isHost: Bool = false

struct PlayersAvailable {
    let avatarURL: String
    let isHost: Bool
    let realName: String
    let stageName: String
}

struct RoomPlayer: View {
    
    @State var playerRow:Int = 3
    @State var playerColumn:Int = 5
    @State var isRoomEmpty:Bool = false
    @State var orangeBackground = Color(red: 0.91, green: 0.57, blue: 0.27, opacity: 1.00)
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment:.center){
                Image("backgroundGradient")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width)
                
                VStack(){
                    ZStack{
                        Image("roomIDButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: geometry.size.width/1.5)
                            .padding()
                        HStack{
                            Text("Nomer Camp")
                                .lineLimit(2)
                                .frame(width:60)
                                .font(.system(size:16, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                            Text("6759512")
                                .lineLimit(2)
                                .frame(width:180)
                                .font(.system(size:35, weight: .bold, design: .default))
                                .multilineTextAlignment(.center)
                        }
                        
                    }
                    ScrollView{
                        ForEach(0..<self.playerColumn){ i in
                            HStack {
                                ForEach(0..<self.playerRow){ j in
                                    PlayersCollectionView(row: i, column: j)
                                }
                            }
                        }
                    }
                    .frame(width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.65)
                    
                    if(isHost){
                        Button(action: {
                            print("buat camp tapped")
                        }) {
                            Image("buatcamp")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, alignment: .center)
                                .padding()
                        }
                    }else{
                        Text("Menunggu Tuan Rumah Untuk Memulai Permainan...")
                            .italic()
                            .lineLimit(3)
                            .frame(width:UIScreen.main.bounds.size.width * 0.6)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.system(size:18, weight: .bold, design: .default))
                            .padding()
                    }
                }
            }
        }
    }
}

struct RoomPlayer_Previews: PreviewProvider {
    static var previews: some View {
        RoomPlayer()
    }
}

struct PlayersCollectionView: View {
    
    @State var backgroundBox = Color(red: 0.04, green: 0.15, blue: 0.20, opacity: 1.0)
    @State var orangeBox = Color(red: 0.91, green: 0.57, blue: 0.27, opacity: 1.00)
    
    let players:[PlayersAvailable] = [
        PlayersAvailable(avatarURL: "Tiger", isHost:false, realName :"baskoro",stageName: "Wadidaw Boi"),
        PlayersAvailable(avatarURL: "BullDog", isHost:true, realName :"markus",stageName: "Boombayah"),
        PlayersAvailable(avatarURL: "Dog", isHost:false, realName :"christian",stageName: "Aku Padamu"),
        PlayersAvailable(avatarURL: "Pinguin", isHost:false, realName :"alfred",stageName: "Lee Tae Oh"),
        PlayersAvailable(avatarURL: "Rabbit", isHost:false, realName :"davia",stageName: "Lisa BlackPink"),
        PlayersAvailable(avatarURL: "", isHost: false, realName :"",stageName: ""),
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
    
    var index = 0
    init(row: Int, column: Int) {
        index = row+column+(row*2)
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            if(players[index].avatarURL == ""){
                ZStack{
                    Text("Ruang Tersedia")
                        .frame(width:UIScreen.main.bounds.size.width/5)
                        .multilineTextAlignment(.center)
                        .frame(width:UIScreen.main.bounds.size.width/3.5,height:UIScreen.main.bounds.size.height/5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.backgroundBox, style: StrokeStyle(lineWidth: 2, dash:[5]))
                    )
                    
                }
            }else{
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width:UIScreen.main.bounds.size.width/3.5,height:UIScreen.main.bounds.size.height/5)
                    .foregroundColor(self.backgroundBox)
                VStack(alignment: .center){
                    ZStack{
                        
                        Image(players[index].avatarURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                        if players[index].isHost {
                            Image("hostIcon150x150")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:UIScreen.main.bounds.size.width/10)
                                .position(.init(x: 95, y: 25))
                        }
                        
                    }
                    .frame(width:UIScreen.main.bounds.size.width/3.5,height:UIScreen.main.bounds.size.height/7)
                    
                    ZStack(alignment: .center){
                        RoundedRectangle(cornerRadius: 3)
                            .frame(width:UIScreen.main.bounds.size.width/4,height:UIScreen.main.bounds.size.height/25)
                            .foregroundColor(self.orangeBox)
                        
                        Text(players[index].stageName)
                            .frame(width:UIScreen.main.bounds.size.width/4,height:UIScreen.main.bounds.size.height/25,alignment: .center)
                            .font(.system(size: 15, weight: .heavy, design: .default))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.init(top: 0, leading: 8, bottom: 8, trailing: 8))
                }
            }
            
        }
    }
}
