//
//  RoomPlayerParent.swift
//  sesamamu
//
//  Created by dwitama alfred on 10/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct RoomPlayerParent: View {
    @EnvironmentObject var globalStore: GlobalStore
    @State var isHost = false
    @State var playerIndex:Int = 0
    
    @State var roomName = "room1"
    @State var currentPlayer: PlayerViewModel = PlayerViewModel(isHost: false)
    var isStarted = false
    
    @State var page = String()
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                if self.globalStore.isStarted == false {
                    RoomPlayer(isHost: self.globalStore.isHost,
                               roomName: self.globalStore.roomName)
                }
                else{
                    Explanation()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {self.hideKeyboard()}
        }.navigationBarHidden(true)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
    }
}

struct RoomPlayerParent_Previews: PreviewProvider {
    static var previews: some View {
        RoomPlayerParent()
    }
}
