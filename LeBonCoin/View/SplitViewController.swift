//
//  SplitViewController.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 13/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    var temperatures : Temperatures?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        temperatures = Singleton.shared.temperatures

        
        guard
            let leftNavController = self.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.viewControllers.first as? TepeturesListViewController,
            let detailViewController = (self.viewControllers.last as? UINavigationController)?.topViewController as? DetailsTemperaureViewController,
            let firstTemp = temperatures?.temperatures![0]  as? Temperature
            else { 
                return
        }

        detailViewController.temps = firstTemp
        
        self.title = temperatures?.location?.city
        
        self.preferredDisplayMode = .allVisible
        self.preferredPrimaryColumnWidthFraction = 0.3;
        masterViewController.delegate = detailViewController
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        detailViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
    }
    

}
