//
//  RecipeViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 9/10/26.
//

import Foundation
import RxSwift

class RecipeViewModel {
    let items = PublishSubject<[Recipe]>()
    
    func fetchRecipes() {
        guard let url = URL(string: "https://dummyjson.com/recipes") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            
            do {
                let decoded  = try JSONDecoder().decode(RecipesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.items.onNext(decoded.recipes)
                }
            } catch {
                print("Decode error:", error)
            }
            
        }.resume()
    }
}
