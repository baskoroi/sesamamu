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
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("explanation")
                }
                else if self.globalStore.page == "Question" {
                    QuestionView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("questionview")
                }
                else if self.globalStore.page == "AllAnswer" {
                    AllAnswersView(isHost: self.isHost)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("allanswer")
                }
                else if self.globalStore.page == "QuestionFinal" {
                    QuestionFinalView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("questionFinal")
                }
                else if self.globalStore.page == "QuestionFinalVote" {
                    QuestionFinalVoteView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationBarTitle("QuestionFinalVote")
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {self.hideKeyboard()}
        }
        .navigationBarBackButtonHidden(true)
                                                  .navigationBarHidden(true)
                                              .navigationBarTitle("QuestionParent")
    }
}

struct QuestionParent_Previews: PreviewProvider {
    static var previews: some View {
        QuestionParent()
    }
}
