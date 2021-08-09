//
//  SwipeTableViewController.swift
//  ATB Shopper
//
//  Created by  Stepanok Ivan on 07.08.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        

        cell.delegate = self
        return cell
    }
    
    
    
    
    //MARK: Swipe delete delegate

    // Для того, чтобы это работало, нужно в Storyboard указать класс SwipeTableViewCell для ячейки и модуль SwipeCellKit

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
            
            print("delete cell")
            
            self.updateModel(at: indexPath)
            

        }
        deleteAction.image = UIImage(systemName: "trash")
        return [deleteAction]
    }
    
    
  
    
    
    // Чтобы использовать свайп до упора для удаления, нужно убрать tableView.reloadData() из удаления. Иначе вылетает.
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    func updateModel(at indexPath: IndexPath) {
        print("Ячейка удалена")
    }
   
}


