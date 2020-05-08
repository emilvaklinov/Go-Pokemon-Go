//
//  CoreDataHelper.swift
//  Go Pokemon Go
//
//  Created by Emil Vaklinov on 08/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    createPokemon(name: "Pikachu", imageName: "pickachu-2")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Snorlax", imageName: "snorlax")
}

func createPokemon(name: String, imageName: String) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(context: context)
        pokemon.imageName = imageName
        pokemon.name = name
        try? context.save()
    }
}
    
    func getAllPokemon() -> [Pokemon] {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let pokemonData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon]
            if let pokemons = pokemonData {
                if pokemons.count == 0 {
                    addAllPokemon()
                    return getAllPokemon()
                } else {
                    return pokemons
                }
            }
        }
        return []
}
