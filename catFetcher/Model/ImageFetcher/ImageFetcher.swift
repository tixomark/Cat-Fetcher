//
//  ImageFetcher.swift
//  catFetcher
//
//  Created by tixomark on 3/4/21.
//

import Foundation
import UIKit

final class ImageFetcher: NSObject {
    
    private lazy var urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    weak var delegate: ImageFetcherDelegate?
    var downloadTasks: [URLSessionDownloadTask] = []
    
    func startDownload(url: URL) {
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        self.downloadTasks.append(downloadTask)
    }
    
}

extension ImageFetcher: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        do {
//            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let savedUrl = documentsURL.appendingPathComponent(location.lastPathComponent)
//            try FileManager.default.moveItem(at: location, to: savedUrl)
            delegate?.finishedDownload(of: downloadTask, in: session, to: location)
//        } catch {
//            print(error)
//        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let calculatedProgres = Float(totalBytesExpectedToWrite) / Float(totalBytesWritten)
        delegate?.get(progress: calculatedProgres, of: downloadTask, in: session)
    }
}
