//
//  QuestionParent.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 10/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI
import Firebase

struct QuestionParent: View {
    
    @EnvironmentObject var globalStore: GlobalStore
    var isHost = true

//    @State var page = String()
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                if self.globalStore.page == "Explanation" {
                    ExplanationView()
                }
                else if self.globalStore.page == "Question" {
                    QuestionView()
                }
                else if self.globalStore.page == "AllAnswer" {
                    AllAnswersView(isHost: self.isHost)
                }
                else if self.globalStore.page == "QuestionFinal" {
                    QuestionFinalView()
                }
                else if self.globalStore.page == "QuestionFinalVote" {
                    QuestionFinalVoteView()
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

struct QuestionParent_Previews: PreviewProvider {
    static var previews: some View {
        QuestionParent()
    }
}
