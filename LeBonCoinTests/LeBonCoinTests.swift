//
//  LeBonCoinTests.swift
//  LeBonCoinTests
//
//  Created by Seif Nasri on 15/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import XCTest
@testable import LeBonCoin

class LeBonCoinTests: XCTestCase {

    var sutAPISERVICE: APIService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    let loc = Location(context: PersistanceService.childContext!)
    sutAPISERVICE = APIService(location: loc)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    sutAPISERVICE = nil
    }

    func testScoreIsComputedWhenGuessGTTarget() {
      // 1. given
        let subJson = [
        "temperature": [
        "2m": 280.2,
        "sol": 279.4,
        "500hPa": -0.1,
        "850hPa": -0.1
        ],
        "pression": [
        "niveau_de_la_mer": 103610
        ],
        "pluie": 0,
        "pluie_convective": 0,
        "humidite": [
            "2m": 80.1
        ],
        "vent_moyen": [
        "10m": 8.5
       ],
        "vent_rafales": [
        "10m": 24.9
        ],
        "vent_direction": [
        "10m": 273
        ],
        "iso_zero": 1043,
        "risque_neige": "non",
        "cape": 0,
        "nebulosite": [
        "haute": 20,
        "moyenne": 0,
        "basse": 32,
        "totale": 51
        ]
            ] as [String : Any]

        let key = "2020-01-04 19:00:00"

        let result = sutAPISERVICE.createConformeDictionaryForCoreData(key: key, subJson: subJson)

        XCTAssertEqual(result.count, 11)
        XCTAssertEqual(result["date"] as? String, "2020-01-04 19:00:00")
        XCTAssertEqual(result["humidite"] as! Double,  80.1, "expected better from you")

    }

     func testDecodeTemperatures() {

           let temperatureArray = [ ["date" : "2020-01-04 19:00:00",
                                  "cape": 0,
                                  "pluie_convective":0,
                                  "pluie": 0,
                                 "iso_zero":1043,
                                 "humidite":80.1,
                                 "risque_neige":"non",
                                 "nebulosite":
                                           [
                                               "moyenne":0,
                                               "haute":20 ,
                                               "basse":32 ,
                                               "totale":51
                                           ]
                                     ,
                                 "degree":
                                           ["2m": 280.2,
                                           "sol": 279.4,
                                           "500hPa": -0.1,
                                           "850hPa": -0.1
                                           ]
                                 ,
                                 "pression":
                                           [ "niveau_de_la_mer": 103610]
                                   ,
                                 "wind":
                                           [ "vent_direction": 273,
                                                 "vent_moyen":8.5,
                                                 "vent_rafales":24.9
                                           ]
                   ]]as [[String : Any]]
                              let dataCoreDictionnary = [
                              "location": [
                                  "city": "Paris",
                                  "lat":48.856697,
                                  "long":2.351462],
                              "temperatures":
                               temperatureArray ] as [String: Any]

           let dateFormatter = DateFormatter.yyyyMMdd


                   do {
                       let returnedData = try JSONSerialization.data(withJSONObject: dataCoreDictionnary, options: .prettyPrinted)
                       let coreDataObjectTemperatures = try JSONDecoder().decode(Temperatures.self, from: returnedData)

                       XCTAssertNotNil(coreDataObjectTemperatures)
                       XCTAssert((coreDataObjectTemperatures.temperatures as Any) is NSOrderedSet)
                       let coreDataObjectTemperature = coreDataObjectTemperatures.temperatures?.firstObject as? Temperature
                       XCTAssertNotNil(coreDataObjectTemperature)
                       XCTAssertEqual(coreDataObjectTemperature!.date, dateFormatter.date(from: "2020-01-04 19:00:00"))

                       }
                       catch  {
                       }

               }

}
