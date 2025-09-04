//
//  GameView.swift
//  CatchingAnimal
//
//  Created by Tessa Lee on 4/9/25.
//

import SwiftUI
import Combine
import Foundation

struct Animal: Identifiable {
    let id = UUID()
    var isVisible = false
    var isHit = false
    var scale: CGFloat = 0.1
}

class GameViewModel: ObservableObject {
    
    @Published var insects: [Animal]
    @Published var score = 0
    @Published var misses = 0
    @Published var gameWon = false
    
    private var timer: AnyCancellable?
    private var interval: TimeInterval = 2.0
    
    init(gridSize: Int) {
        insects = Array(repeating: Animal(), count: gridSize * gridSize)
        startGame()
    }
    
    func startGame() {
        misses = 0
        score = 0
        interval = 2.0
        
        for i in insects.indices {
            insects[i].isVisible = true
            insects[i].isHit = false
            insects[i].scale = 0.01
        }
        
        scheduleTimer()
    }
    
    func scheduleTimer() {
        timer?.cancel()
        timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.updateInsect()
        }
    }
    
    private func updateInsect() {
        for i in insects.indices {
            insects[i].isVisible = true
            insects[i].isHit = false
            insects[i].scale = 0.01
        }
        
        checkGameWon()
        
        let randomIndex = Int.random(in: 0..<insects.count)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            insects[randomIndex].isVisible = true
            insects[randomIndex].scale = 1.0
        }
        
        if misses % 2 == 0 {
            interval = max(0.5, interval - 0.1)
            scheduleTimer()
        }
        
        if score % 4 == 0 {
            interval = max(0.5, interval - 0.1)
            scheduleTimer()
        }
    }
    
    func hitInsect(at index: Int) {
        guard insects[index].isVisible else { return }
        
        insects[index].isHit = true
        insects[index].isVisible = false
        
        score += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.insects[index].isHit = false
        }
    }
    
    func checkGameWon() {
        if score == 10 {
            gameWon = true
            timer?.cancel()
        }
    }
}
