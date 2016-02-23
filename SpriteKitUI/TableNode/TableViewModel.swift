//
//  TableViewModel.swift
//  SWLABR
//
//  Created by Настя on 23/02/16.
//  Copyright © 2016 P0ed. All rights reserved.
//

import Foundation

class TableViewModel<Item> {
    
    let model: TableModel<Item>
    var contentOffset: Float = 0
    var canSelectItems: Bool = true
    var selectedIndex: Int?
    
    init(model: TableModel<Item>) {
        self.model = model
    }
    
    
}