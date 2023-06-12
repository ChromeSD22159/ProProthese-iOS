//
//  DoubleExtention.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 19.05.23.
//

import Foundation

extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
      let formatter = DateComponentsFormatter()
      formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
      formatter.unitsStyle = style
      return formatter.string(from: self) ?? ""
    }
}
