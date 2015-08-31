//
//  ChartScrollView.swift
//  DZD
//
//  Created by 竹田 on 2015/8/19.
//  Copyright (c) 2015年 ChuroCat. All rights reserved.
//

import UIKit
import SwiftCharts

let MaxDays: Double = 60
let ColumnWidth: Double = 70

class ChartScrollView: UIScrollView {

    private var chart: Chart? // arc
    
    func drawChart(chartDataArr: [[(CGFloat, CGFloat)]], chartLineColorArr: [UIColor]) {
        assert(chartDataArr.count == chartLineColorArr.count, "oh... data and line color are not paired")
        

        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let chartPointsArr = map(chartDataArr) { map($0) { ChartPoint(x: ChartAxisValueFloat($0.0, labelSettings: labelSettings), y: ChartAxisValueFloat($0.1)) } }
        
        var allChartPoints = chartPointsArr.reduce([], combine: +)
        
        var minMaxDays: (Double, Double) = allChartPoints.reduce((Double(INT_MAX), 0)) { minMaxDays, thisChartPoints in
            let minDay = min(minMaxDays.0, thisChartPoints.x.scalar)
            let maxDay = max(minMaxDays.1, thisChartPoints.x.scalar)
            return (minDay, maxDay)
        }
        var chartFrameWidth = ColumnWidth * (minMaxDays.1 - minMaxDays.0 + 2)
        
        let xValues = ChartAxisValuesGenerator.generateXAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 10, maxSegmentCount: MaxDays, multiple: 1, axisValueGenerator: {ChartAxisValueFloat($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: true)
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 10, maxSegmentCount: 20, multiple: 1, axisValueGenerator: {ChartAxisValueFloat($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: true)
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues)
        
        let scrollViewFrame = ExamplesDefaults.chartFrame(self.bounds)
        let chartFrame = CGRectMake(0, 0, CGFloat(chartFrameWidth), scrollViewFrame.size.height)
        
        // calculate coords space in the background to keep UI smooth
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            
//            dispatch_async(dispatch_get_main_queue()) {
                let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
                let lineModelArr = map(enumerate(chartPointsArr)) { (index, chartPoints) in
                    return ChartLineModel(chartPoints: chartPoints, lineColor: chartLineColorArr[index], animDuration: 1, animDelay: 0)
                }
        
                let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: lineModelArr)
                
                var settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
                let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
                
                self.contentSize = CGSizeMake(chartFrame.size.width, chartFrame.size.height)
//            dispatch_async(dispatch_get_main_queue()) {                
                let chart = Chart(
                    frame: chartFrame,
                    layers: [
                        xAxis,
                        yAxis,
                        guidelinesLayer,
                        chartPointsLineLayer
                    ]
                )
                
                self.addSubview(chart.view)
                self.chart = chart
                
//            }
//        }
    }

    private func createChartPoint(x: CGFloat, _ y: CGFloat, _ labelSettings: ChartLabelSettings) -> ChartPoint {
        return ChartPoint(x: ChartAxisValueFloat(x, labelSettings: labelSettings), y: ChartAxisValueFloat(y))
    }
}
