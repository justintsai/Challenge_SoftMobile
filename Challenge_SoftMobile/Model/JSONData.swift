//
//  JSONData.swift
//  Challenge_SoftMobile
//
//  Created by 蔡念澄 on 2022/6/16.
//

import Foundation

struct JSONData: Codable {
    let DataList: [Data]
    
    struct Data: Codable {
        let title: String
        let content: String
        let img: URL
    }
}
