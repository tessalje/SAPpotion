//
//  Challenge2ContainerView.swift
//  MapKitGeoGuesser
//
//  Created by Jia Chen Yee on 6/25/25.
//

import SwiftUI

struct Challenge2ContainerView<Content: View>: View {

    @Binding var state: GameState

    @Binding var supplementalDescription: String?

    @ViewBuilder
    var content: (() -> Content)

    @State private var isContentVisible = true
    @State private var isCircleShrunk = false
    @State private var isContentDespawned = false
    @Namespace var namespace

    @Environment(DataModel.self) private var dataModel

    var body: some View {
        if isContentVisible {
            ZStack(alignment: .topTrailing) {
                content()

                Button("Leave") {
                    withAnimation {
                        state = .failure
                        supplementalDescription = nil
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .mask {
                Circle()
                    .frame(width: isCircleShrunk ? 100 : 2000, height: isCircleShrunk ? 100 : 2000)
                    .matchedGeometryEffect(id: "circle", in: namespace)
            }
            .onChange(of: state) { oldValue, newValue in
                guard newValue != .playing else { return }
                withAnimation {
                    isCircleShrunk = true
                } completion: {
                    withAnimation(.bouncy) {
                        isContentVisible = false
                        dataModel.ciImage = nil
                    } completion: {
                        withAnimation(.spring(duration: 1, bounce: 0.1)) {
                            isContentDespawned = true
                        }
                    }
                }
            }
        } else {
            
            Spacer()
            
            Image(state == .success ? "potion" : "failed")
                .symbolRenderingMode(.multicolor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .matchedGeometryEffect(id: "circle", in: namespace)
            
            Text(state == .success ? "You did it!" : "Better luck next time!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let description = supplementalDescription {
                Text(description)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button("Try again") {
                    withAnimation {
                        dataModel.ciImage = nil
                        state = .playing
                        isContentVisible = true
                        isContentDespawned = false
                    } completion: {
                        supplementalDescription = nil
                        withAnimation {
                            isCircleShrunk = false
                        }
                    }
                }
                .disabled(!isContentDespawned)
                
                NavigationLink(destination: ContentView()) {
                    Text("Return to Lab")
                        .padding()
                        .background(Color("PinkColor"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .offset(y: isContentDespawned ? 0 : 100)
            .padding()
            
        }
    }
}

enum GameState {
    case playing
    case success
    case failure
}

