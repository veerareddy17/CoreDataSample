//
//  SketchModel.swift
//  Sketch
//
//  Created by Hexalab on 8/2/17.
//  Copyright © 2017 Hexalab Software Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class SketchModel: NSObject {

    var context : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static let sharedInstance : SketchModel = {
        let instance = SketchModel()
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        instance.context = appDelegate.persistentContainer.viewContext
        return instance
    }()
    
    
    func createNewNotes(imageData:NSData, imageId:Int64, componets:[CGPoint]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Sketch", in: context)
        let sketchRecord = NSManagedObject(entity: entity!, insertInto: context)
        
        sketchRecord.setValue(imageData, forKey: "imageData")
        sketchRecord.setValue(imageId, forKey: "imageId")
        sketchRecord.setValue(componets, forKey: "pathComponets")
        
        context.insert(sketchRecord)
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error.localizedDescription)")
        }
    }
    
    func updateNotes()  {
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error.localizedDescription)")
        }
    }
    
    func deleteNotes(notes:Sketch)
    {
        context.delete(notes)
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error.localizedDescription)")
        }
    }
    
    func fetchAllNotes() -> [Sketch]
    {
        let fetchReq : NSFetchRequest<Sketch> =  Sketch.fetchRequest()
        fetchReq.returnsObjectsAsFaults = false
        let sort = NSSortDescriptor(key: #keyPath(Sketch.imageId), ascending: true)
        fetchReq.sortDescriptors = [sort]
        let fetchResults = try! context.fetch(fetchReq)
        return fetchResults
    }
    
    
    func fetchParticularNotes(dict:[String:String]) -> [Sketch]
    {
        let fetchReq : NSFetchRequest<Sketch> =  Sketch.fetchRequest()
        fetchReq.returnsObjectsAsFaults = false
        let sort = NSSortDescriptor(key: #keyPath(Sketch.imageId), ascending: true)
        fetchReq.sortDescriptors = [sort]
        fetchReq.predicate = NSPredicate(format: "(imageId = %@)","\((dict["imageId"])!)")
        let fetchResults = try! context.fetch(fetchReq)
        return fetchResults
    }
    
    
    func deleteAll()
    {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sketch")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}
