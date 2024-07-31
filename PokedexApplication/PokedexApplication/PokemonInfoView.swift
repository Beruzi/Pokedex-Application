//
//  PokemonInfoView.swift
//  PokedexApplication
//
//  Created by Michael Taylor on 7/31/24.
//

import SwiftUI



struct PokemonInfoView: View {
    @StateObject private var viewModel = PokemonInfoViewModel()
    @State private var inputText: String = ""
    @State private var isShiny: Bool = false
    
    var body: some View {
        VStack{
            SearchBarView(viewModel: viewModel, inputText: $inputText, isShiny: $isShiny)

            PokemonSpriteView(viewModel: viewModel, inputText: $inputText, isShiny: $isShiny)

            PokemonNameAndShiny(viewModel: viewModel, inputText: $inputText, isShiny: $isShiny)

            VStack{
                Text("ID: \(String(viewModel.pokemon?.id ?? 0 ))")
            }
        }
    }
}

#Preview {
    PokemonInfoView()
}



struct SearchBarView: View {
    @ObservedObject var viewModel: PokemonInfoViewModel
    @Binding var inputText: String
    @Binding var isShiny: Bool
    
    var body: some View {
        TextField("Pokemon", text: $inputText, onCommit: {
            Task {
                await viewModel.searchPokemon(named: inputText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            }
        })
        .disableAutocorrection(true)
        .frame(width: 300)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(5)
    }
    
}



struct PokemonSpriteView: View {
    @ObservedObject var viewModel: PokemonInfoViewModel
    @Binding var inputText: String
    @Binding var isShiny: Bool

    var body: some View {
        let shinyOrNotSprite = isShiny ? viewModel.pokemon?.sprites.other.officialArtwork.frontShiny : viewModel.pokemon?.sprites.other.officialArtwork.frontDefault
        
        AsyncImage(url: URL(string: shinyOrNotSprite ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Circle()
                .foregroundColor(.blue)
        }
        .frame(width: 350, height: 350)
        .padding(5)
    }
}



struct PokemonNameAndShiny: View {
    @ObservedObject var viewModel: PokemonInfoViewModel
    @Binding var inputText: String
    @Binding var isShiny: Bool
    
    var body: some View {
        HStack{
            Text(viewModel.pokemon?.name.capitalized ?? "Pokemon Name")
                .bold()
                .font(.title2)
            Button(action: {
                isShiny.toggle()
            }) {
                Image(systemName: "sparkles")
                    .font(.system(size: 30))
                    .foregroundColor(isShiny ? .yellow : .gray)
                    .opacity(isShiny ? 1.0 : 0.4)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 20 )
        
    }
    
}

