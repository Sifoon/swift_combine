//
//  DetailsTemperaureViewController.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 13/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import UIKit

class DetailsTemperaureViewController: UIViewController {
    //var temperatures : Temperatures?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var snowriskLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var mediumWindLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var degreeGroundLabel: UILabel!
    
    
    var temps : Temperature?{
        didSet {
          refreshUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    private func refreshUI() {
       loadViewIfNeeded()
        dateLabel.text = DateFormatter.yyyyMMdd.string(from: temps!.date)
        snowriskLabel.text = temps!.snowRisk ? "Oui" : "Non"
        seaLevelLabel.text = "\(temps!.pression?.seaLevel ?? 0)"
        mediumWindLabel.text = "\(temps!.wind?.mediumWins ?? 0)"
        cloudinessLabel.text = "\(temps!.cloudiness?.total ?? 0)"
        degreeGroundLabel.text = "\(temps!.degree?.ground ?? 0)"
        
        self.title = DateFormatter.yyyyMMdd.string(from: temps!.date)
     }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailsTemperaureViewController: TepeturesListDelegate {
    func tempSelected(_ newTemp: Temperature) {
        temps = newTemp
    }
    
}
