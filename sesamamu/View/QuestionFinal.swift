//
//  QuestionFinal.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI
import Firebase

struct QuestionFinal: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                QuestionFinalSubmitView()
            }.navigationBarHidden(true)
                .navigationBarTitle("")
                .edgesIgnoringSafeArea(.all)
        }.onTapGesture {self.hideKeyboard()}
    }
}

struct QuestionFinalSubmit_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            QuestionFinal().previewDevice("iPhone 11")
            QuestionFinal().previewDevice("iPhone 8")
        }
    }
}

struct QuestionFinalSubmitView: View {
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    //@State var campId = "123456"
    
    //DB
    @ObservedObject var questionServices = QuestionServices()

    var ronde: String = "Ronde 3"
    var rondeIntro: String = "Kalau kamu punya kesempatan untuk kenal dia lebih dalam dengan sebuah pertanyaan\n\nMau tanya apa??..."
    
    //User Input
    @State var userInput:String = ""
    @ObservedObject var textCount = TextCount()
    
    //Alert
    @State private var textFieldEmpty = false
    
    //NavigationLink
    @State private var readyToMove = false
        
    var body: some View {
        ZStack{
            Image("backgroundRonde3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("\(self.ronde)")
                    .font(Font.custom("Montserrat-Bold", size: 35))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.top, UIScreen.main.bounds.height*0.05)
                VStack{
                    Text("\"")
                        .font(Font.custom("Montserrat-ExtraBoldItalic", size: 35))
                        .foregroundColor(.white)
                        .frame(width: 250, alignment: .leading)
                    Text("\(self.rondeIntro)")
                        .font(Font.custom("Montserrat-BoldItalic", size: 15))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                        .lineSpacing(4)
                    Text("\"")
                        .font(Font.custom("Montserrat-ExtraBoldItalic", size: 35))
                        .foregroundColor(.white)
                        .frame(width: 250, alignment: .trailing)
                }.padding(.top, UIScreen.main.bounds.height*0.01)
                Spacer()
                ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.15)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    MultilineTextField("Tanya di sini ya", text: self.$textCount.userTextInput, charLimit: 150, onCommit: {
                        self.userInput = self.textCount.userTextInput
                        print("Final text: \(self.userInput)")
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
                    //MARK: - Save data to DB for vote
                    if self.userInput != "" {
                        self.questionServices.submitFinalQuestion(campId: self.globalStore.roomName, userQuestion: self.userInput)
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
                NavigationLink(destination: QuestionFinalVote(), isActive: $readyToMove) {
                    EmptyView()
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
        }
    }
}
