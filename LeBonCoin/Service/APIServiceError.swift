//
//  APIServiceError.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 10/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    case parsing(city: String)
    case network(description: String)
}
