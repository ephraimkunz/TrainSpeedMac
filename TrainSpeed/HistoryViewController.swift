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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lineChartView.gridBackgroundColor = NSUIColor.whiteColor()
        self.lineChartView.xAxis.labelPosition = .Bottom
        self.lineChartView.xAxis.labelRotationAngle = -90
        self.lineChartView.descriptionText = "Speed vs Time for Train \(vehicleId!)"
        self.lineChartView.legend.drawInside = true
        setChartData()
        
    
    }
    
    func setChartData() -> Void{
        let xyVals = getChartXYVals()
        let dataEntries: [ChartDataEntry] = xyVals.yDataEntries
        let dataset = LineChartDataSet(yVals: dataEntries, label: "Speed")
        
        dataset.setCircleColor(NSUIColor.redColor())
        dataset.setColor(NSUIColor.redColor())
        
        let data = LineChartData(xVals: xyVals.xVals, dataSet: dataset)
        
        self.lineChartView.data = data
    }
    
    func getChartXYVals() -> XYVals{
        let realm = try! Realm()
        let predicate = NSPredicate(format: "vehicleRef = %@", vehicleId!)
        
        let results = realm.objects(VehicleDatapoint).filter(predicate).sorted("timestampRaw")
        
        var dataEntries: Array<ChartDataEntry> = []
        var xVals: Array<String> = []
        for i in 0..<results.count{
            let chartDataEntry = ChartDataEntry(value: results[i].speed, xIndex: i)
            dataEntries.append(chartDataEntry)
            xVals.append(getGraphDateString(results[i].timestamp))
        }
        return XYVals(yDataEntries: dataEntries, xVals: xVals)
        
    }
    
    func getGraphDateString(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return formatter.stringFromDate(date)
    }
    
    override internal func viewWillAppear()
    {
        self.lineChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
}