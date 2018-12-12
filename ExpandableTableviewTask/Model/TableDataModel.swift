
//  Created by mahiti on 19/11/18.
//  Copyright © 2018 nanda. All rights reserved.
//

import Foundation

typealias TableData = [TableDatum]

class TableDatum: Codable {
    let name: String
    let subCategory: [SubCategory]
    
    enum CodingKeys: String, CodingKey {
        case name
        case subCategory = "sub_category"
    }
    
    init(name: String, subCategory: [SubCategory]) {
        self.name = name
        self.subCategory = subCategory
    }
}

class SubCategory: Codable {
    let name, displayName: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "display_name"
    }
    
    init(name: String, displayName: String) {
        self.name = name
        self.displayName = displayName
    }
}

