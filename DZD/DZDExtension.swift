//
//  DZDExtension.swift
//  DZD
//
//  Created by 竹田 on 2015/8/19.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import Foundation

extension NSDate {
    var unixtimeString: String {
        let timestampWithDummy = self.timeIntervalSince1970.description
        let tokens = timestampWithDummy.componentsSeparatedByString(".")
        return tokens[0] ?? "0"
    }
}