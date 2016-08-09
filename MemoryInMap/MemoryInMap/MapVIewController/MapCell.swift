//
//  MapCell.swift
//  MemoryInMap
//
//  Created by wangkan on 16/5/8.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit

class MapCell: FoldingCell {
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}