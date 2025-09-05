//
//  FallingCrystals.swift
//  SAPMagik
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
            self?.y = motion.gravity.y
        }
    }
}

struct FallingCrystals: View {
    @StateObject private var motion = MotionManager()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .offset(x: motion.x * 150,  // left&right movement
                        y: -motion.y * 150) // forward&back movement
                .animation(.easeOut(duration: 0.1), value: motion.x)
                .animation(.easeOut(duration: 0.1), value: motion.y)
        }
    }
}

#Preview {
    FallingCrystals()
}
