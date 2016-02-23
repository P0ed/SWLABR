//
//  CollectionModel.swift
//  SWLABR
//
//  Created by Настя on 23/02/16.
//  Copyright © 2016 P0ed. All rights reserved.
//

import Foundation

protocol CollectionModel {
    typealias Item
    
    var numberOfItems: Int { get }
    func itemAtIndex(index: Int) -> Item
}