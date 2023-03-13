//
//  MainModel.swift
//  catFetcher
//
//  Created by tixomark on 4/28/21.
//

import Foundation

final class MainModel {
    
    // MARK: Variables
    var catImages: [ImageModel]!
    private(set) var amountOfFetchedCatsInCurrentSession: Int = 0
    private let settings = Settings.appSettings
    
    let coreDataManager = CoreDataImageModelManager()
    private let imageFetcher = ImageFetcher()

    weak var downloadDelegate: MainModelDownloadDelegate?
    weak var coreDataDelegate: MainModelCoreDataDelegate?
    
    init() {
        imageFetcher.delegate = self
        
        coreDataManager.fetch(returnToQueue: .global()) { [weak newSelf = self] images in
            guard let withinSelf = newSelf else { return }
            withinSelf.catImages = images
            withinSelf.coreDataDelegate?.newlyAddedImageMogels(count: withinSelf.catImages.count)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAllCatsCoreData), name: .deleteAllCatsButtonTriggered , object: nil)
    }
    
    // MARK: #selector methods
    @objc func deleteAllCatsCoreData() {
        coreDataManager.delete(catImages)
        catImages = []
    }
    
    //MARK: Timer managing code
    private(set) var timer: Timer?
    
    // Start or pauses timer when startPauseDownlaodButton is tapped
    func resumeDownload() {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
        
        downloadDelegate?.downloadResumed(numberOfFetchedItems: amountOfFetchedCatsInCurrentSession)
    }
    
    // Starting image download on timer
    @objc func timerAction() {
        guard amountOfFetchedCatsInCurrentSession < Int(settings.stopLoadingSliderValue) else {
            amountOfFetchedCatsInCurrentSession = 0
            stopTimer()
            
            downloadDelegate?.downloadFinished(numberOfFetchedItems: Int(settings.stopLoadingSliderValue))
            return
        }
        imageFetcher.startDownload(url: URL(string: "https://thiscatdoesnotexist.com")!) //https://www.thiswaifudoesnotexist.net/example-45746.jpg
        amountOfFetchedCatsInCurrentSession = amountOfFetchedCatsInCurrentSession + 1
    }
    
   private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func pauseDownload() {
        stopTimer()
        downloadDelegate?.downloadPaused()
    }
    
}

// MARK: ImageFetchDelegate protocol methods realisation
extension MainModel: ImageFetcherDelegate {
    
    func finishedDownload(of downloadTask: URLSessionDownloadTask, in session: URLSession, to url: URL) {
        if let data = try? Data(contentsOf: url) {
            
            coreDataManager.saveImages([data], returnToQueue: .global()) { [weak self] in
                guard let self = self else { return }
                self.catImages.append(contentsOf: $0)
                
                self.downloadDelegate?.completedDownloadOfItem(numberOfItemsToFetch: Int(self.settings.stopLoadingSliderValue), numberOfFetchedItems: self.amountOfFetchedCatsInCurrentSession)
            }
            
            settings.incrementTotalNumberOfFetchedCats()
        }
    }
}

