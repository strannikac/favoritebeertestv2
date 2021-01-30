//
//  UpdaterService.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation

//MARK: Updater Service - update beers list

class UpdaterService {
    
    private let updateTimeSeconds: Int64 = 3600
    
    private var isUpdatingData = false
    private var checkUpdatingTime = true
    
    private var page = 1
    private var lastPage = 0
    private var perPage = 80
    
    private weak var updatingController: UpdatingTableDelegate!
    
    private let api: APIService
    
    private var error: String = ""
    private var beers: [BeerModel] = []
    
    init() {
        api = APIService()
    }
    
    //MARK: updating process functions
    
    func startUpdate(controllerDelegate controller: UpdatingTableDelegate, checkTime: Bool = true) {
        let isTIme = isUpdateTime()
        
        if !isUpdatingData && (!checkTime || isTIme) {
            isUpdatingData = true
            
            checkUpdatingTime = checkTime
            updatingController = controller
            beers = []
            
            api.getList(page: page, perPage: perPage, completion: saveResponseData(page:items:error:))
        } else {
            isUpdatingData = false
            controller.didUpdate(items: [])
        }
    }
    
    //finish or continue to update?
    private func nextStep() {
        
        if lastPage > 0 && page >= lastPage {
            isUpdatingData = false
            
            let seconds = getSeconds()
            UserDefaults.standard.set(seconds, forKey: "lastUpdatedTime")
            
            if error != "" {
                beers = []
                
                AlertView.show(title: StringConstants.error.rawValue, message: error, controller: updatingController!)
            }
            
            updatingController?.didUpdate(items: beers)
        } else {
            page += 1
            api.getList(page: page, perPage: perPage, completion: saveResponseData(page:items:error:))
        }
    }
    
    private func saveResponseData(page: Int, items: [BeerModel], error: String?) {
        if let error = error {
            self.error = error
            self.lastPage = page
        } else {
            self.beers += items
            
            if(items.count < self.perPage) {
                self.lastPage = page
            }
        }
        
        nextStep()
    }
    
    func isUpdateTime() -> Bool {
        if let lastTime = UserDefaults.standard.object(forKey: "lastUpdatedTime") as? Int64 {
            let nowSeconds = getSeconds()
            
            if (nowSeconds - lastTime) < updateTimeSeconds {
                return false
            }
        }
        
        return true
    }
    
    func getSeconds(forDate date: Date = Date()) -> Int64 {
        return Int64(date.timeIntervalSince1970)
    }
}
