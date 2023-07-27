//
//  CleanUriAPIService.swift
//  US Application
//
//  Created by Omomayowa Adebanjo on 7/27/23.
//

import Foundation

class CleanUriAPIService: UrlShortenerService {
  private let urlString = "https://cleanuri.com/api/v1/shorten"
  
  private enum UrlShortenerError: Error {
    case invalidURL
    case invalidRequest
    case invalidData
    case invalidResponse
  }

  func shortenURLWithCleanURI(longURL: String, completion: @escaping (Result<String, Error>) -> Void) {
    var request = URLRequest(url: URL(string: urlString)!)
    
    request.httpMethod = "POST"
    
    if let encodedLongURL = longURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      let parameters = ["url": encodedLongURL]
      
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      } catch {
        completion(.failure(error))
        return
      }
      
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
          completion(.failure(error!))
          return
        }
        
        guard let data = data else {
          completion(.failure(UrlShortenerError.invalidData))
          return
        }
        
        do {
          if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
             let resultURL = jsonResponse["result_url"] as? String {
            completion(.success(resultURL))
          } else {
            completion(.failure(UrlShortenerError.invalidResponse))
          }
        } catch {
          completion(.failure(UrlShortenerError.invalidResponse))
        }
      }
      task.resume()
    } else {
      completion(.failure(UrlShortenerError.invalidURL))
    }
  }
  
}

