//
//  CatchingAnimalView.swift
//  CatchingAnimal
//
//  Created by Tessa Lee on 2/9/25.
//

import SwiftUI
struct CatchingAnimalView: View {
    
    @StateObject private var viewModel = GameViewModel(gridSize: 3)
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var isContentVisible = true
    @State private var isCircleShrunk = false
    @State private var isContentDespawned = false
    @Namespace var namespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isContentVisible {
                    ZStack {
                        Image("forest")
                            .resizable()
                            .ignoresSafeArea()
                        
                        VStack {
                            Text("SCORE:\(viewModel.score)")
                                .font(.system(.title, design: .monospaced))
                                .padding(10)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(40)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.insects.indices, id: \.self) { index in
                                    ZStack {
                                        if viewModel.insects[index].isHit {
                                            Image("animalhit")
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                        } else if viewModel.insects[index].isVisible {
                                            Image("animal")
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .scaleEffect(viewModel.insects[index].scale)
                                                .onTapGesture {
                                                    viewModel.hitInsect(at: index)
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .mask {
                        Circle()
                            .frame(width: isCircleShrunk ? 100 : 2000, height: isCircleShrunk ? 100 : 2000)
                            .matchedGeometryEffect(id: "circle", in: namespace)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: HomeView()) {
                                HStack {
                                    Image(systemName: "arrowshape.turn.up.backward.fill")
                                    Text("Leave")
                                        .bold()
                                }
                                .font(.title2)
                                .foregroundStyle(.white)
                            }
                        }
                    }
                    
                } else {
                    VStack {
                        Spacer()
                        
                        Image("animalhit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .matchedGeometryEffect(id: "circle", in: namespace)
                        
                        Text("You did it!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("You caught 10 animals!")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        VStack {
                            NavigationLink(destination: HomeView()) {
                                Text("Return to workshop")
                                    .padding(8)
                                    .buttonStyle(.borderedProminent)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .disabled(!isContentDespawned)
                        }
                        .offset(y: isContentDespawned ? 0 : 100)
                        .padding()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.startGame()
        }
        .onChange(of: viewModel.gameWon) { oldValue, newValue in
            guard newValue == true else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                isCircleShrunk = true
            } completion: {
                withAnimation(.bouncy) {
                    isContentVisible = false
                } completion: {
                    withAnimation(.spring(duration: 1, bounce: 0.1)) {
                        isContentDespawned = true
                    }
                }
            }
        }
    }
}

#Preview {
    CatchingAnimalView()
}
