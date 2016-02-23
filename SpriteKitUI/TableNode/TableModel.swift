//
//  TableModel.swift
//  SWLABR
//
//  Created by Настя on 23/02/16.
//  Copyright © 2016 P0ed. All rights reserved.
//

import Foundation

class TableModel<Item>: CollectionModel {
    
    let items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    var numberOfItems: Int {
        get {
            return items.count
        }
    }
    
    func itemAtIndex(index: Int) -> Item {
        return items[index]
    }
    
}