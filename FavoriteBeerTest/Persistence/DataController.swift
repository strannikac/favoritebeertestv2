//
//  DataController.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    lazy var viewContext: NSManagedObjectContext = {
      let context = persistentContainer.viewContext
      context.automaticallyMergesChangesFromParent = true
      context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
      return context
    }()
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        load()
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            completion?()
        }
    }
}

//MARK: remove and save data

extension DataController {
    func saveContext(forContext context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Error when saving! \(nserror.localizedDescription)")
                    print("Callstack:")
                    for symbol: String in Thread.callStackSymbols {
                        print(" > \(symbol)")
                    }
                }
            }
        }
    }
    
    func clearBeers() {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Beer")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try privateMOC.execute(deleteRequest)
            saveContext(forContext: privateMOC)
            saveContext(forContext: viewContext)
        } catch let error as NSError {
            //error
            print("error in clearing data for beers: \(error.localizedDescription)")
        }
    }
    
    func saveBeers(items: [BeerModel]) {
        
        clearBeers()
        
        let favoritesIds = getFavorites()
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = viewContext
        
        for item in items {
            let beer = Beer(context: privateMOC)
            
            beer.id = Int64(item.id)
            beer.name = item.name
            beer.alcohol = item.alcohol ?? 0.0
            beer.ebc = item.ebc ?? 0.0
            beer.ibu = item.ibu ?? 0.0
            beer.tagline = item.tagline ?? ""
            beer.firstBrewed = item.firstBrewed ?? ""
            beer.info = item.description ?? ""
            beer.imageUrl = item.imageUrl ?? ""
            beer.brewersTips = item.brewersTips ?? ""
            beer.yeast = item.ingredients?.yeast ?? ""
            
            var foodPairing = ""
            
            if let arr = item.foodPairing {
                let count = arr.count
                
                for i in 0..<count {
                    if foodPairing != "" {
                        foodPairing += ", "
                    }
                    
                    foodPairing += String(arr[i])
                }
            }
            
            beer.foodPairing = foodPairing
            
            if let ingredients = item.ingredients {
                for maltItem in ingredients.malt {
                    let malt = BeerMalt(context: privateMOC)
                    
                    malt.name = maltItem.name ?? ""
                    malt.value = maltItem.amount?.value ?? 0.0
                    malt.unit = maltItem.amount?.unit ?? ""
                    
                    malt.beer = beer
                }
                
                for hopItem in ingredients.hops {
                    let hop = BeerHop(context: privateMOC)
                    
                    hop.name = hopItem.name ?? ""
                    hop.value = hopItem.amount?.value ?? 0.0
                    hop.unit = hopItem.amount?.unit ?? ""
                    hop.add = hopItem.add ?? ""
                    hop.attribute = hopItem.attribute ?? ""
                    
                    hop.beer = beer
                }
            }
            
            beer.isFavorite = false
            if favoritesIds.contains(item.id) {
                beer.isFavorite = true
            }
        }
        
        saveContext(forContext: privateMOC)
        saveContext(forContext: viewContext)
    }
    
    func saveFavorite(_ beer: Beer) {
        
        let favorite = getFavoriteById(beer.id)
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = viewContext
        
        if beer.isFavorite {
            //remove
            if let favorite = favorite {
                viewContext.delete(favorite)
            }
        } else {
            //add
            if favorite == nil {
                let newFavorite = Favorite(context: privateMOC)
                newFavorite.beerId = beer.id
            }
        }
        
        beer.setValue(!beer.isFavorite, forKey: "isFavorite")
        
        saveContext(forContext: privateMOC)
        saveContext(forContext: viewContext)
    }
}

//MARK: select data

extension DataController {
    //get favorites
    func getFavorites() -> [Int] {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
    
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result.count > 0 {
                return result.map({Int($0.beerId)})
            }
        } catch {
            print("error selecting fevorites from local")
        }
        
        return []
    }
    
    func getFavoriteById(_ id: Int64) -> Favorite? {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "beerId = %@", "\(id)")
    
        do {
            let result = try viewContext.fetch(fetchRequest)
            if result.count > 0 {
                return result[0]
            }
        } catch {
            print("error selecting fevorites from local")
        }
        
        return nil
    }
    
    func getBeers() -> [Beer] {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var result: [Beer] = []
    
        do {
            result = try viewContext.fetch(fetchRequest)
        } catch {
            result = []
            print("error selecting beers from local")
        }
        
        return result
    }
    
    func getFavoriteBeers() -> [Beer] {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == true")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var result: [Beer] = []
    
        do {
            result = try viewContext.fetch(fetchRequest)
        } catch {
            result = []
            print("error selecting beers from local")
        }
        
        return result
    }
}
