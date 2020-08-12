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
                }
                else if self.globalStore.startPage == "WaitingRoom" {
                    WaitingRoom()
                }
                else if self.globalStore.startPage == "Question" {
                    QuestionParent()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {self.hideKeyboard()}
        }
//        .navigationBarHidden(true)
//        .navigationBarTitle("")
//        .navigationBarBackButtonHidden(true)
    }
}

struct HomeParent_Previews: PreviewProvider {
    static var previews: some View {
        HomeParent()
    }
}
