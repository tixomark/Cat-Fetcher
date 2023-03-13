//
//  ImageFetcherDelegate.swift
//  catFetcher
//
//  Created by tixomark on 3/10/21.
//

import Foundation

protocol ImageFetcherDelegate: AnyObject {
    func finishedDownload(of downloadTask: URLSessionDownloadTask, in session: URLSession, to url: URL) -> ()
}

extension ImageFetcherDelegate {
    func get(progress: Float, of downloadTask: URLSessionDownloadTask, in session: URLSession) -> () {}
    
}
