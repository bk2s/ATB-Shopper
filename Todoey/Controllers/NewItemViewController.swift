//
//  NewItemViewController.swift
//  ATB Shopper
//
//  Created by  Stepanok Ivan on 09.08.2021.
//  Copyright © 2021 Stepanok. All rights reserved.
//

import UIKit
import RealmSwift

class NewItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchColor: UISearchBar!
    @IBOutlet weak var firstItem: UIView!
    @IBOutlet weak var secondItem: UIView!
    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var buttonMake: UIButton!
    
    var color = UIColor(hexString: "19BC9C")
    let newItem = Category()
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
        
        input.delegate = self
        
        firstItem.backgroundColor = color?.darken(byPercentage: 0.1)
        secondItem.backgroundColor = color?.darken(byPercentage: 0.2)
        thirdItem.backgroundColor = color?.darken(byPercentage: 0.3)
        searchColor.barTintColor = color
        searchColor.searchTextField.textColor = .white
        searchColor.layer.borderWidth = 1
        searchColor.layer.borderColor = color?.cgColor
        buttonMake.isEnabled = false
        title = "Список дел"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
        
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

       //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
       //tap.cancelsTouchesInView = false

       view.addGestureRecognizer(tap)
   }

   //Calls this function when the tap is recognized.
   @objc func dismissKeyboard() {
       //Causes the view (or one of its embedded text fields) to resign the first responder status.
       view.endEditing(true)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("FGFG")
        
        if input.text == "" {
            buttonMake.isEnabled = false
        } else {
            buttonMake.isEnabled = true
        }
        
        return true
    }
    

    
    @IBAction func inputText(_ sender: UITextField) {

    }
    
    
   
    
    
    @IBAction func colorSelected(_ sender: UIButton) {
        print(sender.backgroundColor!.hexValue())
        color = UIColor(hexString: sender.backgroundColor!.hexValue())
        searchColor.barTintColor = color
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
        searchColor.layer.borderColor = color?.cgColor
        firstItem.backgroundColor = color?.darken(byPercentage: 0.1)
        secondItem.backgroundColor = color?.darken(byPercentage: 0.2)
        thirdItem.backgroundColor = color?.darken(byPercentage: 0.3)
        
        if input.text != "" {
            title = input.text }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


            let destinationVC = segue.destination as! TodoListViewController
        destinationVC.selectedCategory = newItem
        destinationVC.color = newItem.color
        }
    
    
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        print(color!.hexValue())
        print(input.text!)
        
        newItem.name = input.text!
        newItem.color = color!.hexValue()
        
        saveItems(category: newItem)
        

        
        performSegue(withIdentifier: "newItem", sender: self)

        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func saveItems(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print(error)
        }
        
    }
    
    
}
