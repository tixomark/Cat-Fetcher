//
//  StartPauseDownloadProtocol.swift
//  catFetcher
//
//  Created by tixomark on 4/15/21.
//

import Foundation

protocol StartPauseDownloadDelegate: class {
    
    var condition: Bool { get }

    func timerActionIfFalse()
    
    func timerActionIfTrue()
}
