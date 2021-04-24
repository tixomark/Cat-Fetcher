//
//  Settings.swift
//  catFetcher
//
//  Created by tixomark on 3/15/21.
//

import Foundation

final class Settings {
    
    // SettingsObserverProtocol variable
    var observers = [SettingsObserver]()
    
    
    //MARK: Setting basic logic
    static var appSettings = Settings()
    private let defaults = UserDefaults.standard
    
    private enum SettingsKeys: String {
        case infiniCatIsOn = "infiniCatIsOn"
        case stopLoadingSliderValue = "stopLoadingSliderValue"
        case totalNumberOfFetchedCats = "totalNumberOfFetchedCats"
    }
    
    var infiniCatIsOn: Bool {
        get {
            return defaults.bool(forKey: SettingsKeys.infiniCatIsOn.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: SettingsKeys.infiniCatIsOn.rawValue)
            observers.forEach{ $0.infiniCatUpdated(withValue: newValue) }
        }
    }
    
    var stopLoadingSliderValue: Float {
        get {
            return defaults.float(forKey: SettingsKeys.stopLoadingSliderValue.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: SettingsKeys.stopLoadingSliderValue.rawValue)
            observers.forEach{ $0.stopLoadingSliderValueUpdated(withValue: newValue) }
        }
    }
    
    var totalNumberOfFetchedCats: Int {
        get {
            return defaults.integer(forKey: SettingsKeys.totalNumberOfFetchedCats.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: SettingsKeys.totalNumberOfFetchedCats.rawValue)
            observers.forEach{ $0.totalNumberOfFetchedCatsUpdated(withValue: newValue) }
        }
    }
    
    func incrementTotalNumberOfFetchedCats() {
        self.totalNumberOfFetchedCats = self.totalNumberOfFetchedCats + 1
    }

}

//MARK: Implement observer functionality to 
extension Settings: SettingsObserverManagerProtocol {
    
    func attach(_ observer: SettingsObserver) {
        print("Attached \(observer.classDescription) as Settings observer")
        observers.append(observer)
    }
    
    func detach(_ observer: SettingsObserver) {
        if let observerIndexToDelete = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: observerIndexToDelete)
            print("Detached \(observer.classDescription) as Settings observer")
        }
    }
}
