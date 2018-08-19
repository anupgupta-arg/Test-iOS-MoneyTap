//
//  SaveCoreDataDetails.swift
//  MoneyTapTest
//
//  Created by Uniqolabel Developer on 19/08/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit
import CoreData

class SaveCoreDataDetails {
    
    private static var _instance: SaveCoreDataDetails?;
    private let appDelegateObj = UIApplication.shared.delegate as! AppDelegate
    private var coreDataManagedObj: [NSManagedObject] = []
    
    private init() {
        
    }
    
    public static func getSingleton() -> SaveCoreDataDetails {
        if (SaveCoreDataDetails._instance == nil) {
            SaveCoreDataDetails._instance = SaveCoreDataDetails.init();
        }
        return SaveCoreDataDetails._instance!;
    }
    
    func saveDataIntoCoreData(saveStruct : searchResultStruct) {
        
        
        
        //        let appDelegateObj = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegateObj.persistentContainer.viewContext
        
        let pageId : Int = saveStruct.pageId as Int
        let subTitle : String = saveStruct.subTitle!
        let title : String = saveStruct.title!
        let imgSource : String = saveStruct.imgUrl!
        let pageUrl : String = saveStruct.pageUrl
       
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "pageId = %d", pageId)
        
        do {
            let getdata : NSArray = try context.fetch(fetchRequest) as NSArray
            
            let predicate : NSPredicate = NSPredicate(format: "pageId = %d", pageId)
            
            let Checking : NSArray = getdata.filtered(using: predicate) as NSArray
             if Checking.count == 0 {
                let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
                let newdata = NSManagedObject(entity: entity!, insertInto: context)
                
                newdata.setValue(title, forKey: "title")
                newdata.setValue(subTitle, forKey: "subTitle")
                newdata.setValue(imgSource, forKey: "imgUrl")
                newdata.setValue(pageId, forKey: "pageId")
                newdata.setValue(pageUrl, forKey: "pageUrl")
               
                do {
                    try context.save()
                    print("Data Saved")
                }
                catch{
                    print("Not Saved")
                }
           
            }
            
        }
        catch {
            print("erorororo")
        }
        
        
        
        
        
        
    }
    
    
    func getDataFromCoreData() -> [NSManagedObject] {
        
        //        let appDelegateObj = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegateObj.persistentContainer.viewContext
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        //request.predicate = NSPredicate(format: "age = %@", "12")
//        request.returnsObjectsAsFaults = false
//        let predicate = NSPredicate(format: "screenNumber = %@", screenNumber)
//        request.predicate = predicate
        do {
            coreDataManagedObj = try context.fetch(request) as! [NSManagedObject]
            
            if coreDataManagedObj.count > 0  {
                
                return coreDataManagedObj
            }
            else{
                return []
            }
            
        } catch {
            
            print("Failed")
            return []
        }
        
        
    }
  
    
    func deleteAllSaveDataFromCoreData() -> Bool {
        //delete all data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
            
        }
        
        do{
            coreDataManagedObj = try context.fetch(deleteFetch) as! [NSManagedObject]
            return true
        }catch{
            print ("There was an error")
            return false
        }
        
    }
}
