//
//  FinalStage-2.swift
//  sesamamu
//
//  Created by dwitama alfred on 29/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct FinalStage_2: View {
    
    @EnvironmentObject var globalStore: GlobalStore
    @State var animationAmount:Double = 0.0
    
    func calculateBondingMeter(answer: Array<Any> ) -> Int{
        let score:Int = 0
        
        for i in (0..<answer.count)
        {
            print(answer[i])
        }
        
        
        return score
    }
    
    var body: some View {
        
        ZStack{
            
            
            Color.black
                .opacity(self.animationAmount)
                .edgesIgnoringSafeArea(.all)
                .animation(Animation.easeIn(duration: 1))
                .onAppear{
                    self.animationAmount = 0.5
            }
            
            VStack(){
                Group{
                    Text("BondingMeter")
                        .font(.custom("Montserrat-bold", size: 30))
                        .foregroundColor(.white)
                    HStack{
                        Text("\(self.globalStore.bondingMeterScore)")
                            //                        Text("\(calculateBondingMeter(answer: globalStore.playerAnswerName))")
                            .font(.custom("Montserrat-bold", size: 125))
                            .shadow(color: Color(red: 0.91, green: 0.42, blue: 0.21, opacity: 1.00), radius: 0, x: 5, y: 5)
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                        Text("%")
                            .font(.custom("Montserrat-bold", size: 35))
                            .shadow(color: Color(red: 0.91, green: 0.42, blue: 0.21, opacity: 1.00), radius: 0, x: 2, y: 2)
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                    }
                    if self.globalStore.bondingMeterScore < 40 {
                        Text("Just Friend~")
                            .font(.custom("Montserrat-bold", size: 30))
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                    }else if self.globalStore.bondingMeterScore < 50 {
                        Text("We're Buddies")
                            .font(.custom("Montserrat-bold", size: 30))
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                    }else if self.globalStore.bondingMeterScore < 75 {
                        Text("BEST-FRIEND 4Life")
                            .font(.custom("Montserrat-bold", size: 30))
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                    } else if self.globalStore.bondingMeterScore < 91 {
                        Text("LET'S BE FAMILY")
                            .font(.custom("Montserrat-bold", size: 30))
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                    } else if self.globalStore.bondingMeterScore == 100 {
                        Text("PERFECT FAMILY")
                            .font(.custom("Montserrat-bold", size: 30))
                            .foregroundColor(Color(red: 1.00, green: 0.87, blue: 0.35, opacity: 1.00))
                    }
                    
                    
                }
                //                .offset(y:+(UIScreen.main.bounds.size.height*0.2))
                
                Spacer()
                
                VStack{
                    Button(action: {
                        //                        print(self.globalStore.correctPairs)
                    }) {
                        
                        Image("mainLagi-button")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 310, alignment: .center)
                    }
                    
                    NavigationLink(destination: HomeView()){
                        
                        Image("ulangi-button")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 310, alignment: .center)
                    }
                    
                    HStack{
                        NavigationLink(destination: HomeView()){
                            
                            Image("bagikanButton")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, alignment: .center)
                        }
                        NavigationLink(destination: HomeView()){
                            
                            Image("rating-button")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, alignment: .center)
                        }
                    }
                    
                }.offset(y:-(UIScreen.main.bounds.size.height*0.15))
            }
            
            
        }
    }
    
}

struct FinalStage_2_Previews: PreviewProvider {
    static var previews: some View {
        FinalStage_2()
    }
}
