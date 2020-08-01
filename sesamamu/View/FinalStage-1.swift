//
//  newFile.swift
//  swiftUIPractice
//
//  Created by dwitama alfred on 22/07/20.
//  Copyright © 2020 Davia Belinda Hidayat. All rights reserved.
//
import SwiftUI

struct FinalStage1: View {
    
    struct playerAnswerStruct{
        var name : String
        var correctAnswer : String
        var choosenPair : String = ""
        var status : Bool = false
        var number : Int = 0
    }
    @State var choosenNumber = 0
    @State var totalPair: Int = 0
    @State var firstChoice: String = ""
    @State var animationAmount:Double = 0.0
    @State var tapCount: Int = 0
    @State var playerAnswers = []
    @State var phoneHeight:CGFloat = UIScreen.main.bounds.size.height
    @State var phoneWidth:CGFloat = UIScreen.main.bounds.size.width
    @EnvironmentObject var globalStore: GlobalStore
    
    
    @State var colorDictionary = [
        0 : Color(red: 0.00, green: 0.00, blue: 0.00, opacity: 0.20),
        1 : Color(red: 0.89, green: 0.13, blue: 0.17, opacity: 1.00),
        2 : Color(red: 0.61, green: 0.18, blue: 0.68, opacity: 1.00),
        3 : Color(red: 0.12, green: 0.74, blue: 0.82, opacity: 1.00),
        4 : Color(red: 0.97, green: 0.67, blue: 0.60, opacity: 1.00),
        5 : Color(red: 0.61, green: 0.79, blue: 0.23, opacity: 1.00),
        6 : Color(red: 0.95, green: 0.33, blue: 0.37, opacity: 1.00),
        7 : Color(red: 0.11, green: 0.47, blue: 0.75, opacity: 1.00),
        8 : Color(red: 0.97, green: 0.55, blue: 0.13, opacity: 1.00),
        9 : Color(red: 0.50, green: 0.22, blue: 0.37, opacity: 1.00),
        10 : Color(red: 0.08, green: 0.50, blue: 0.52, opacity: 1.00),
        11 : Color(red: 0.37, green: 0.57, blue: 0.38, opacity: 1.00),
        12 : Color(red: 0.01, green: 0.60, blue: 0.59, opacity: 1.00),
        13 : Color(red: 0.66, green: 0.31, blue: 0.22, opacity: 1.00),
        14 : Color(red: 0.74, green: 0.73, blue: 0.84, opacity: 1.00),
        15 : Color(red: 0.69, green: 0.74, blue: 0.45, opacity: 1.00),
    ]
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            ZStack(alignment: .center){
                
                
                VStack(alignment: .center) {
                    
                    if self.globalStore.inGamePlayer.count < 10{
                        self.generateContent(in: geometry)
                            .padding(.init(top: self.phoneHeight*0.4, leading: 0, bottom: 0, trailing: 0))
                    } else if self.globalStore.inGamePlayer.count < 20 {
                        self.generateContent(in: geometry)
                            .padding(.init(top: self.phoneHeight*0.3, leading: 0, bottom: 0, trailing: 0))
                    }else if self.globalStore.inGamePlayer.count < 25 {
                        self.generateContent(in: geometry)
                            .padding(.init(top: self.phoneHeight*0.2, leading: 0, bottom: 0, trailing: 0))
                    }else{
                        self.generateContent(in: geometry)
                            .padding(.init(top: self.phoneHeight*0.15, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    Spacer()
                }
                
            }
            
        }
    }
    
    
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading){
            
            ForEach(self.globalStore.inGamePlayer.indices, id: \.self) { index in
                self.item(for: self.globalStore.inGamePlayer[index].name, index: index, status:self.globalStore.inGamePlayer[index].status, number: self.globalStore.playerAnswerName.count)
                    .padding([.horizontal, .vertical],5)
                    .alignmentGuide(.leading, computeValue: { d in
                        if(abs(width - d.width) > g.size.width){
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if self.globalStore.inGamePlayer[index].name == self.globalStore.inGamePlayer.last!.name{
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if self.globalStore.inGamePlayer[index].name == self.globalStore.inGamePlayer.last!.name{
                            height = 0
                        }
                        return result
                    })
            }
            
        }
    }
    func item(for text: String, index: Int, status:Bool, number:Int) -> some View {
        
        Button(action: {
            if !status {
                self.tapCount += 1
                self.globalStore.inGamePlayer[index].status = !self.globalStore.inGamePlayer[index].status
                
                if self.tapCount == 2 {
                    self.totalPair += 1
                    for i in 0..<self.globalStore.inGamePlayer.count {
                        if self.globalStore.inGamePlayer[i].status && self.globalStore.inGamePlayer[i].number == 0 {
                            self.globalStore.inGamePlayer[i].number = self.totalPair
                        }
                    }
                    self.tapCount = 0
                }
                
            print("tapcount = \(self.tapCount)")
              print(self.globalStore.inGamePlayer)
                
            }else{
                if self.tapCount < 1 {
                    self.tapCount = 0
                    if self.totalPair > 0 {
                        changeNumber(data: &self.globalStore.inGamePlayer, number: self.globalStore.inGamePlayer[index].number)
                        self.totalPair -= 1
                    }
                    print(self.tapCount)
                    print(self.totalPair)
                }else{
                    print("show alert here")
                }
            }
        }) {
            
            Text(text)
                .padding(.all, 7)
                .font(.system(size: 16, weight: .regular, design: .default))
                .background(status ? colorDictionary[self.globalStore.inGamePlayer[index].number] : Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(10)
        }
    }
}

struct FinalStage1_Previews: PreviewProvider {
    static var previews: some View {
        FinalStage1()
    }
}

func changeNumber( data:inout [playerAnswer], number:Int) {
    print("number = \(number)")
    for i in 0..<data.count {
        if data[i].status && data[i].number == number {
            data[i].status = false
            data[i].number = 0
            
        }else if data[i].status && data[i].number >= number{
            
//            data[i].status = false
            data[i].number -= 1
        }
    }
    print(data)
//    print("number = \(number)")
    
}
