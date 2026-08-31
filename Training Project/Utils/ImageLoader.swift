//
//  ImageLoader.swift
//  Training Project
//
//  Created by Akar jaza on 8/31/26.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let key = urlString as NSString
        
        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: key)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
