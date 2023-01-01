//
//  VolumeSearchResult.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/01.
//

import Foundation


struct VolumeSearchResult: Codable {
    let kind: String
    let totalItems: Int
    let items: [VolumeItem]
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        totalItems = try container.decode(Int.self, forKey: .totalItems)
//        kind = try container.decode(String.self, forKey: .kind)
//        items = try container.decode([VolumeItem].self, forKey: .items)
//    }
}
