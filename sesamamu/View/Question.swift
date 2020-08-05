//
//  Question.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//
import SwiftUI
import Combine
import Firebase

struct Question: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                QuestionView()
            }
        }.onTapGesture {self.hideKeyboard()}
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            Question().previewDevice("iPhone 11")
            Question().previewDevice("iPhone 8")
        }
    }
}

struct QuestionView: View {
    //DB
//    private var questionRef = Database.database().reference().child("questions")
    @State var round = "1"
    @State var subRound = "1"
//    @State var questionArray = []
//    @State var randomQuestion = String()
//    @State var questionRandom = String()
 
    @ObservedObject var questionServices = QuestionServices()
    
    @State var userInput:String = ""
    @ObservedObject var textCount = TextCount()

    var body: some View {
        ZStack{
            Image("backgroundRonde1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Ronde \(round)")
                    .font(Font.custom("Montserrat-Bold", size: 17))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                Text("Pertanyaan \(subRound)/3")
                    .font(Font.custom("Montserrat-Bold", size: 20))
                    .foregroundColor(.white)
                Rectangle()
                    .frame(width: 30, height: 3)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                Text(questionServices.questionForRound.text ?? "")
                    .font(Font.custom("Montserrat-BoldItalic", size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width*0.8)
                    .lineSpacing(4)
                Spacer()
                ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.15)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    MultilineTextField("Jawab di sini ya", text: self.$textCount.userTextInput, charLimit: 150, onCommit: {
                        self.userInput = self.textCount.userTextInput
                    })
                        .frame(width: UIScreen.main.bounds.width*0.85)
                        .font(.system(size: 18))
                    
                    if self.textCount.charCount < 120 {
                        Text ("\(self.textCount.charCount)/150")
                            .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    } else if self.textCount.charCount < 145{
                        Text ("\(self.textCount.charCount)/150")
                            .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                            .font(.system(size: 15))
                            .foregroundColor(.yellow)
                    } else {
                        Text ("\(self.textCount.charCount)/150")
                            .frame(width: UIScreen.main.bounds.width*0.80, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                    }
                }.keyboardAdaptive()
                    .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 1))

                Button(action: {
                    print("Kirim tapped")
                    //MARK: - Save answer to DB for chat room
                    print("Final text: \(self.userInput)")
                }) {
                    Image("buttonKirim")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 15)
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
                .onAppear {
                    self.questionServices.fetchQuestion(forRound: 1, campId: "")}
        }
    }
    
//    //Get question from DB and add it to questionArray
//    func fetchQuestion(forRound:String) {
//        questionRef.child("round\(forRound)").observeSingleEvent(of: .value, with: { (snapshot) in
//            let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
//            if let questionRandomDict = questionArrayChildren.randomElement()?.value as? [String: Any]{
//                self.questionRandom = questionRandomDict["text"] as? String ?? ""
//            }
//          }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
    
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: -self.keyboardHeight*0.75)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
