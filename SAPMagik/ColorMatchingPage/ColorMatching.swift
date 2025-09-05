import SwiftUI

struct ColorMatching: View {

    @State private var gameState: GameState = .playing
    @State private var supplementalDescription: String? = nil

    @State private var dataModel = DataModel()

    var body: some View {
        Challenge2ContainerView(
            state: $gameState,
            supplementalDescription: $supplementalDescription
        ) {
            GameView(
                gameState: $gameState,
                supplementalDescription: $supplementalDescription
            )
        }
        .ignoresSafeArea()
        .environment(dataModel)
    }
}
