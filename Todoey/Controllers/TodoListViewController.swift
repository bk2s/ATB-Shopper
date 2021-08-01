//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [
        "Гречка",
        "Мука",
        "Кофе",
        "Яйца",
        "Молоко"
    ]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Загружаем в itemArray то, что хранится в памяти приложения.
        if let items = (defaults.array(forKey: "TodoListArray") as? [String]) {
            itemArray = items
        }
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Добавить товар", message: "", preferredStyle: .alert)
        
        
        
        // Создаём кнопку добавить, которая присвоит значение текстового поля - переменной textField
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
          
                self.itemArray.append(textField.text!) 
            
            // Сохраняем значения в userDefaults, чтобы массив не сбрасывался после перезагрузки
            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
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
    
    
    
    
    
}

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = message
        return cell
    }
    
    
    
    

    
    
    
    // Отмечаем элемент, который выбрал пользователь.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
}

