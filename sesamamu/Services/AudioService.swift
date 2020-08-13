//
//  AudioService.swift
//  sesamamu
//
//  Created by Davia Belinda Hidayat on 13/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import AVFoundation

var audioPlayer: AVAudioPlayer!

func playSound(sound: String){
    if let path = Bundle.main.path(forResource: sound, ofType: nil){
        do{
            print("masuk nih tapi ga ke play")
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.play()
        } catch {
            print("ERROR: Coud not find and play the sound file")
        }
    }
}
