//
//  LocationError.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 10/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation

enum UserLocationAuthorization {
    case notAuthorized
    case notDetermined
    case authorized
    case couldntReverseGeoloc
}

struct UserLocationResponse {
    var authorization: UserLocationAuthorization
    let location: Location
      
}
