//
//  PlantView.swift
//  GrowingPlant
//
//  Created by Tessa Lee on 5/9/25.
//

import SwiftUI
import Combine
struct PlantView: View {
    
    @State var isClicked = false
    @State private var isVisible: Bool = true
    @State var isLeafClicked = false
    @State var isDisabled = false
    
    @State private var timeRemaining = 30
    @State private var timerActive = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if !isDisabled && isVisible && !isLeafClicked {
                VStack {
                    Button(action: {
                        isDisabled.toggle()
                        isClicked.toggle()
                        print("isDisabled: ", isDisabled)
                    }) {
                        Image("watercan")
                            .resizable()
                            .frame(width: 200,height: 200)
                            .padding(.leading, 150)
                            .rotationEffect(isClicked ? .degrees(0): .degrees(45))
                            .animation(.easeInOut(duration: 0.7), value: isClicked)
                            .onTapGesture {
                                isClicked.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    isVisible = false
                                }
                            }
                    }
                    .disabled(isDisabled)
                }
                    
            } else if isDisabled {
                Text("Time remaining: \(timeRemaining) sec")
                    .font(.headline)
                    .padding(.top, 8)
                
            } else {
                Text("")
            }
            
            HStack {
                if isLeafClicked {
                    VStack {
                        Text("You did it!")
                        Text("Please collect your leaves:")
                        Image("leaf")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .transition(.scale)
                            .animation(.easeInOut(duration: 0.5).delay(0.8), value: isLeafClicked)
                            .onTapGesture {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    isVisible = true
                                    isClicked = false
                                    isLeafClicked = false
                                    
                                    Countdown()
                                }
                            }
                    }
                } else {
                    ZStack {
                        if isClicked {
                            VStack {
                                Text("Your plant is ready. Pluck the leaves!")
                                
                                Image("big_plant")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)
                                    .scaleEffect(1.0)
                                    .offset(x:0, y:50)
                                    .onTapGesture {
                                        isClicked.toggle()
                                        isVisible.toggle()
                                        isLeafClicked.toggle()
                                    }
                            }
                        } else {
                            Image("small_plant")
                                .resizable() .scaledToFit() .frame(width: 220, height: 220) .scaleEffect(isClicked ? 0.1 : 0.8) .transition(.scale) .offset(x:0, y:-10)
                        }
                    }
                    .animation(.easeInOut(duration: 0.5).delay(0.8), value: isClicked)
                    .onReceive(timer) { _ in
                        guard timerActive else { return }
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            timerActive = false
                            isDisabled = false
                        }
                    }
                }
                
            }
        }
    }
    func Countdown() {
        timeRemaining = 30
        isDisabled = true
        timerActive = true
    }
}


#Preview {
    PlantView()
}
