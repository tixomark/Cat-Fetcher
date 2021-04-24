//
//  DownloadManager.swift
//  catFetcher
//
//  Created by tixomark on 4/15/21.
//

import Foundation
import UIKit

final class StartPauseDownloadModel {
    
    var timer: Timer?
    weak var delegate: StartPauseDownloadDelegate!
    
    // Start or pauses timer when startPauseDownlaodButton is tapped
    func startDownload() {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.tolerance = 0.01
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
//        guard timer != nil else {
//            let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//            timer.tolerance = 0.5
//            RunLoop.current.add(timer, forMode: .common)
//            self.timer = timer
//            
//            settedTimerState(timer.isValid)
//            return
//        }
//        timer?.invalidate()
//        timer = nil
//
//        settedTimerState(timer?.isValid ?? false)
    }
    
    func pauseDawnload() {
        timer?.invalidate()
        timer = nil
    }
    
    // Starting image download on timer
    @objc func timerAction() {
        
        // if number of currently loading cats is over the value that is set in settings, then stop downloding, else continue
        if delegate!.condition {
            delegate.timerActionIfTrue()
        } else {
            timer?.invalidate()
            timer = nil
            delegate.timerActionIfFalse()
        }
        // if number of currently loading cats is over the value that is set in settings, then stop downloding, else continue
    }
}



