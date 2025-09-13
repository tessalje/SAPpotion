//
//  ContentView.swift
//  FallingCrystalsGame
//
//  Created by Tessa Lee on 5/9/25.
//

import SwiftUI
import CoreMotion

struct FallingCrystal: View {
    let randomy = Int.random(in: 1...100)
    @State var baskety:Int = 55
    @State var basketx:Int = 0
    
    @State var score: Int = 0
    
    @State var crystalLocation:Int = 0
    @State var basketLocation:Int = 0
    
    @State var collision: Bool = true
    
    @State var crystalPositions: [(x: Int, y: Int)] = [(x: 0, y: -480),(x: 0, y: -480),(x: 0, y: -480)]
    
    @StateObject private var motion = MotionManager()
    @State var isGame = true
    
    var body: some View {
        ZStack {
            Image("crystal_bg")
                .resizable()
                .ignoresSafeArea()
            if score < 10 {
                VStack {
                    Text("SCORE:\(score)")
                        .font(.system(.title, design: .monospaced))
                        .padding(10)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(40)
                    
                    HStack {
                        Crystals(img: "blue_crystal", speed: 9, isGame: $isGame, basketx: $basketx, baskety: $baskety, score: $score)
                        Crystals(img: "green_crystal", speed: 10, isGame: $isGame, basketx: $basketx, baskety: $baskety, score: $score)
                        Crystals(img: "purple_crystal", speed: 8, isGame: $isGame, basketx: $basketx, baskety: $baskety, score: $score)
                        Crystals(img: "yellow_crystal", speed: 9, isGame: $isGame, basketx: $basketx, baskety: $baskety, score: $score)
                        Crystals(img: "pink_crystal", speed: 10, isGame: $isGame, basketx: $basketx, baskety: $baskety, score: $score)
                        Crystals(img: "rainbow_crystal", speed: 7, isGame: $isGame, basketx: $basketx, baskety: $baskety, score: $score)
                    }
                    
                    HStack {
                        Button("<") {
                            basketx -= 20
                        }
                        .font(.largeTitle)
                        .buttonStyle(.borderedProminent)
                        .offset(x: -250, y: 120)
                        
                        Image("basket")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .offset(x: CGFloat(basketx), y:CGFloat(baskety))
                            .offset(x: Double(basketx) + motion.x * 100, y: Double(baskety) + motion.y * 100)
                            .animation(.easeOut(duration: 0.05), value: motion.x)
                            .animation(.easeOut(duration: 0.05), value: motion.y)
                        
                        Button(">") {
                            basketx += 20
                        }
                        .font(.largeTitle)
                        .buttonStyle(.borderedProminent)
                        .offset(x: 250, y: 120)
                    }
                    Spacer()
                }
            } else {
                VStack {
                    Spacer()
                    Image("rainbow_crystal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                    Text("You did it!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("You collected 10 crystals!")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Return to Lab")
                            .padding(8)
                            .foregroundStyle(.black)
                            .background(Color("PinkColor"))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    func checkCollision(crystalIndex: Int) {
        let crystal = crystalPositions[crystalIndex]
        if abs(basketx - crystal.x) < 100 && abs(baskety - crystal.y) < 100 {
            print("Collected")
        }
    }
}

#Preview {
    FallingCrystal()
}


