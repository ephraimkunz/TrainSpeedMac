//
//  HistoryViewController.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/14/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Cocoa
import Charts
//import RealmSwift

class HistoryViewController : NSViewController{
    
    @IBOutlet weak var lineChartView: LineChartView!
    var vehicleId: String?
    
    @IBAction func clearHistoryClicked(_ sender: AnyObject) {
        DataSource().removeFromRealm(vehicleId!)
        setChartData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.xAxis.labelRotationAngle = -90
        self.lineChartView.chartDescription?.text = "Speed vs Time for Train \(vehicleId!)"
        setChartData()
    }
    
    func setChartData() -> Void{
        let xyVals = getChartXYVals()
        let dataEntries: [ChartDataEntry] = xyVals.yDataEntries
        let dataset = LineChartDataSet(values: dataEntries, label: "Speed")
        
        dataset.setCircleColor(NSUIColor.red)
        dataset.setColor(NSUIColor.red)
        
        let data = LineChartData(dataSet: dataset)
        self.lineChartView.data = data
    }
    
    func getChartXYVals() -> XYVals{
        let results = DataSource().readForId(vehicleId!)
        
        var dataEntries: Array<ChartDataEntry> = []
        var xVals: Array<String> = []
        for i in 0..<results.count{
            let chartDataEntry = ChartDataEntry(x: results[i].speed, y: Double(i))
            dataEntries.append(chartDataEntry)
            xVals.append(getGraphDateString(results[i].timestamp))
        }
        return XYVals(yDataEntries: dataEntries, xVals: xVals)
        
    }
    
    func getGraphDateString(_ date: Date) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        return formatter.string(from: date)
    }
    
    override internal func viewWillAppear()
    {
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}
