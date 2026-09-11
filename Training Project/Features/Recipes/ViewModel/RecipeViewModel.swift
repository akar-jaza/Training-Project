//
//  RecipeViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 9/10/26.
//

import Foundation
import RxSwift

class RecipeViewModel {
//    let items = PublishSubject<[Recipe]>()
    
    // We didn't nead this part anymore, I still keep it here for reference
//    func fetchRecipes() {
//        guard let url = URL(string: "https://dummyjson.com/recipes") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else { return }
//            
//            
//            do {
//                let decoded  = try JSONDecoder().decode(RecipesResponse.self, from: data)
//                DispatchQueue.main.async {
//                    self.items.onNext(decoded.recipes)
//                }
//            } catch {
//                print("Decode error:", error)
//            }
//            
//        }.resume()
//    }
    
    func searchRecipes(query: String) -> Observable<[Recipe]> {
        Observable.create { observer in
            let encoded = query.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? query
            
            let urlString = query.isEmpty
            ? "https://dummyjson.com/recipes"
            : "https://dummyjson.com/recipes/search?q=\(encoded)"
            
            guard let url = URL(string: urlString) else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    observer.onNext([])
                    observer.onCompleted()
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(RecipesResponse.self, from: data)
                    observer.onNext(decoded.recipes)
                } catch {
                    print("Decode error:", error)
                    observer.onNext([])
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
