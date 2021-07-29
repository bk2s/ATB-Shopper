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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let add = UIAlertController(title: "Добавить товар", message: "Введите название товара", preferredStyle: .alert)
        add.addTextField { UITextField in
            UITextField.placeholder = ""
        }
        
        
        add.addAction(UIAlertAction(title: "Добавить", style: UIAlertAction.Style.default, handler: { saveAction -> Void in
            let textField = add.textFields![0] as UITextField
            self.itemArray.append(textField.text ?? "")
            self.tableView.reloadData()
        }))
        add.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        self.present(add, animated: true)
        
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
