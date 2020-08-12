//
//  WaitingRoom.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 11/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

//struct PlayerReady {
//    let avatarURL: String
//    let isHost: Bool
//    let realName: String
//    let stageName: String
//}

struct WaitingRoom: View {
    @State var roomName = ""
    @State var playerRow:Int = 3
    @State var playerColumn:Int = 5
    @State var isRoomEmpty:Bool = false
    @State var orangeBackground = Color(red: 0.91, green: 0.57, blue: 0.27, opacity: 1.00)
    @State var playerIndex:Int = 0
    
    //Global Store
    @State var isHost = false
    @State var currentPlayer: PlayerViewModel = PlayerViewModel()
    
    @EnvironmentObject var globalStore: GlobalStore
    @ObservedObject var inRoomService = InRoomService()
    @ObservedObject var startGameService = StartGameService()
    
    @State private var moveToQuestion = false
    
    
    var body: some View {
        ZStack{
            Image("backgroundGradient")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                    Image("roomIDButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack{
                        Text("Nomer Camp")
                            .lineLimit(2)
                            .frame(width:60)
                            .font(.system(size:16, weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                        Text(self.globalStore.roomName)
                            .lineLimit(2)
                            .frame(width:UIScreen.main.bounds.size.width * 0.4)
                            .font(.system(size:32, weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.size.width * 0.7, height: UIScreen.main.bounds.size.height * 0.1)
                .padding(.init(top: -100, leading: 8, bottom: 8, trailing: 8))
                
                ScrollView{
                    ForEach(0..<self.playerColumn){ i in
                        HStack {
                            ForEach(0..<self.playerRow){ j in
                                PlayersCollectionView(row: i, column: j)
                            }
                        }
                    }.frame(width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.65,alignment: .top)
                }
                .onAppear {
                    // clear players list before entering (join/create) the camp
                    self.globalStore.clearPlayers()

                    // set isHost, campCode, and player into global store
                    if let avatarURL = self.currentPlayer.avatarURL, let realName = self.currentPlayer.realName, let stageName = self.currentPlayer.stageName {
                        let isHost = self.currentPlayer.isHost
                        self.globalStore.currentPlayer = PlayersAvailable(
                            avatarURL: avatarURL,
                            isHost: isHost,
                            realName: realName,
                            stageName: stageName)
                    }

//                    self.globalStore.roomName = self.roomName
                    print("ini roomId nya \(self.globalStore.roomName)")
                    print(self.globalStore.currentPlayer)
                    
                    self.inRoomService.observeInRoomPlayers(campID: self.globalStore.roomName) {
                        roomValue in
                        guard let roomValue = roomValue else {return}
                        
                        DispatchQueue.main.async {
                            print(roomValue)
                            self.globalStore.players[self.playerIndex] = roomValue
                            self.playerIndex += 1
                        }
                        self.playerIndex = 0
                    }
                }
                .frame(width:UIScreen.main.bounds.size.width-100, height: UIScreen.main.bounds.size.height * 0.6)
                
                if self.globalStore.hostStart {
                    Button(action: {
                        print("Bangun Camp Pressed")
                        self.moveToQuestion = true
                        self.startGameService.updateIsStarted(campID: self.globalStore.roomName)
                    }) {
                        Image("buatcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, alignment: .center)
                            .padding()
                    }
                    NavigationLink(destination: QuestionParent(), isActive: $moveToQuestion) {
                        EmptyView()
                    }
                } else {
                    if self.globalStore.isStarted {
                        NavigationLink(destination: QuestionParent(), isActive: self.$globalStore.isStarted) {
                            EmptyView()
                        }
//                        NavigationLink(destination: QuestionParent())
                    } else {
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
        .onAppear{
            self.startGameService.watchHost(withCode: self.globalStore.roomName) { roomStatus in
                guard let roomStatus = roomStatus else {return}
                DispatchQueue.main.async {
                    print(self.globalStore.isStarted)
                    self.globalStore.isStarted = roomStatus
                    print(self.globalStore.isStarted)
                }
            }
        }
    }
}

struct WaitingRoom_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoom()
    }
}
