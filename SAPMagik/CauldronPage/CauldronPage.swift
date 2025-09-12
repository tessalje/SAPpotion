//
//  CauldronPage.swift
//  google game
//
//  Created by .. on 16/8/25.
//

import SwiftUI

struct CauldronView: View {
    @State var rotation = 0.0
    @State var rotation2 = 0.0
    @State var rotation4 = 0.0
    @State private var potionpoured = false
    @State private var animalpoured = false
    @State private var leavespoured = false
    @State private var isDisabled = false
    
    var allPressed: Bool {
        potionpoured && animalpoured && leavespoured
    }
   
    var body: some View {
        NavigationStack {
            ZStack{
                Image("cauldron_background_default")
                    .resizable()
                    .ignoresSafeArea(edges: .all)
                VStack {
                    Text("Pour in the ingredients!")
                        .font(.title)
                        .foregroundStyle(.white)
                    
                    HStack{
                        Button {
                            potionpoured.toggle()
                            withAnimation {
                                if rotation != 0 {
                                    rotation = 0
                                } else {
                                    rotation = 45
                                }
                            }
                            
                        }label:{
                            Image("potion")
                                .frame(width: 200, height: 50)
                                .rotationEffect(.degrees(rotation))
                        }
                        .position(x:130, y:100)
                        .disabled(allPressed)
                        
                        Button {
                            animalpoured.toggle()
                            withAnimation {
                                if rotation2 != 0 {
                                    rotation2 = 0
                                } else {
                                    rotation2 = 45
                                }
                                
                            }
                        }label:{
                            Image("animalhit")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(rotation2))
                        }
                        .position(x:100, y:100)
                        .disabled(allPressed)
                        
                        
                        Button {
                            leavespoured.toggle()
                            withAnimation {
                                if rotation4 != 0 {
                                    rotation4 = 0
                                } else {
                                    rotation4 = -45
                                }
                                
                            }
                        }label:{
                            Image("teenplant")
                                .resizable()
                                .frame(width: 150, height: 190)
                                .rotationEffect(.degrees(rotation4))
                        }
                        .position(x:90, y: 90)
                        .disabled(allPressed)
                    }
                }
                Ellipse()
                    .fill(allPressed ? Color.purple: Color.blue)
                    .frame(width:620, height: 150)
                    .position(x:443,y:295)
                    .animation(.default, value: allPressed)
                
                NavigationLink(destination: ContentView()) {
                    Text("Done")
                        .font(.title)
                        .padding(10)
                        .background(allPressed ? Color("PinkColor"): Color.gray)
                        .cornerRadius(10)
                        .contentShape(Rectangle())
                }
                .position(x: 770, y: 350)
                .disabled(!allPressed)
            }
            .ignoresSafeArea()
        }
    }
}




#Preview {
    CauldronView()
}

