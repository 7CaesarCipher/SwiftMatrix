
//  MatrixViewModel.swift
//  MartixAssingment
//
//  Created by shashank Mishra on 23/01/24.
//

import Foundation
class MatrixViewModel {
    var hourData: [HourData]?

    func fetchDataFromJSONFile(fileName: String, completion: @escaping () -> Void) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("JSON file not found.")
            completion()
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            hourData = try decoder.decode([HourData].self, from: data)
            completion()
        } catch {
            print("Error reading or parsing JSON file: \(error)")
            completion()
        }
    }
}

