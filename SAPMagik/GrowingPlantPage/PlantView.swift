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
            Button("Reset plant") {
                isVisible = true
                isClicked = false
            }
            
            if isVisible {
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
            .animation(.easeInOut(duration: 0.5).delay(0.8), value: isClicked)
        }
    }
}

#Preview {
    PlantView()
}
