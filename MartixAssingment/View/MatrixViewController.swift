//
//  MatrixViewController.swift
//  MartixAssingment
//
//  Created by shashank Mishra on 23/01/24.
//
import UIKit
import DPCharts

class MatrixViewController: UIViewController {

    let viewModel = MatrixViewModel()
    var heatmapView: DPHeatMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        heatmapView = DPHeatMapView()
        heatmapView.translatesAutoresizingMaskIntoConstraints = false
        let xAxisLabel = UILabel()
            xAxisLabel.translatesAutoresizingMaskIntoConstraints = false
            xAxisLabel.text = "Hours"
        xAxisLabel.textColor = .gray
        xAxisLabel.font = .systemFont(ofSize: 8)
            view.addSubview(xAxisLabel)

        view.addSubview(heatmapView)
        NSLayoutConstraint.activate([
              xAxisLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 229),
              
          ])

   
        NSLayoutConstraint.activate([
            heatmapView.leadingAnchor.constraint(equalTo: xAxisLabel.leadingAnchor),

            heatmapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heatmapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            heatmapView.widthAnchor.constraint(equalToConstant: 380), // Set a fixed width (adjust as needed)
            heatmapView.heightAnchor.constraint(equalToConstant: 280) // Set a fixed height (adjust as needed)
        ])

        heatmapView.datasource = self
        viewModel.fetchDataFromJSONFile(fileName: "JsonData") { [weak self] in
            DispatchQueue.main.async {
                self?.heatmapView.reloadData()
            }
        }
    }
}

extension MatrixViewController: DPHeatMapViewDataSource {
    func numberOfColumns(_ heatmapView: DPHeatMapView) -> Int {
        if let hourData = viewModel.hourData, let firstHourData = hourData.first {
            return firstHourData.hours.count
        }
        return 0
    }
    
    func numberOfRows(_ heatmapView: DPHeatMapView) -> Int {
        return viewModel.hourData?.count ?? 0
    }
    func heatMapView(_ heatMapView: DPHeatMapView, colorForValueAtRow rowIndex: Int, column columnIndex: Int) -> UIColor {
        guard let hourData = viewModel.hourData, rowIndex < hourData.count else {
            return .clear
        }
        
        let rowData = hourData[rowIndex]
        guard columnIndex < rowData.hours.count else {
            return .clear
        }
        
        let recordCount = rowData.hours[columnIndex].record_count
        
        let maxCount: CGFloat = 1000.0 // Maximum record count (assumed)
        let opacity = CGFloat(recordCount) / maxCount
        
       
        let validOpacity = max(0.0, min(1.0, opacity))
      
        return recordCount > 0 ? UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: validOpacity) : .gray
    }
    func heatMapView(_ heatMapView: DPHeatMapView, valueForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> CGFloat {
          
           if let hourData = viewModel.hourData, rowIndex < hourData.count {
               let rowData = hourData[rowIndex]
               if columnIndex < rowData.hours.count {
                   let recordCount = CGFloat(rowData.hours[columnIndex].record_count)
                   
                   let scaleFactor: CGFloat = 0.01 // Example scaling factor
                   return recordCount * scaleFactor
               }
           }
           return 0
       }
    func heatMapView(_ heatMapView: DPHeatMapView, xAxisLabelForColumnAtIndex columnIndex: Int) -> String? {
        return "\(columnIndex)"
    }
    
    func heatMapView(_ heatMapView: DPHeatMapView, yAxisLabelForRowAtIndex rowIndex: Int) -> String? {
        if let hourData = viewModel.hourData, rowIndex < hourData.count {
            let rowData = hourData[rowIndex]
            let dayString = rowData.day
            let day = dayString.dropFirst(6)
            return String(day)
        }
        return nil
    }
}
