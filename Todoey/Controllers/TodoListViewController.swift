//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var color = ""
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        searchBar.barTintColor = UIColor(hexString: color)
        searchBar.searchTextField.textColor = .white
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor(hexString: color)?.cgColor
        
        
        title = selectedCategory?.name
        navigationController?.navigationBar.barTintColor = UIColor(hexString: color)?.darken(byPercentage: 0.6)
        tableView.rowHeight = 70
        tableView.backgroundColor = UIColor(hexString: color)?.darken(byPercentage: 0.9)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: color)//?.darken(byPercentage: 0.6)
    }
    
    
    
    @IBAction func backToMenu(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    //MARK: Plus button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Добавить задачу", message: "", preferredStyle: .alert)
        
        
        
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
            alertTextField.autocorrectionType = .yes
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        // Запускаем
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = todoItems?[indexPath.row]
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let bgcolor = UIColor(hexString: color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
        cell.textLabel?.text = message?.title
        cell.backgroundColor = bgcolor
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:(UIColor(hexString: color)?.darken(byPercentage: 0.5)!)!, isFlat:true)
        
        
        
        
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
    
    
    
    
    //MARK: load Realm
    
    // Загружаем данные через Realm
    // В функции можно указать значение по умолчанию.
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    realm.delete(item)
                }
            }catch {
                print(error)
            }
        }
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
