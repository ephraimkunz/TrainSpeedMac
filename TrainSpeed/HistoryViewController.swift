//
//  HistoryViewController.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/14/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Cocoa
import Charts
import RealmSwift

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
        let dataEntries = xyVals.yDataEntries
        let dataset = LineChartDataSet(values: dataEntries, label: "Speed")
        dataset.setCircleColor(NSUIColor.red)
        dataset.setColor(NSUIColor.red)
        let data = LineChartData();
        
        //With an empty dataset iOS Charts will attempt to get elements, and throw exceptions when there are none.
        //So we must not provide a dataset if that is the case.
        if(!dataEntries.isEmpty){
            data.addDataSet(dataset)

        }
        
        // Get the x axis labels to display properly
        let xAxis = XAxis()
        let formatter = LineChartFormatter()
        formatter.setValues(xyVals.xVals)
        
        xAxis.valueFormatter = formatter
        
        self.lineChartView.data = data
        self.lineChartView.xAxis.valueFormatter = xAxis.valueFormatter
    }
    
    func getChartXYVals() -> XYVals{
        let results = DataSource().readForId(vehicleId!)
        
        var dataEntries: Array<ChartDataEntry> = []
        var xVals: Array<String> = []
        for i in 0..<results.count{
            let chartDataEntry = ChartDataEntry(x:Double(i), y: results[i].speed)
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
        invalidateAndAnimateChart()
    }
    
    func invalidateAndAnimateChart(){
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}

/**
 Implements the IAxisValueFormatter protocol so we can supply custom x axis labels
 */
class LineChartFormatter: NSObject, IAxisValueFormatter{
    var names = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return names[Int(value)]
    }
    
    public func setValues(_ values: [String])
    {
        self.names = values
    }
}
