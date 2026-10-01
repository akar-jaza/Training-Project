import Foundation
import RxSwift

final class RecipeViewModel {
    var networkService: NetworkServiceProtocol    
    var cacheService: DataCacheServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        cacheService: DataCacheServiceProtocol = DataCacheService.shared
    ) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    private let cacheKey = "cached_recipes"

    
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
        
        let cached: [Recipe] = cacheService.load([Recipe].self, forKey: cacheKey) ?? []
        
        let network = networkService.request(url: url, method: .get, body: nil)
            .map { (response: RecipesResponse) in response.recipes }
            .do(onNext: { [weak self] recipes in
                guard let self = self else { return }
                self.cacheService.save(recipes, forKey: self.cacheKey)
            })
            .catchAndReturn(cached)
        
        
        if cached.isEmpty {
            return network
        } else {
            return Observable.concat(
                .just(cached),
                network  // in easy terms, this is just a fallback, if the network fails, the cache will be used.
            )
        }
    }
}
