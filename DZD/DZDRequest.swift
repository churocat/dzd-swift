//
//  DZDRequest.swift
//  DZD
//
//  Created by 竹田 on 2015/8/18.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import Foundation
import Alamofire

class DZDResponseData {
    var status: String?
    var data: AnyObject?
    
    init (dataSource: AnyObject?) {
        if let dataSourceDictionary = dataSource as? NSDictionary {
            data = dataSourceDictionary["data"]!
            status = dataSourceDictionary["status"] as? String
        }
    }
}

class DZDRequest {

    static func insertWeight(weight: Double, unit: DZDWeightUnit, uid: String, date: NSDate) {
        // get url
        var url = Setting.BaseUrl + "/v1/weight"
        println(url)
        
        // get parameters
        var dateUnixtimeString = date.unixtimeString
        var parameters = ["number": "\(weight)", "unit": "\(unit)", "uid": uid, "date": dateUnixtimeString]

        // send the request
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { request, response, data, error in
                if error == nil {
                    println(data)
                } else {
                    println(error)
                }
        }
    }

    static func getTeamRecords(teamId: Int, handler: ([DZDUserData] -> Void)) {
        // get url
        var url = Setting.BaseUrl + "/v1/game/\(teamId)/weight"
        println(url)
        
        Alamofire.request(.GET, url)
            .responseJSON { request, response, data, error in
                if error != nil {
                    println(error)
                } else {
                    let responseData = DZDResponseData(dataSource: data)
                    if let records = responseData.data as? NSArray {
                        var output = map(records) { DZDUserData(responseData: $0) }
                        handler(output)
                    }
                }
        }
    }
}

