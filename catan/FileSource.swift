//
//  FileSource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 2..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

struct FileSource: JSONDecodable {
    init(json: JSON) throws {
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
    
    func isImage() -> Bool {
        if fileType.isBlank() { return false }
        return fileType.hasPrefix("image/");
    }
    
    func estimateHeight(width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        if width == 0 || imageRatio == 0 { return CGFloat(0) }
        return min(width / CGFloat(imageRatio), maxHeight)
    }
}
