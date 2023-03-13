//
//  MainModelDelegate.swift
//  catFetcher
//
//  Created by tixomark on 4/28/21.
//

import Foundation

protocol MainModelCoreDataDelegate: AnyObject {
    
    func newlyAddedImageMogels(count: Int)
    
    func deletedImageModels(count: Int)
    
}

protocol MainModelDownloadDelegate: AnyObject {
    
    func completedDownloadOfItem(numberOfItemsToFetch: Int, numberOfFetchedItems: Int)
    
    func downloadResumed(numberOfFetchedItems: Int)
    
    func downloadPaused()
    
    func downloadFinished(numberOfFetchedItems: Int)
    
}
