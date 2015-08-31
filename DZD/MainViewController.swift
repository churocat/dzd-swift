//
//  ViewController.swift
//  DZD
//
//  Created by 竹田 on 2015/8/18.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var chartScrollView: ChartScrollView!
    
    let user = DzdDefault.User
    let teamId = DzdDefault.TeamId
    
    let chartLineColorArr = [UIColor.redColor(), UIColor.blueColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DZDRequest.getTeamRecords(teamId) { teamRecords in
//            var chartDataArr = teamRecords.map { $0.chartData }
//            let chartLineColorArr = [UIColor.redColor(), UIColor.blueColor()]
//            
////            dispatch_async(dispatch_get_main_queue()) {
//                self.chartScrollView.drawChart(chartDataArr, chartLineColorArr: chartLineColorArr)
////            }
//            
//            println("teamRecords = \(teamRecords)")
//            println(chartDataArr)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let chartData1: [(CGFloat, CGFloat)] = [(2.0, 2.1), (4, -4), (7, 1), (8, 11), (9, 15), (10, 3), (15, 0)]
        let chartData2: [(CGFloat, CGFloat)] = [(2, 5), (3, 7), (9, 10), (12, 20), (17, 3), (20, 22)]
        let chartDataArr = [chartData1, chartData2]

        chartScrollView.drawChart(chartDataArr, chartLineColorArr: chartLineColorArr)
        
    }
    
    // MARK : Collection View
    
    let imageArray = [UIImage(named: "sasanala"), UIImage(named: "roylo")]
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProfileImageViewCell
        cell.profileImageView.image = self.imageArray[indexPath.row]
        cell.profileImageView.lineColor = chartLineColorArr[indexPath.row]
        return cell
    }
}

