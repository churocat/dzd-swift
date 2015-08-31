//
//  DZDSetting.swift
//  DZD
//
//  Created by 竹田 on 2015/8/18.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import Foundation

enum DZDWeightUnit: String, Printable {
    case Kg = "kg"
    case Lb = "lb"
    
    var description: String { return self.rawValue }
}

struct Setting {
    static let BaseUrl = "http://52.69.180.210:5566"
}

struct DzdDefault {
    static let User = "roylo"
    static let TeamId = 1
}