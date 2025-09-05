//
//  GameView.swift
//  PhotosAndCameraColorGame
//
//  Created by Tristan Chay on 27/6/25.
//

import SwiftUI

struct GameView: View {

    @Binding var gameState: GameState
    @Binding var supplementalDescription: String?

    @State private var targetColor = Color.random

    @State private var adjustedImage: UIImage?
    @State private var currentAccuracy: Double = 0.0
    @State private var averageColor: Color = .clear

    @State private var hue: Double = 0
    @State private var saturation: Double = 1
    @State private var brightness: Double = 0
    @State private var contrast: Double = 1

    @State private var timing = 120
    @State private var countdownActive = true

    @Environment(DataModel.self) private var dataModel

    var body: some View {
        ZStack {
            if let image = dataModel.swiftUIImage {
                image
                    .resizable()
                    .scaledToFill()
//                    .hueRotation(.degrees(hue))
//                    .saturation(saturation)
//                    .brightness(brightness)
//                    .contrast(contrast)
//                    .overlay(Color.black.opacity(0.3))
            } else {
                ProgressView()
                    .controlSize(.extraLarge)
            }

            VStack {
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("POTION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        ZStack {
                            Image("target")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                        
                            Circle()
                                .trim(from: 0, to: 0.7)
                                .fill(targetColor)
                                .rotationEffect(.degrees(-34))
                                .frame(width: 110)
                                .offset(x:0, y:22)
                            
                        }
                    }

                    Spacer()

                    VStack(spacing: 5) {
                        Text("\(Int(currentAccuracy * 100))%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .contentTransition(.numericText(value: currentAccuracy))

                        Text("MATCH")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        ProgressView(value: currentAccuracy)
                            .progressViewStyle(.linear)
                            .tint(accuracyColor)
                            .scaleEffect(x: 1, y: 3, anchor: .center)
                            .frame(width: 100)
                    }

                    Spacer()

                    VStack(spacing: 8) {
                        Text("CURRENT")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        ZStack {
                            ZStack {
                                Image("current")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .shadow(radius: 10)
                            
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(averageColor)
                                    .frame(width: 90, height: 72)
                                    .offset(x:0, y:30)
                                
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)

                Spacer()
            }
        }
        .onAppear {
            updateAverageColor()
        }
        .onChange(of: dataModel.ciImage) {
            updateAverageColor()
        }
    }

    private var accuracyColor: Color {
        if currentAccuracy >= 0.8 {
            return .green
        } else if currentAccuracy >= 0.6 {
            return .yellow
        } else {
            return .red
        }
    }

    private func updateAverageColor() {
        guard let ciImage = dataModel.ciImage else { return }
        if let avgColor = ciImage.averageColor {
            averageColor = Color(avgColor)
            let accuracy = calculateColorAccuracy(target: targetColor, current: Color(avgColor))

            withAnimation {
                currentAccuracy = accuracy
            }

            if accuracy >= 0.85 && gameState != .success {
                withAnimation {
                    gameState = .success
                    supplementalDescription = "Your potion ingredient is ready!"
                }
            }
        }
    }

    private func calculateColorAccuracy(target: Color, current: Color) -> Double {
        let targetUIColor = UIColor(target)
        let currentUIColor = UIColor(current)

        var targetR: CGFloat = 0, targetG: CGFloat = 0, targetB: CGFloat = 0
        var currentR: CGFloat = 0, currentG: CGFloat = 0, currentB: CGFloat = 0

        targetUIColor.getRed(&targetR, green: &targetG, blue: &targetB, alpha: nil)
        currentUIColor.getRed(&currentR, green: &currentG, blue: &currentB, alpha: nil)

        let rDiff = abs(targetR - currentR) * 0.299
        let gDiff = abs(targetG - currentG) * 0.587
        let bDiff = abs(targetB - currentB) * 0.114

        let totalDiff = rDiff + gDiff + bDiff
        return Double(max(0.0, 1.0 - totalDiff))
    }
}
