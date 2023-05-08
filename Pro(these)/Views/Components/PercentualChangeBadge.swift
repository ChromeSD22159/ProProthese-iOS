//
//  PercentualChangeBadge.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 08.05.23.
//

import SwiftUI

struct PercentualChangeBadge: View {
    var final: Double
    var initial: Double
    var type: String
    private var image: String {
        if final > initial {
            return "arrow.up.right.circle"
        } else if final == initial {
            return "arrow.right.circle"
        } else {
            return "arrow.down.right.circle"
        }
    }
    
    private var sign: String {
        if final > initial {
            return "+"
        } else if final == initial {
            return ""
        } else {
            return ""
        }
    }
    
    private var backgroundColor: Color {
        if final > initial {
            return .green
        } else if final == initial {
            return .yellow
        } else {
            return .red
        }
    }
    
    private var foregroundColor: Color {
        if final > initial {
            return .black
        } else if final == initial {
            return .black
        } else {
            return .white
        }
    }
    
    private var output: String {
        let change: Double = (final - initial) / initial
        print("f: \(final) i: \(initial)")
        return String(format: "%.1f", change * 100)
    }
    
    var body: some View {
        if type == "small" {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
                Text("\(sign + output)%")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(backgroundColor)
        }
        
        if type == "normal" {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
                Text("\(sign + output)%")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(20)
        }
           
    }
}

struct PercentualChangeBadge_Previews: PreviewProvider {
    static var previews: some View {
        PercentualChangeBadge(final: 10, initial: 100, type: "normal")
    }
}
