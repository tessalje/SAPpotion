//
//  PotionBookView.swift
//  PotionBook
//
//  Created by Tessa Lee on 4/9/25.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let color: Color
    let text: String
    let image: String
}

struct PotionBookView: View {
    var body: some View {
        CardStackView()
    }
}


struct CardStackView: View {
    @State private var cards: [Card] = []
    private let allCards: [Card] = [
        Card(color: .red, text: "Love potion", image: "red_potion"),
        Card(color: .orange, text: "Beauty potion", image: "pink_potion"),
        Card(color: .yellow, text: "Speed potion", image: "yellow_potion"),
        Card(color: .green, text: "Plant potion", image: "green_potion"),
        Card(color: .blue, text: "Water potion", image: "blue_potion"),
        Card(color: .purple, text: "Flying potion", image: "purple_potion")
    ]

    init() {
        _cards = State(initialValue: allCards)
    }

    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Image("background_book")
                        .resizable()
                        .ignoresSafeArea()
                    VStack {
                        ZStack {
                            ForEach(cards.reversed()) { card in
                                CardView(card: card, onRemove: { removedCard in
                                    self.cards.removeAll { $0.id == removedCard.id }
                                })
                                .stacked(at: self.index(of: card), in: self.cards.count)
                                .disabled(!isTopCard(card))
                            }
                        }
                        
                        HStack {
                            Button {
                                let newCard = Card(color: .gray,
                                                   text: "New Potion",
                                                   image: "default")
                                withAnimation {
                                    cards.insert(newCard, at: 0)
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button{
                                withAnimation {
                                    cards = allCards
                                }
                            } label: {
                                Image(systemName: "repeat")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.bottom, 30)
                    }
                }
                .navigationBarBackButtonHidden()
                .toolbar {
                    NavigationLink(destination: HomeView()) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                            
                            Text("Return")
                        }
                        .foregroundStyle(.white)
                        .font(.title2)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }

    private func index(of card: Card) -> Int {
        return cards.firstIndex(where: { $0.id == card.id }) ?? 0
    }

    private func isTopCard(_ card: Card) -> Bool {
        return cards.first?.id == card.id
    }
}


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(position) * -10
        return self.offset(CGSize(width: offset, height: offset))
    }
}

struct CardView: View {
    let card: Card
    let onRemove: (Card) -> Void

    @State private var offset = CGSize.zero

    var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width * 0.5
            let cardHeight = geo.size.height * 0.7
            
            RoundedRectangle(cornerRadius: 10)
                .fill(card.color)
                .frame(width: cardWidth, height: cardHeight)
                .overlay(
                    VStack {
                        Image(card.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: cardHeight * 0.4)
                        
                        Text(card.text)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                )
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                .offset(x: offset.width, y: offset.height)
                .rotationEffect(Angle(degrees: Double(offset.width / 10)))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { gesture in
                            if abs(gesture.translation.width) > 200 {
                                withAnimation {
                                    self.onRemove(self.card)
                                }
                            } else {
                                self.offset = .zero
                            }
                        }
                )
                .animation(.spring(), value: offset)
        }
    }
}

#Preview {
    PotionBookView()
}

