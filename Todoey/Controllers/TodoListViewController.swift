//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    // Подключаемся к AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
   
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        loadItems()
//
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(dataFilePath)
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Переменная с текстом, который мы добавим в список.
        var textField = UITextField()
        // Создаём всплывашку
        let alert = UIAlertController(title: "Добавить товар", message: "", preferredStyle: .alert)
        
        
        
        // Создаём кнопку добавить, которая присвоит значение текстового поля - переменной textField
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
          
    
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            

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
            
            // Сначала удаляем из базы данных
            context.delete(itemArray[indexPath.row])
            // А потом уже с экрана. Иначе будет бедулька.
            self.itemArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            saveItems()
            tableView.reloadData()

        }
    }
    
    
    // Сохраняем данные через CoreData
    func saveItems() {
        
        do {
           try context.save()
            
        } catch {
            print(error)
        }
        
    }
    
    
    // Загружаем данные через CoreData
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    
    
}


