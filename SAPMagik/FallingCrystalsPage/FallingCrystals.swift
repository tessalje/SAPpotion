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
    
    @State var crystalLocation:Int = 0
    @State var basketLocation:Int = 0
    
    @State var collision: Bool = true
    
    @State var crystalPositions: [(x: Int, y: Int)] = [
        (x: 0, y: -480),
        (x: 0, y: -480),
        (x: 0, y: -480)
        ]
    
    @StateObject private var motion = MotionManager()
    
    var body: some View {
        ZStack {
            Image("crystal_bg")
                .resizable()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Crystals(img: "blue_crystal", speed: 9)
                    Crystals(img: "green_crystal", speed: 10)
                    Crystals(img: "purple_crystal", speed: 8)
                    Crystals(img: "yellow_crystal", speed: 9)
                    Crystals(img: "pink_crystal", speed: 10)
                    Crystals(img: "rainbow_crystal", speed: 7)
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
                        .offset(x: Double(basketx) + motion.x * 150, y: Double(baskety) + motion.y * 150)
                        .animation(.easeOut(duration: 0.1), value: motion.x)
                        .animation(.easeOut(duration: 0.1), value: motion.y)
                    
                    Button(">") {
                        basketx += 20
                    }
                    .font(.largeTitle)
                    .buttonStyle(.borderedProminent)
                    .offset(x: 250, y: 120)
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
    @State private var randomx = 0
    @State private var starting = -480
    @State private var rotate = 0
    
    var body: some View {
        Image(img)
            .resizable()
            .frame(width: 60, height: 70)
            .rotationEffect(.degrees(Double(rotate)))
            .offset(x: CGFloat(randomx), y: CGFloat(starting))
            .animation(Animation.timingCurve(0.55, 0, 1, 0.45).speed(0.1).delay(Double.random(in: 0...2)).repeatForever(autoreverses: false), value: starting)
            .animation(Animation.easeInOut(duration: TimeInterval(speed)), value: randomx)
            .onAppear() {
                starting = 700
                rotate = 500
                randomx = Int.random(in: -750...750)
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    randomx = Int.random(in: -350...350)
                }
            }
    }
}

#Preview {
    FallingCrystal()
}


