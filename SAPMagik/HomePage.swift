//
//  HomePage.swift
//  PotionBook
//
//  Created by Tessa Lee on 4/9/25.
//
import SwiftUI

struct HomeView: View {
    @AppStorage("currentView") var currentView = 1
    var body: some View {
        NavigationStack {
            VStack {
                Text("home page")
                NavigationLink(destination: PotionBookView()) {
                    Text("Potion receipe book")
                }
                
                NavigationLink(destination: CatchingAnimalView()) {
                    Text("Animal catching game")
                }
                
//                NavigationLink(destination: ColorMatching()) {
//                    Text("Color matching game")
//                }
                
                NavigationLink(destination: PlantView()) {
                    Text("Grow your plant")
                }
                
                NavigationLink(destination: FallingCrystals()) {
                    Text("Falling crystals game")
                }
                
                //remove later
                Button("Reset onboarding") {
                    withAnimation {
                        currentView = 1
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
            
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    HomeView()
}
