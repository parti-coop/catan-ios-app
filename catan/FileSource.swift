//
//  FileSource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 2..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Alamofire
import TRON
import SwiftyJSON

protocol FileSourceDownloadDelegate: class {
    func fileSourceDownloadOnReady()
    func fileSourceDownloadOnRunning(progress: Progress?)
    func fileSourceDownloadOnPause()
    func fileSourceDownloadOnCompleted()
    func openFileSourceDownloaded()
    func fileSourceDownloadProgress(_ progress: Progress)
    var post: Post { get }
}

class FileSource: JSONDecodable {
    required init(json: JSON) throws {
        id = json["id"].intValue
        attachmentUrl = json["attachment_url"].stringValue
        attachmentLgUrl = json["attachment_lg_url"].stringValue
        attachmentMdUrl = json["attachment_md_url"].stringValue
        attachmentSmUrl = json["attachment_sm_url"].stringValue
        name = json["name"].stringValue
        fileType = json["file_type"].stringValue
        fileSize = json["file_size"].stringValue
        humanFileSize = json["human_file_size"].stringValue
        seqNo = json["seq_no"].intValue
        imageRatio = json["image_ratio"].floatValue
        
        if isDownloaded() { currentDownloadStatus = .completed }
    }
    
    let id: Int
    let attachmentUrl: String
    let attachmentLgUrl: String
    let attachmentMdUrl: String
    let attachmentSmUrl: String
    let name: String
    let fileType: String
    let fileSize: String
    let humanFileSize: String
    let seqNo: Int
    let imageRatio: Float // w/h
    
    enum downloadStatus {
        case running, pause, completed, error
    }
    var currentDownloadStatus: downloadStatus?
    var downloadRequest: DownloadRequest?
    weak var fileSourceDownloadDelegate: FileSourceDownloadDelegate? {
        didSet {
            guard let fileSourceDownloadDelegate = fileSourceDownloadDelegate else { return }
            setup(fileSourceDownloadDelegate: fileSourceDownloadDelegate)
        }
    }
    
    func isImage() -> Bool {
        if fileType.isBlank() { return false }
        return fileType.hasPrefix("image/");
    }
    
    func estimateHeight(width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        if width == 0 || imageRatio == 0 { return CGFloat(0) }
        return min(width / CGFloat(imageRatio), maxHeight)
    }

    func handleDownloadFile() {
        guard let currentDownloadStatus = currentDownloadStatus else {
            self.currentDownloadStatus = .running
            fileSourceDownloadDelegate?.fileSourceDownloadOnRunning(progress: nil)
            performDownload()
            return
        }
        
        switch currentDownloadStatus {
        case .running:
            self.currentDownloadStatus = .pause
            if let downloadRequest = downloadRequest {
                downloadRequest.cancel()
            }
            fileSourceDownloadDelegate?.fileSourceDownloadOnPause()
            break
        case .completed:
            fileSourceDownloadDelegate?.openFileSourceDownloaded()
            break
        case .error:
            self.currentDownloadStatus = .running
            fileSourceDownloadDelegate?.fileSourceDownloadOnReady()
            performDownload()
            break
        case .pause:
            self.currentDownloadStatus = .running
            fileSourceDownloadDelegate?.fileSourceDownloadOnReady()
            performDownload()
        }
    }
    
    fileprivate func performDownload() {
        guard let fileSourceDownloadDelegate = fileSourceDownloadDelegate else { return }
        
        let downloadAPIRequest = PostRequestFactory.download(postId: fileSourceDownloadDelegate.post.id, fileSourceId: id, to: downloadDestination())
        self.downloadRequest = downloadAPIRequest.performCollectingTimeline(withCompletion: { [weak fileSourceDownloadDelegate, weak self] (response) in
            guard let strongSelf = self else { return }
            if response.error == nil, let _ = response.destinationURL {
                strongSelf.currentDownloadStatus = .completed
                fileSourceDownloadDelegate?.fileSourceDownloadOnCompleted()
            } else {
                strongSelf.forceRemoveDownloaded()
                if strongSelf.currentDownloadStatus != .pause {
                    UIAlertController.alertError()
                    log.error(response.error ?? "")
                    strongSelf.currentDownloadStatus = .error
                    fileSourceDownloadDelegate?.fileSourceDownloadOnReady()
                }
            }
            
        })?.downloadProgress(closure: { [weak fileSourceDownloadDelegate] (progress) in
            fileSourceDownloadDelegate?.fileSourceDownloadProgress(progress)
        })
    }

    func setup(fileSourceDownloadDelegate delegate: FileSourceDownloadDelegate) {
        guard let currentDownloadStatus = currentDownloadStatus else {
            delegate.fileSourceDownloadOnReady()
            return
        }
        
        switch currentDownloadStatus {
        case .running:
            delegate.fileSourceDownloadOnRunning(progress: downloadRequest?.progress)
            break
        case .completed:
            delegate.fileSourceDownloadOnCompleted()
            break
        case .error:
            delegate.fileSourceDownloadOnReady()
            break
        case .pause:
            delegate.fileSourceDownloadOnReady()
        }
    }
    
    func downloadDestination() -> DownloadRequest.DownloadFileDestination {
        return { temporaryURL, response in
            let fileURL = self.downloadDestinationURL()
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
    }
    
    func downloadDestinationURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL.appendingPathComponent("fileSource/\(self.id)/\(self.name)")
    }
    
    func isDownloaded() -> Bool {
        return FileManager.default.fileExists(atPath: downloadDestinationURL().path)
    }
    
    func forceRemoveDownloaded() {
        currentDownloadStatus = nil
        try? FileManager.default.removeItem(at: downloadDestinationURL())
    }
}
