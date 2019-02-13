//
//  TableViewController.swift
//  bookTableView
//
//  Created by CAU on 29/01/2019.
//  Copyright © 2019 CAU. All rights reserved.
//

import UIKit

class LensTableViewController: UITableViewController {
    var lens:Array<LensList>?
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let lens1 = LensList(LensName: "Soft Lens", LensLife: "Daily")
        let lens2 = LensList(LensName: "Soft Lens", LensLife: "2-Weekly, Monthly")
        let lens3 = LensList(LensName: "Color Lens", LensLife: "")
        let lens4 = LensList(LensName: "Hard Lens", LensLife: "")
        lens = [lens1, lens2, lens3, lens4]
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath == selectedIndexPath{
            return
        }
        if let newCell = tableView.cellForRow(at: indexPath) {
            if newCell.accessoryType == .none
            {
                newCell.accessoryType = .checkmark
            }
        }
        if let oldCell = tableView.cellForRow(at: selectedIndexPath){
            if oldCell.accessoryType == .checkmark{
                oldCell.accessoryType = .none
            }
        }
        selectedIndexPath = indexPath
        self.view.reloadInputViews()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let b = lens else{
            return 0
        }
        return b.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        }
        // Configure the cell...
        guard let b = lens else{
            return cell
            
        }
        cell.textLabel?.text = b[indexPath.row].LensName
        cell.detailTextLabel?.text = b[indexPath.row].LensLife
        
        
        return cell
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
}
