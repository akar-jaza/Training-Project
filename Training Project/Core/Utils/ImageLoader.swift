import UIKit
import RxSwift

protocol ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage?, for urlString: String, didFailWithError: Error?)
}

enum ImageLoaderError: Error {
    case failedToLoadImage(Error)
    case invalidURL
    case failedToDecodeImage
}

final class ImageLoader {
    static let shared = ImageLoader()
    
    let networkService: NetworkServiceProtocol = NetworkService.shared
    
    private let cache = NSCache<NSString, UIImage>()
    private let disposeBag = DisposeBag()

    
    func loadImage(from urlString: String, delegate: ImageLoaderDelegate) {
        let key = urlString as NSString
         
        if let cachedImage = cache.object(forKey: key) {
            delegate
                .imageLoader(
                    self,
                    didLoad: cachedImage,
                    for: urlString,
                    didFailWithError: nil
                )
            return
        }
        
        guard let url = URL(string: urlString) else {
            delegate
                .imageLoader(
                    self,
                    didLoad: nil,
                    for: urlString,
                    didFailWithError: ImageLoaderError.invalidURL
                )
            return
        }
        
        networkService
            .requestData(url: url, method: .get)
            .subscribe(
                onNext: { [weak self] data in
                    guard let self = self else { return }
                    
                    guard let image = UIImage(data: data) else {
                        delegate
                            .imageLoader(
                                self,
                                didLoad: nil,
                                for: urlString,
                                didFailWithError: ImageLoaderError.failedToDecodeImage
                            )
                        return
                    }
                    
                    self.cache.setObject(image, forKey: key)
                    delegate
                        .imageLoader(
                            self,
                            didLoad: image,
                            for: urlString,
                            didFailWithError: nil
                        )
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    delegate
                        .imageLoader(
                            self,
                            didLoad: nil,
                            for: urlString,
                            didFailWithError: ImageLoaderError.failedToLoadImage(error)
                        )
                }
            )
            .disposed(by: disposeBag)
    }
}
