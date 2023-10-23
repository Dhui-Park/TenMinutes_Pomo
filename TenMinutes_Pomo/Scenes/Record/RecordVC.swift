//
//  Record.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/10.
//

import Foundation
import UIKit
import DGCharts


class RecordVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var sliderX: UISlider!
    
    @IBOutlet weak var sliderY: UISlider!
    
    var shouldHideData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        
//        RecordRepository.shared.fetchRecordItem(id: <#T##ObjectId#>)
        
        barChartView.chartDescription.enabled = false
        barChartView.maxVisibleCount = 60
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        
        barChartView.legend.enabled = false
        
        sliderX.value = 10
        sliderY.value = 100
        
        
//        self.slidersValueChanged(nil)
        
        updateChartData()
        
    }
    
    func updateChartData() {
        if self.shouldHideData {
            barChartView.data = nil
            return
        }
        
        self.setDataCount(Int(sliderX.value) + 1, range: Double(sliderY.value))
    }
    
    func setDataCount(_ count: Int, range: Double) {
        print(#fileID, #function, #line, "- <#comment#>")
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(UInt32(mult))) + mult/3
            return BarChartDataEntry(x: Double(i), y: val)
        }
        
        var set1: BarChartDataSet! = nil
        if let set = barChartView.data?.first as? BarChartDataSet {
            set1 = set
            set1?.replaceEntries(yVals)
            barChartView.data?.notifyDataChanged()
            barChartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "Data Set")
            set1.colors = ChartColorTemplates.vordiplom()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            barChartView.data = data
            barChartView.fitBars = true
        }
        
        barChartView.setNeedsDisplay()
    }
}
