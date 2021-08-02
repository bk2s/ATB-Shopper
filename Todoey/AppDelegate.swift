//
//  AppDelegate.swift
//  deleteMe
//
//  Created by  Stepanok Ivan on 01.08.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }



    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         Постоянный контейнер для приложения. Эта реализация
         создает и возвращает контейнер, загрузив хранилище для
         приложение к нему. Это свойство не является обязательным, поскольку есть допустимые
         условия ошибки, которые могут привести к сбою создания магазина.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Замените эту реализацию кодом для соответствующей обработки ошибки.
                // fatalError () заставляет приложение создавать журнал сбоев и завершать работу. Вы не должны использовать эту функцию в приложении для доставки, хотя она может быть полезна во время разработки.
                
                /*
                 Типичные причины ошибки здесь включают:
                 * Родительский каталог не существует, не может быть создан или запрещает запись.
                 * Постоянное хранилище недоступно из-за разрешений или защиты данных, когда устройство заблокировано.
                 * На устройстве закончилось место.
                 * Магазин не может быть перенесен на текущую версию модели.
                 Проверьте сообщение об ошибке, чтобы определить, в чем была настоящая проблема.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

