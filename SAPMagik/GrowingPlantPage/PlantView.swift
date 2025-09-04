//
//  PlantView.swift
//  GrowingPlant
//
//  Created by Tessa Lee on 5/9/25.
//

import SwiftUI
struct PlantView: View {
    @State var isClicked = false
    @State private var isVisible: Bool = true
    var body: some View {
        VStack {
            Button("Reset") {
                isVisible = true
                isClicked = false
            }
            
            if isVisible {
                Image("watercan")
                    .resizable()
                    .frame(width: 200,height: 200)
                    .padding(.leading, 150)
                    .rotationEffect(.degrees(45))
                    .onTapGesture {
                        isClicked.toggle()
                        isVisible = false
                    }
            } else {
                Text("")
            }
            
            ZStack {
                if isClicked {
                    Image("big_plant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .scaleEffect(1.0)
                        .offset(x:0, y:50) //u can change this
                } else {
                    Image("small_plant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .scaleEffect(isClicked ? 0.1 : 0.8)
                        .transition(.scale)
                        .offset(x:0, y:-10) //u can change this
                }
            }
            .animation(.easeInOut(duration: 0.6), value: isClicked)
        }
    }
}

#Preview {
    PlantView()
}
