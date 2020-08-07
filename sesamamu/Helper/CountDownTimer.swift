//
//  CountDownTimer.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 07/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

struct ProgressTrack: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 30, height: 30)
            .overlay(
                Circle().stroke(Color.black, lineWidth: 10)
        )
    }
}

struct ProgressBar: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .trim(from:0, to: progress())
                    .stroke(style: StrokeStyle(lineWidth: 10,lineCap: .round, lineJoin:.round))
                    .foregroundColor(
                        (completed() ? Color.red : Color.orange))
                    .animation(.easeOut(duration: 1))
        )
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
}
