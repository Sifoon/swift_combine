//
//  Singleton.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 14/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import Foundation
class Singleton{
    
    static let shared = Singleton()
    
    init(){}
    
    var temperatures : Temperatures?
 
    
}
