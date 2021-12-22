//
//  WebService.swift
//  RemoteConfig
//
//  Created by Ali Dinç on 20/12/2021.
//

import UIKit

class WebService {
    // MARK: - Properties
    static let shared = WebService()
    private init() {}
    let cache = NSCache<NSString, UIImage>()
    // MARK: - Methods
    func showNetworkResponse(data : Data){
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                print(jsonResult)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func getISO(with searchKey: String, completion: @escaping (Result<Flag, RCError>) -> Void) {
        let parameters = ["country": "\(searchKey)"]
        guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries/flag/images") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            /// find something else  @ALIWORKKKKKKKKKK
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                guard let data = data else { return completion(.failure(.invalidData)) }
                self.showNetworkResponse(data: data)
                do {
                    let decoder = JSONDecoder()
                    guard let jsonResponse = try decoder.decode(FlagData.self, from: data).data else { return }
                    completion(.success(jsonResponse))
                } catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        task.resume()
    }
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
}
