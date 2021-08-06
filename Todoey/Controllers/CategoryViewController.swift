//
//  CategoryViewController.swift
//  ATB Shopper
//
//  Created by  Stepanok Ivan on 02.08.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

     
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadItems()
    }

    
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Добавить категорию", message: "", preferredStyle: .alert)
        
        
        
        // Создаём кнопку добавить, которая присвоит значение текстового поля - переменной textField
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
          
    
            
            let newItem = Category()
            newItem.name = textField.text!
            
            

            
            self.saveItems(category: newItem)
            self.tableView.reloadData()
        }
        
        
        // Создаём текстовое поле для ввода товара
        alert.addTextField { alertTextField in
            alertTextField.placeholder = ""
            textField = alertTextField
        }
        
        // Запускаем
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

        
        
    }
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        if let message = categories?[indexPath.row] {
            cell.textLabel?.text = message.name
        } else {
            cell.textLabel?.text = "Пусто"
        }

    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: Save and load CoreData
    
    
    // Сохраняем данные через CoreData
    func saveItems(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print(error)
        }
        
    }
    
    
    // Загружаем данные через CoreData
    // В функции можно указать значение по умолчанию.
    func loadItems() {
        
        categories = realm.objects(Category.self)
        
        
    }
    
  
}
