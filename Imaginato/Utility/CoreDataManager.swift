//
//  CoreDataManager.swift
//  MVVMLogin
//
//  Created by TBS17 on 3/17/21.
//

import Foundation
import UIKit
import CoreData

let coredata_manager : CoreDataManager = CoreDataManager.sharedIntance
class CoreDataManager: NSObject {
    
    static let sharedIntance = CoreDataManager()
    
    func createDataFor(_ userModel:User){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue("\(userModel.userId ?? 0)", forKeyPath: "id")
        user.setValue(userModel.userName ?? "", forKey: "name")
        user.setValue(userModel.created_at ?? "", forKey: "createdAt")

        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func retrieveDataFor(_ userId:String) -> User?{
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", userId)

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let user = User(userId: Int(data.value(forKey: "id") as? String ?? "0") ?? 0, userName: data.value(forKey: "name") as? String ?? "", createdAt: data.value(forKey: "createdAt") as? String ?? "")
                return user
            }
        } catch {
            print("Failed")
        }
        return nil
    }
}
