//
//  UrlShortenerService.swift
//  US Application
//
//  Created by Omomayowa Adebanjo on 7/27/23.
//

import Foundation

protocol UrlShortenerService {
  func shortenURLWithCleanURI(longURL: String, completion: @escaping (Result<String, Error>) -> Void)
}
