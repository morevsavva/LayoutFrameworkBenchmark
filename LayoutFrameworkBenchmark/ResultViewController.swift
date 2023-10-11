//
//  ResultViewController.swift
//  LayoutFrameworkBenchmark
//
//  Created by Savva Morev on 11.10.2023.
//

import Foundation
import SwiftUI

import Charts
struct PerfStat: Identifiable {
     let library: String
     let time: Double
     var id: String { library }
}
//let data: [Profit] = [
//    Profit(department: "Production", profit: 15000),
//    Profit(department: "Marketing", profit: 8000),
//    Profit(department: "Finance", profit: 10000)
//]
struct BarChart: View {
  let data: [PerfStat]
    var body: some View {
      if #available(iOS 16.0, *) {
        Chart(data) {
          BarMark(
            x: .value("Library", $0.library),
            y: .value("Time", $0.time)
          ).foregroundStyle(by: .value("Library", $0.library))
        }.frame(width: 300, height: 200)

      } else {
        Spacer()
      }
    }
}


