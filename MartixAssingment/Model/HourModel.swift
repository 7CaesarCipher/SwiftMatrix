//
//  HourModel.swift
//  MartixAssingment
//
//  Created by shashank Mishra on 23/01/24.
//
import Foundation
struct Hour: Decodable {
    let hour: String
    let record_count: Int
}

struct HourData: Decodable {
    let hours: [Hour]
    let day: String
}
