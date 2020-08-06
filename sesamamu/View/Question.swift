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
            }.navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea(.all)
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
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    @State private var ronde = 31
    @State private var subRonde = 1
    //Khusus ronde terakhir yang sudah di filter pake ronde = 31

    //DB
    @ObservedObject private var questionServices = QuestionServices()
    @ObservedObject private var answerService = AnswerService()
    
    //User Input
    @State private var userInput:String = ""
    @ObservedObject private var textCount = TextCount()
    
    //Alert
    @State private var textFieldEmpty = false
    
    //NavigationLink
    @State private var readyToMove = false


    var body: some View {
        ZStack{
            Image("backgroundRonde1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Ronde \(ronde)")
                    .font(Font.custom("Montserrat-Bold", size: 17))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                Text("Pertanyaan \(subRonde)/3")
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
                    if self.userInput != "" {
                        /*
                         answerService.sendAnswer(for: QuestionModel(round: ronde, text: self.userInput), at: globalStore.roomName, from: AnswerViewModel(stageName: <#T##String?#>, answerText: <#T##String?#>, isMyOwn: <#T##Bool#>, avatarURL: <#T##String?#>, timestamp: <#T##TimeInterval#>))
                         */
                        print("Final text: \(self.userInput)")
                        self.readyToMove = true
                    } else {
                        self.textFieldEmpty = true
                    }
                }) {
                    Image("buttonKirim")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 15)
                }.alert(isPresented: self.$textFieldEmpty) {
                    Alert(title: Text("Masih kosong nih"), message: Text("Hati aja perlu di isi, isiannya jangan lupa diisi juga ya kak"), dismissButton: .default(Text("Tjakep!")))}
                NavigationLink(destination: AllAnswersView(isHost: true), isActive: $readyToMove) {
                    EmptyView()
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
                .onAppear {
                    self.questionServices.fetchQuestion(forRound: self.ronde, campId: self.globalStore.roomName)}
        }
    }
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
