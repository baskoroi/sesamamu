//
//  newFile.swift
//  swiftUIPractice
//
//  Created by dwitama alfred on 22/07/20.
//  Copyright © 2020 Davia Belinda Hidayat. All rights reserved.
//

import SwiftUI

struct FinalStage1: View {
    @State var names = ["baskoro","markus","davia","christian","alfred","Wadidaw Boi", "Boombayah", "Aku Padamu", "Lee Tae Oh", "Lisa BlackPink","testing","haluuu","testtt lagi","Rose BlackPink","Jennie Wadaw","Testing","holaa","ini nomer 15 ya gaes","orang nomer 17","gelaa gelaa gelaa","hallo guys","lets test this", "how it works?"]
    
    var body: some View {
        VStack(alignment: .center){
            Text("atas")
                .frame(width: 100, height: UIScreen.main.bounds.size.height*0.3, alignment: .center)
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading){
            ForEach(self.names, id: \.self) { name in
                self.item(for: name)
                    .padding([.horizontal, .vertical],5)
                    .alignmentGuide(.leading, computeValue: { d in
                        if(abs(width - d.width) > g.size.width){
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if name == self.names.last!{
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if name == self.names.last!{
                            height = 0
                        }
                        return result
                    })
            }
            
        }
    }
    func item(for text: String) -> some View {
        Button(action: {
            print("buat camp tapped")
        }) {
            Text(text)
                .padding(.all, 8)
                .font(.body)
                .background(Color.blue)
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

