//
//  Record.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/10.
//

import Foundation
import UIKit
import DGCharts
import RealmSwift


class RecordVC: UIViewController, ChartViewDelegate {
    
    
    // vc
    @IBOutlet weak var barChartView: BarChartView!
    // vc
    @IBOutlet weak var sliderX: UISlider!
    // vc
    @IBOutlet weak var sliderY: UISlider!
    
    weak var axisFormatDelegate: AxisValueFormatter?
    
    // vm
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
        
        // vc
        sliderX.value = 10
        sliderY.value = 100
        
        self.axisFormatDelegate = self
        
//        self.slidersValueChanged(nil)
        
        updateChartWithData()
        
    }
    
    
    // vm
    func updateChartWithData() {
        var dataEntries: [BarChartDataEntry] = []
        let gritCounts = getGritCountsFromDatabase()

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Grit count")
        barChartView?.barData?.barWidth = 1
        let chartData = BarChartData(dataSet: chartDataSet)
        
        
        barChartView?.data = chartData
        let xAxis = barChartView?.xAxis
        xAxis?.valueFormatter = axisFormatDelegate
    }
    
    // vm
    func getGritCountsFromDatabase() -> Int {
      do {
        let realm = try Realm()
          return realm.objects(GritEntity.self).count
      } catch let error as NSError {
        fatalError(error.localizedDescription)
        }
    }
    
}

extension RecordVC: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
