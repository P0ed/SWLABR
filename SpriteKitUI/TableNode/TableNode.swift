//
//  TableNode.swift
//  SWLABR
//
//  Created by Настя on 23/02/16.
//  Copyright © 2016 P0ed. All rights reserved.
//

import Foundation
import SpriteKit

class TableNode<CellType: SKNode, ItemType>: SKNode {
    var cellNodes: [CellType] = []
    
    let model: TableViewModel<ItemType>
    
    let cellHeight: Float = 40
    
    let createCell: () -> CellType
    let updateCell: (CellType, ItemType) -> ()
    
    init(model: TableViewModel<ItemType>, createCell: () -> CellType, updateCell: (CellType, ItemType) -> ()) {
        
        self.model = model
        self.createCell = createCell
        self.updateCell = updateCell

        super.init()
        updateTable()
        
    }
    
    func updateTable() {
        cellNodes = model.model.items.map {
            item in
            let cell = createCell()
            updateCell(cell, item)
            return cell
        }
        
        layoutTable()
    }
    
    func layoutTable() {
 
    }
}