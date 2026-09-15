//
//  RecipeViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 9/10/26.
//

import Foundation
import RxSwift

class RecipeViewModel {
    var networkService: NetworkServiceProtocol = NetworkService.shared
    var disposeBag = DisposeBag()
    
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
        let encoded = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? query
        
        let urlString = query.isEmpty
        ? "https://dummyjson.com/recipes"
        : "https://dummyjson.com/recipes/search?q=\(encoded)"
        
        guard let url = URL(string: urlString) else {
            return .just([])
        }
        
        return networkService.request(url: url, method: .get, body: nil)
            .map { (response: RecipesResponse) in response.recipes }
            .catchAndReturn([])
    }
}
