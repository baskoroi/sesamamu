//
//  HomeParent.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 11/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//
import SwiftUI
import Firebase

struct HomeParent: View {
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    
    //Router
    @State var page = String()
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                if self.globalStore.startPage == "StartGame" {
                    MulaiMain()
                }
                else if self.globalStore.startPage == "SelectAvatar" {
                    SelectAvatar(host: self.globalStore.hostStart)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("back")
                }
                else if self.globalStore.startPage == "WaitingRoom" {
                    WaitingRoom()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("waiting room")
                }
                else if self.globalStore.startPage == "Question" {
                    QuestionParent()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("question")
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {self.hideKeyboard()
//                playSound(sound: "sesamamuBGM2", type: "mp3")
            }
        }
      
    }
}

struct HomeParent_Previews: PreviewProvider {
    static var previews: some View {
        HomeParent()
    }
}
