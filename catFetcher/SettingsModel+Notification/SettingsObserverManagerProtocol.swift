//
//  SettingsObserverProtocol.swift
//  catFetcher
//
//  Created by tixomark on 4/1/21.
//

import Foundation

protocol SettingsObserverManagerProtocol: class {
    var observers: [SettingsObserver] {get set}
    
    func attach(_ observer: SettingsObserver)
    
    func detach(_ observer: SettingsObserver)
    
//    func notify()
}
