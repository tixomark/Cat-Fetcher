//
//  File.swift
//  catFetcher
//
//  Created by tixomark on 4/1/21.
//

import Foundation

protocol SettingsObserver: AnyObject {
    
    var classDescription: String { get }
    
    func stopLoadingSliderValueUpdated(withValue: Float)
    
    func infiniCatUpdated(withValue: Bool)
    
    func totalNumberOfFetchedCatsUpdated(withValue: Int)
    
}

extension SettingsObserver {
    
    func stopLoadingSliderValueUpdated(withValue: Float) {}
    
    func infiniCatUpdated(withValue: Bool) {}
    
    func totalNumberOfFetchedCatsUpdated(withValue: Int) {}
    
}
