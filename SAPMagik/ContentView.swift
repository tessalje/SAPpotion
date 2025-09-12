//
//  ContentView.swift
//  google game
//
//  Created by .. on 16/8/25.
//

import SwiftUI

class GameData: ObservableObject {
    @Published var potionmade = false
    @Published var animalscaught = false
    @Published var plantwatered = false
    @Published var crystalscollected = false
    @Published var score = 0
    
    
    func checkConditions() {
        if potionmade &&  animalscaught && crystalscollected && plantwatered {
            score += 1
            potionmade = false
            animalscaught = false
            crystalscollected = false
            plantwatered = false
        }
    }
}

struct ContentView: View {
    @State var rotation3 = 0.0
    @State private var wateringcanclicked = 0
    @StateObject var gamedata = GameData()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("homescreen_background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    NavigationLink(destination: BookView()){
                        Image("books")
                            .resizable()
                            .scaledToFit()
                            .font(.title)
                            .frame(width: 200, height: 130)
                        
                        
                    }
                    .offset(x:-300, y:-15)
                    
                    Text("Potions: 0")
                        .bold()
                        .foregroundStyle(.white)
                        .offset(x: -290, y:-45)
                    
                    Image("potion_count")
                        .resizable()
                        .frame(width:80, height:80)
                        .offset(x: -290, y:-50)
                }
                
                
                HStack {
                    NavigationLink(destination: ColorMatching()) {
                        Image("potion")
                            .resizable()
                            .frame(width:70, height: 130)
                    }
                    .offset(x: -100, y: 100)
                    
                    NavigationLink(destination: CatchingAnimalView()) {
                        Image("animal")
                            .resizable()
                            .frame(width:70, height: 80)
                    }
                    .offset(x: 30, y: 30)
                    
                    NavigationLink(destination: FallingCrystal()) {
                        Image("rainbow_crystal")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .offset(x: -100, y: 120)
                    
                    
                    NavigationLink(destination: CauldronView()) {
                        Image("cauldron")
                            .resizable()
                            .frame(width:180,height:200)
                    }
                    .offset(x: -40, y: 70)
                    .onAppear {
                        gamedata.checkConditions()
                    }
                    
                    NavigationLink(destination: PlantView()) {
                        Image("teenplant")
                            .resizable()
                            .frame(width: 130, height: 180)
                    }
                    .offset(x: 40, y: 80)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ContentView()
}
