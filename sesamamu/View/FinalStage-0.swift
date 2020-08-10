//
//  FinalStage-0.swift
//  sesamamu
//
//  Created by dwitama alfred on 29/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct FinalStage_0: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .center){                
                VStack(alignment: .center, spacing: 0){
                    VStack{
                        
                        Text("Gimana?")
                            .font(.custom("Montserrat-bold", size: 25))
                            .foregroundColor(.white)
                        Group{
                            Text("Apakah kalian sudah saling kenal?")
                                .font(.custom("Montserrat-italic", size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            Text("Bisakah kalian menebak identitas")
                                .font(.custom("Montserrat-italic", size: 18))
                                .foregroundColor(.white)
                            Text("asli dari pemain?")
                                .font(.custom("Montserrat-italic", size: 18))
                                .foregroundColor(.white)
                            Text("Seberapa sohib kalian?")
                                .font(.custom("Montserrat-italic", size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            Text("Buktikan sekarang~")
                                .font(.custom("Montserrat-italic", size: 18))
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*0.5, alignment: .center)
                    
                    Spacer()
                    
//                    VStack{
//                        NavigationLink(destination: FinalStage1()){
//                            Image("tebakPemain-button")
//                                .renderingMode(.original)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 250, alignment: .center)
//                        }
//                        NavigationLink(destination: HomeView()){
//
//                            Image("mainLagi-button")
//                                .renderingMode(.original)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 250, alignment: .center)
//                                .navigationBarBackButtonHidden(true)
//                        }
//                    }.offset(y:-(UIScreen.main.bounds.size.height*0.2))
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
}


struct FinalStage_0_Previews: PreviewProvider {
    static var previews: some View {
        FinalStage_0()
    }
}
