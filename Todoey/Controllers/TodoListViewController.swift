//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        print(dataFilePath!)
        
        var newItem = Item()
        newItem.title = "Молоко"
        itemArray.append(newItem)
        
        var newItem2 = Item()
        newItem2.title = "Сыр"
        newItem2.done = true
        itemArray.append(newItem2)
        
        var newItem3 = Item()
        newItem3.title = "Яйца"
        itemArray.append(newItem3)
        
        
        loadItems()

        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Добавить товар", message: "", preferredStyle: .alert)
        
        
        
        // Создаём кнопку добавить, которая присвоит значение текстового поля - переменной textField
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
          
            var newItem = Item()
            newItem.title = textField.text!

            self.itemArray.append(newItem)
            
            self.saveItems()
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
    
    
    
    
    
}

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = message.title
        
        cell.accessoryType = message.done ? .checkmark : .none
        
//        if message.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    
        return cell
    }
    
    
    
    

    
    
    
    // Отмечаем элемент, который выбрал пользователь.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        
        
        if itemArray[indexPath.row].done == false {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        itemArray[indexPath.row].done.toggle()
        
        saveItems()
 
        
        // Анимашка исчезающего выделения
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Подпись к кнопке удалить
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    // Удаление ячейки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.itemArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    // Сохраняем данные через NSCoder
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    
    // Загружаем данные через NSCoder
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    
    
}


