//
//  StartView.swift
//  SAPMagik
//
//  Created by Tessa Lee on 12/9/25.
//

import SwiftUI

struct StartView: View {
    @AppStorage("currentView") var currentView = 1
    var body: some View {
        NavigationStack {
            ZStack {
                Image("start_bg")
                    .resizable()
                    .ignoresSafeArea()
                
                HStack {
                    NavigationLink(destination: ContentView()) {
                        Text("START")
                            .foregroundStyle(.black)
                            .bold()
                            .padding(20)
                            .background(Color("PinkColor"))
                            .cornerRadius(15)
                    }
                    .offset(y: 130)
                    Button(action: {
                        currentView = 1
                    }) {
                        Text("TUTORIAL")
                            .foregroundStyle(.black)
                            .bold()
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    .offset(y: 130)
                }
            }
        }
    }
}

#Preview {
    StartView()
}
