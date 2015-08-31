//
//  DZDUserData.swift
//  DZD
//
//  Created by 竹田 on 2015/8/19.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import Foundation

struct DZDWeightData : Printable {
    var _id: String = ""
    var date: Int = Int(INT_MAX)
    var number: Double = 0
    var unit: String = ""
    
    var description: String { return "(\(date) : \(number) \(unit))" }
    
    init() {}
    
    init(responseData: AnyObject) {
        if let weightData = responseData as? NSDictionary {
            _id = weightData["_id"] as! String
            unit = weightData["unit"] as! String
        
            var dateString = weightData["date"]as! String
            date = dateString.toInt() ?? Int(INT_MAX)
            
            var numberString = weightData["number"] as! String
            number = (numberString as NSString).doubleValue
        }
    }
}

class DZDUserData : Printable {
    var uid: String = ""
    var weightData: [DZDWeightData] = []
    
    var description: String { return "\(uid): \(weightData)" }
    
    init(responseData: AnyObject) {
        self.uid = responseData["uid"] as! String
        if let weightDataArr = responseData["data"] as? NSArray {
            weightData = map(weightDataArr) { DZDWeightData(responseData: $0) }
        }
    }
}


import UIKit
extension DZDUserData {
    var minDateWeightData: DZDWeightData {
        return weightData.reduce(DZDWeightData()) { outputWeightData, thisWeightData in
            return outputWeightData.date < thisWeightData.date ? outputWeightData : thisWeightData
        }
    }
    
    var chartData: [(CGFloat, CGFloat)] {
        let minDate = 16664 // 16664 is a magic min date
        weightData.sort() { $0.date < $1.date }
        
        var chartData = weightData.map { eachWeightData in
            return (CGFloat(eachWeightData.date / 86400 - minDate), CGFloat(eachWeightData.number))
        }
        
        return removeDuplicateChartData(chartData)
    }
    
    func removeDuplicateChartData(chartData: [(CGFloat, CGFloat)]) -> [(CGFloat, CGFloat)] {
        var existed = Set<CGFloat>()
        
        var outputChartData: [(CGFloat, CGFloat)] = []
        for oneChartData in chartData.reverse() {
            if !existed.contains(oneChartData.0) {
                outputChartData += [oneChartData]
                existed.insert(oneChartData.0)
            }
        }
        
        return outputChartData.reverse()
    }
}