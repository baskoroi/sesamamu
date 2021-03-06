//
//  QuestionFinalVote.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI
import Firebase

struct QuestionFinalVote: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                QuestionFinalVoteView()
            }.navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct QuestionFinalVote_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            QuestionFinalVote().previewDevice("iPhone 11")
            QuestionFinalVote().previewDevice("iPhone 8")
        }
    }
}

struct QuestionFinalVoteView: View {
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    @State var campId = "777777"
    @State private var generateNewRound = true
    @State private var isHost = true
    
    //DB
    @ObservedObject var questionServices = QuestionServices()
    @State var questions = [QuestionViewModel]()

    //DB
    @State var ronde = 3
    
    var rondeIntro: String = "Pilih 3 pertanyaan yang paling menarik hati"

    //User Input
    @State var selectedQuestion = [String]()
    @State var noPertanyaan = 1
    
    //Alert
    @State private var tooMuch = false
    
    //NavigationLink
    @State private var readyToMove = false
    
    var body: some View {
        ZStack{
            Image("backgroundRonde3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ScrollView{
                    ForEach(questionServices.questionArrayForRound, id: \.id) { (question) in
                        ZStack{
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.12)
                                .foregroundColor(self.selectedQuestion.contains(question.text ?? "") ? .yellow : .white)
                                .cornerRadius(12)
                            VStack{
                                Text("Pertanyaan")
                                    .font(Font.custom("Montserrat-Bold", size: 15))
                                Text(question.text ?? "")
                                    .font(Font.custom("Montserrat", size: 15))
                                    .padding(.top, 10)
                                    .multilineTextAlignment(.center)
                            }.padding(.horizontal, 40)
                        }
                        .onTapGesture {
                            if self.selectedQuestion.contains(question.text ?? ""){
                                if let pos = self.selectedQuestion.firstIndex(of: question.text ?? "") {
                                    self.selectedQuestion.remove(at: pos)
                                }
                            } else {
                                if self.selectedQuestion.count > 2 {
                                    self.tooMuch = true
                                } else {
                                    self.selectedQuestion.append(question.text ?? "")
                                    print(self.selectedQuestion)
                                }
                            }}
                            .alert(isPresented: self.$tooMuch) {
                                Alert(title: Text("Kebanyakan kakak"), message: Text("Pilih 3 aja ya, jangan serakah"), dismissButton: .default(Text("Siaap!")))}
                            .offset(y: UIScreen.main.bounds.height*0.05)
                    }
                }
                
                Text("\(self.rondeIntro)")
                    .font(Font.custom("Montserrat-BoldItalic", size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                
                Button(action: {
                    print("Kirim Tapped")
                    self.submitAllVotedQuestion()
                    self.readyToMove = true
                    //Func ini lebih baik cuma dipanggil sekali jadi kefilter cuma sekali, better host nya aja yang punya func ini tapi baru ke trigger kalau semua udah ngevote. Fungsi ngecek semua udah jawab atau belum, belum ada nih
                    self.questionServices.findTopThreeQuestion(forRound: 3, campId: self.campId /*self.globalStore.roomName*/, isHost: self.isHost, generateNewRound: self.generateNewRound)
                }) {
                    Image("buttonKirim")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                }
                
                NavigationLink(destination: Explanation(), isActive: $readyToMove) {
                    EmptyView()
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
                .onAppear {
                    self.questionServices.fetchQuestion(forRound: self.ronde, campId:self.campId /*self.globalStore.roomName*/)
            }
        }
    }
    
    func submitAllVotedQuestion() {
        questionServices.fetchQuestion(forRound: 3, campId: self.campId /*globalStore.roomName*/)
        for question in selectedQuestion {
            questionServices.submitQuestionForVote(campId: self.campId /*globalStore.roomName*/, questionVoteText: question, numberOfVote: 1)
        }
    }
}


//MARK: - NOTES
/*
 3. Perlu tau di udah di ronde dan pertanyaan ke berapa, dan perpindahannya gimn?
 4. Perlu logic gimna caranya tau semua orang udah ngevote
*/
