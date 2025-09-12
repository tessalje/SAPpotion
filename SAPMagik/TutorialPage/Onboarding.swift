//
//  OnboardingView.swift
//  Onboarding
//
//  Created by Tessa Lee on 4/9/25.
//

import SwiftUI

var totalViews = 6

struct OnboardingView: View {
    @AppStorage("currentView") var currentView = 1
    
    var body: some View {
        
        if currentView == 1 {
            WalkthroughScreen(
                title: "Welcome to Magik!",
                description: "Your potion making journey starts here...",
                bgColor: "PinkColor",
                img: "welcome"
            )
            .transition(.opacity)
        } else if currentView == 2 {
            WalkthroughScreen(
                title: "Potion ingredients",
                description: "Start by collecting 3 main ingredients",
                bgColor: "BlueColor",
                img: "intro_1"
            )
        } else if currentView == 3 {
            WalkthroughScreen(
                title: "Grow a plant",
                description: "You need to nuture and grow a plant too",
                bgColor: "GreenColor",
                img: "intro_2"
            )
        } else if currentView == 4 {
            WalkthroughScreen(
                title: "Catching insects",
                description: "Every potion needs some insect parts",
                bgColor: "YellowColor",
                img: "intro_3"
            )
        } else if currentView == 5 {
            WalkthroughScreen(
                title: "Into the cauldron!",
                description: "After collecting everything, mix them to get your potion",
                bgColor: "PurpleColor",
                img: "intro_4"
            )
        } else if currentView == 6 {
            Image("rotate")
                .resizable()
                .scaledToFill()
                .rotationEffect(.degrees(-90))
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Button(
                                action:{
                                    withAnimation(.easeOut) {
                                        currentView += 1
                                        
                                    }
                                },
                                label: {
                                    Image(systemName: "arrowshape.right.circle.fill")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 35.0, weight: .semibold))
                                        .frame(width: 55, height: 55)
                                }
                            )
                        }
                    }
                )
        }
        if currentView == 7 {
            StartView()
        }
    }
}
    
struct WalkthroughScreen: View {
    
    @AppStorage("currentView") var currentView = 1
    
    var title: String
    var description: String
    var bgColor: String
    var img: String
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack{
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Image(img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        Text(title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .font(.title)
                            .padding(.top)
                        
                        Text(description)
                            .padding(.top, 5.0)
                            .foregroundColor(Color.white)
                        
                        Spacer(minLength: 0)
                        
                    }
                    .padding()
                    .overlay(
                        HStack{
                            ForEach(1...5, id: \.self) { i in
                                ContainerRelativeShape()
                                    .foregroundColor(currentView == i ? .white : .white.opacity(0.5))
                                    .frame(width: 25, height: 5)
                            }
                            
                            Spacer()
                            
                            Button(
                                action:{
                                    withAnimation(.easeOut) {
                                        if currentView <= totalViews || currentView == 2 {
                                            currentView += 1
                                        } else if currentView == 3 {
                                            currentView = 1
                                        }
                                    }
                                },
                                label: {
                                    Image(systemName: "arrowshape.right.circle.fill")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 35.0, weight: .semibold))
                                        .frame(width: 55, height: 55)
                                }
                            )
                        }
                            .padding()
                        ,alignment: .bottomTrailing
                    )
                }
            }
            .background(LinearGradient(colors: [Color(bgColor),Color("backgroundColor")],startPoint: .top, endPoint: .bottom))
            .toolbar {
                Button(action:{
                    currentView = 7
                }, label: {
                    Text("Skip")
                        .font(.title2)
                })
            }
        }
    }
}


#Preview {
    OnboardingView()
}
