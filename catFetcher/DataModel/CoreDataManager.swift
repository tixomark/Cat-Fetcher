//
//  CoreDataManager.swift
//  catFetcher
//
//  Created by tixomark on 3/29/21.
//

import Foundation
import UIKit
import CoreData

final class CoreDataImageModelManager {
    
    var persistentContainer: NSPersistentContainer!
    var imageModelManagedObjectContext: NSManagedObjectContext!
    var privateContext: NSManagedObjectContext!
    
    let privateCoreDataQueue = DispatchQueue(label: "com.coredata.queue",
                                             qos: .utility,
                                             attributes: .concurrent,
                                             autoreleaseFrequency: .workItem,
                                             target: .global(qos: .background))
    
    init() {
        // get persistent container from appDelegate
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        //create parent managed object context
        imageModelManagedObjectContext = persistentContainer.viewContext
        imageModelManagedObjectContext.undoManager = nil
        
        // create child manajed object context
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = imageModelManagedObjectContext
        
    }
    
    func fetch(numberOfImages limit: Int = 0, startingFromIndex offset: Int = 0, returnToQueue queue: DispatchQueue, completion: @escaping ([ImageModel]) -> ()) {
        privateCoreDataQueue.async {
            self.privateContext.perform {
                
                // Creating fetch requrest for retreiving ImageModel objects
                let request = ImageModel.fetchRequest() as NSFetchRequest<ImageModel>
                
                // Configring fetch request. If limit was set, create sorting filter to fetch specified number of ImageMogel objects
                if limit != 0 {
                    request.fetchLimit = limit
                    let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                    request.sortDescriptors = [sortDescriptor]
                }
                request.fetchOffset = offset
                
                // Creating async fetch request with created request as a parameter
                let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { (result: NSAsynchronousFetchResult) in
                    guard let finalResult = result.finalResult else {
                        // If nothing is fetched or some error, then return empty array
                        queue.async {
                            completion([])
                        }
                        print("Nothing came from core data")
                        return
                    }
                    // If fetched any data, pass it to completion handler in specified dispatch queue
                    queue.async {
                        completion(finalResult)
                    }
                    print(Thread.current, "Fetched \(finalResult.count) ImageModel objects")
                }
                
                do {
                    try self.privateContext.execute(asyncRequest)
                } catch {
                    print(error.localizedDescription, "Can't fetch ImageModel objects")
                }
            }
        }
        
    }
    
    func saveImages(_ imageData: [Data], returnToQueue queue: DispatchQueue, _ savedImadeMogelObject: @escaping ([ImageModel]) -> () = { _ in return }) {
        privateCoreDataQueue.async {
            self.privateContext.perform {
                
                let imageMogelsToSave = imageData.compactMap { data -> ImageModel in
                    // Create new ImageModel object
                    let newImageModel = ImageModel(context: self.privateContext)
                    newImageModel.image = data
                    newImageModel.timeStamp = Date().timeIntervalSinceReferenceDate
                    return newImageModel
                }
                    
                do {
                    // trying to save private context
                    try self.privateContext.save()
                    
//                    self.imageModelManagedObjectContext.performAndWait {
                        
                        print(Thread.current)
//                        do {
                            // trying to save main context
//                            try self.imageModelManagedObjectContext.save()
                            // Pass recently saved ImageModel objects to completion handler
                            queue.async {
                                savedImadeMogelObject(imageMogelsToSave)
                            }
                            print("\(imageMogelsToSave.count) ImageModel objects saved")
//                        } catch {
//                            print(error.localizedDescription, "Can't save ImageModel object with main context")
//                        }
//                    }
                    
                } catch {
                    print(error.localizedDescription, "Can't save ImageModel object with private context")
                }
            }
        }
    }
    
    func delete(_ imageModelObject: [ImageModel]) {
        privateCoreDataQueue.async {
            self.privateContext.perform {
                
                // iterate over all objects
                for modelToDelete in imageModelObject {
                    autoreleasepool {
                        // mark each object as needed t odelete
                        self.privateContext.delete(modelToDelete)
                    }
                }
                
                do {
                    // trying to save private context
                    try self.privateContext.save()
                    
//                    self.imageModelManagedObjectContext.performAndWait {
                        
//                        do {
                            // trying to save main context
//                            try self.imageModelManagedObjectContext.save()
                    print(Thread.current, "Deleted \(imageModelObject.count) ImageModel objects")
//                        } catch {
//                            print(error.localizedDescription, "Can't delete ImageModel object with main context")
//                        }
//                    }
                    
                } catch {
                    print(error.localizedDescription, "Can't delete ImageModel object with private context")
                }
            }
        }
    }
    
    func saveMainContext() {
        do {
            // trying to save main context
            try imageModelManagedObjectContext.save()
            print(Thread.current, "Main context saved")
        } catch {
            print(error.localizedDescription, "Can't save main context")
        }
    }
}
