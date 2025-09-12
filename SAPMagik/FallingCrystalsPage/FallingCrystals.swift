//
//  ContentView.swift
//  FallingCrystalsGame
//
//  Created by Tessa Lee on 5/9/25.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var x: Double = 0.0
    @Published var y: Double = 0.0

    init() {
        motionManager.deviceMotionUpdateInterval = 0.02
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let motion = motion else { return }
            
            self?.x = motion.gravity.x
        }
    }
}


struct FallingCrystal: View {
    let randomy = Int.random(in: 1...100)
    @State var baskety:Int = 55
    @State var basketx:Int = 0
    
    @State var score: Int = 0
    
    @State var crystalLocation:Int = 0
    @State var basketLocation:Int = 0
    
    @State var collision: Bool = true
    
    @State var crystalPositions: [(x: Int, y: Int)] = [
        (x: 0, y: -480),
        (x: 0, y: -480),
        (x: 0, y: -480)
        ]
    
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
                print("Collision with crystal \(crystalIndex)!")
            }
        }
}

struct Crystals: View {
    var img: String
    var speed: Int
    @Binding var isGame: Bool
    
    @Binding var basketx: Int
    @Binding var baskety: Int
    @Binding var score: Int
    
    @State private var randomx = 0
    @State private var starting = -480
    @State private var rotate = 0
    
    var body: some View {
        Image(img)
            .resizable()
            .frame(width: 60, height: 70)
            .rotationEffect(.degrees(Double(rotate)))
            .offset(x: CGFloat(randomx), y: CGFloat(starting))
            .animation(isGame ? Animation
                .timingCurve(0.55, 0, 1, 0.45)
                .speed(0.1)
                .delay(Double.random(in: 0...2))
                .repeatForever(autoreverses: false) :
                    .default, value: starting)
            .animation(isGame ? Animation.easeInOut(duration: TimeInterval(speed)) : .default, value: randomx)
            .onAppear() {
                falling()
            }
    }
    
    private func falling() {
        guard isGame else { return }
        
        starting = -480
        randomx = Int.random(in: -350...350)
        rotate = 0
        
        withAnimation(.linear(duration: TimeInterval(speed))) {
            starting = 700
            rotate = 720
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(speed)/2) {
            if abs(basketx - randomx) < 50 && abs(baskety - starting) < 50 {
                score += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(speed) + Double.random(in: 0...1.5)) {
            if isGame { falling() }
        }
    }
}

#Preview {
    FallingCrystal()
}


