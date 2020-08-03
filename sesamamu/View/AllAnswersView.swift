//
//  AllAnswersView.swift
//  sesamamu
//
//  Created by Baskoro Indrayana on 07/28/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct AllAnswersView: View {

    var isHost: Bool
    
    @State private var answers: [AnswerViewModel] = []
    @ObservedObject var answerService = AnswerService()
    
    var body: some View {
        VStack {
            // MARK: Question in quotes
            QuotedQuestionView()
                .padding(.top, 36)
            
            // MARK: List of answers (chat-like UI)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(answers, id: \.self) { answer in
                            AnswerCell(viewModel: answer)
                    }
                }
                
                // this HStack here gives space to ScrollView,
                // preventing "invisible data" issue after fetch from Firebase
                if self.answers.count == 0 {
                    HStack {
                        Spacer()
                    }
                }
            }
            
            // MARK: Continue button or waiting text
            if isHost {
                // TODO work on continuing to next question view
                // open this func's definition to do it
                HostToContinueButton()
            } else {
                Text("Menunggu pemain lain untuk selesai menjawab... 😋")
                    .font(Font.custom("Montserrat-Italic", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
            }
        }
        .modifier(FullScreen())
        .background(Image("backgroundhome2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .onAppear {
            self.answerService.observeIncomingAnswers {
                answerValue in
                
                DispatchQueue.main.async {
                    if let answer = answerValue {
                        self.answers.append(answer)
                    }

                    // re-sort answers by their timestamps
                    self.answers.sort {
                        $0.timestamp < $1.timestamp
                    }
                }
            }
        }
    }
}

struct FullScreen: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

struct AllAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AllAnswersView(isHost: true)
            AllAnswersView(isHost: false)
        }
    }
}

struct QuotedQuestionView: View {
    
    @State private var questionText = "Password Wi-Fi teraneh? Panjangin lagiiiiiiiiii........ TEROS Panjangin lagiiiiiiiiii........ Dipanjangin"
    var quotePaddingMultiplier: CGFloat {
        return questionText.isEmpty ? 1 : CGFloat(questionText.count / 20)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(",,")
                .font(Font.custom("Montserrat-BoldItalic", size: 48))
                .foregroundColor(.white)
                .rotationEffect(.init(degrees: 180))
                .alignmentGuide(.top, computeValue: { dimension in
                    dimension[VerticalAlignment.top]
                }).padding(.top, -12 * CGFloat(quotePaddingMultiplier))
            Text(self.questionText)
                .font(Font.custom("Montserrat-BoldItalic", size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text(",,")
                .font(Font.custom("Montserrat-BoldItalic", size: 48))
                .foregroundColor(.white)
                .padding(.bottom, -12 * CGFloat(quotePaddingMultiplier))
            
        }
    }
}

struct HostToContinueButton: View {
    var body: some View {
        Button(action: {
            // TODO work on this part to navigate to next question
            print("Move to next question... No DB access needed...")
        }) {
            Text("Lanjut")
                .font(Font.custom("Montserrat-Bold", size: 28))
                .foregroundColor(.yellow)
                .padding(.horizontal, 72)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(red: 0.19, green: 0.425, blue: 0.431)))
                .padding(.bottom, 24)
        }
    }
}
