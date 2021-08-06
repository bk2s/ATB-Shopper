//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
 
    let realm = try! Realm()
    var todoItems: Results<Item>?

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
    
    
    
    

    
    //MARK: Plus button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Добавить товар", message: "", preferredStyle: .alert)
        
        
        
        // Создаём кнопку добавить, которая присвоит значение текстового поля - переменной textField
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
          
    
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                        newItem.date = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print(error)
                }
               
                 }

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


//MARK: TableView

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = todoItems?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = message?.title
        
        
        
        cell.accessoryType = message?.done ?? true ? .checkmark : .none
    
        return cell
    }
    
    
    
    

    
    //MARK: Check item
    
    // Отмечаем элемент, который выбрал пользователь.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(todoItems![indexPath.row].done)
        
        if todoItems?[indexPath.row].done == false {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        
        if let item = todoItems?[indexPath.row] {
        do {
        try self.realm.write {
            item.done.toggle()
        }
        }catch {
            print(error)
        }
        }
        
        // Анимашка исчезающего выделения
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    //MARK: Delete item
    
    // Подпись к кнопке удалить
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    // Удаление ячейки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let item = todoItems?[indexPath.row] {
            do {
            try self.realm.write {
                realm.delete(item)
            }
            }catch {
                print(error)
            }
                
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.reloadData()
            }
            
        }
    }
    
    
    
    
    
    //MARK: load Realm
    
    // Загружаем данные через Realm
    // В функции можно указать значение по умолчанию.
   func loadItems() {
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

   }
}





//MARK: Search bar
extension TodoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            loadItems()
            tableView.reloadData()
            
            // Запускаем команду в основном потоке.
            DispatchQueue.main.async {
            // Убирает клавиатуру убирая поиск с первого места. Как бы свергая его власть))
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
