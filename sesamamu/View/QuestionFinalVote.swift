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
//        NavigationView{
            GeometryReader { geometry in
                QuestionFinalVoteView()
            }
        }
//    }
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
    //VM
    @ObservedObject var questionServices = QuestionServices()
    @State var questions = [QuestionViewModel]()

    //DB
//    private var questionRef = Database.database().reference().child("questions")
    @State var ronde = "3"
//    @State var questionArray = [String]()
    @State var campId = "123456"
    
    var rondeIntro: String = "Pilih 3 pertanyaan yang paling menarik hati"
//    var finalRoundQuestionVote = ["Bagian tubuh favoritemu?", "Kalo besok kiamat apa yang bakal kamu lakuin hari ini?", "Lo pake kacamata atau ga?", "Sebutin ciri-ciri lo yang paling unik!!", "Siapa pirs lopemu?", "Kalau udah gede mau jadi apa?"]
    
    @State var selectedQuestionId = [UUID]()
    @State private var tooMuch = false
    @State var noPertanyaan = 1
    
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
                                .foregroundColor(self.selectedQuestionId.contains(question.id) ? .yellow : .white)
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
                            if self.selectedQuestionId.contains(question.id){
                                if let pos = self.selectedQuestionId.firstIndex(of: question.id) {
                                    self.selectedQuestionId.remove(at: pos)
                                }
                            } else {
                                if self.selectedQuestionId.count > 2 {
                                    self.tooMuch = true
                                } else {
                                    self.selectedQuestionId.append(question.id)
                                    print(self.selectedQuestionId)
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
//                    self.submitQuestionForVote()
                }) {
                    Image("buttonKirim")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
                .onAppear {
                    self.questionServices.fetchQuestion(forRound: 3, campId: self.campId)
//                    DispatchQueue.main.async {
//                        self.fetchQuestion(forRound: self.ronde)
//                    }
            }
        }
    }
//    //Get question from DB and add it to questionArray
//    func fetchQuestion(forRound:String) {
//        questionRef.child("round\(forRound)/\(campCode)/submitted").observeSingleEvent(of: .value, with: { (snapshot) in
//            let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
//            for questionSubmitted in questionArrayChildren {
//                let question = questionSubmitted.value as? [String: String]
//                if let textQuestion = question?["text"] {
//                    self.questionArray.append(textQuestion)
//                    print(self.questionArray)
//                }
//            }
//          }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
//    func submitQuestionForVote() {
//        for select in selectedIndex {
//            print(questionArray[select])
//        }
//    }
}
