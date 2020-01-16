//
//  TepeturesListViewController.swift
//  LeBonCoin
//
//  Created by Seif Nasri on 13/01/2020.
//  Copyright © 2020 Seif Nasri. All rights reserved.
//

import UIKit

protocol TepeturesListDelegate: class {
  func tempSelected(_ newTemp: Temperature)
}

class TepeturesListViewController: UITableViewController {

    var temperatures : Temperatures?
    var viewModel: MainViewModel?
    
    weak var delegate: TepeturesListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        temperatures = Singleton.shared.temperatures
        self.title = temperatures?.location?.city?.capitalized != "Unknown" ? temperatures?.location?.city?.capitalized : "France"
             
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard self.temperatures != nil ,  let tmp = self.temperatures!.temperatures else {
            return 0
        }
        return tmp.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard self.temperatures != nil  else {
            return cell
        }
        let tmp = self.temperatures!.temperatures![indexPath.row] as! Temperature
                   cell.textLabel?.text = DateFormatter.yyyyMMdd.string(from:  tmp.date)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTemps = temperatures?.temperatures![indexPath.row] as! Temperature
        delegate?.tempSelected(selectedTemps )
      if
        let detailViewController = delegate as? DetailsTemperaureViewController,
        let detailNavigationController = detailViewController.navigationController {
        splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
          
      }
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
