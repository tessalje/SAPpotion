//
//  CrystalGameView.swift
//  SAPMagik
//
//  Created by Tessa Lee on 13/9/25.
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
        
        if abs(basketx - randomx) < 50 && abs(baskety - starting) < 50 {
            score += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(speed) + Double.random(in: 0...1.5)) {
            if isGame {
                falling()
            }
        }
    }
}
