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
    var text: String?
    var color: (Color, Color)?
    var type: PercentualChangeBadgeType
    
    init(color: (Color, Color) = (Color.red, Color.green), final: Double, initial: Double, text: String? = nil, type: PercentualChangeBadgeType) {
        self.final = final
        self.initial = initial
        self.text = text
        self.type = type
        self.color = color
    }
    
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
            return color!.1
        } else if final == initial {
            return .yellow
        } else {
            return color!.0
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
        return String(format: "%.1f", change * 100)
    }
    
    var body: some View {
        if type == .ColoredIcon {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
            }
            .foregroundColor(backgroundColor)
        }
        
        if type == .ColoredTextPercentual {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
                Text("\(sign + output)%")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(backgroundColor)
        }
        
        if type == .ColoredTextSignSum {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
                Text( (text ?? "") )
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(backgroundColor)
        }
        
        if type == .ColoredText {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
                Text("\(text!)")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(backgroundColor)
        }
        
        if type == .ColoredBackgroundPercentual {
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
        
        if type == .ColoredBackgroundWithText {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: image )
                    .font(.callout)
                Text("\(text ?? "")")
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

enum PercentualChangeBadgeType: Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case ColoredIcon
    case ColoredTextPercentual
    case ColoredText
    case ColoredTextSignSum
    case ColoredBackgroundPercentual
    case ColoredBackgroundWithText
}

struct PercentualChangeBadge_Previews: PreviewProvider {
    static var previews: some View {
        PercentualChangeBadge(final: 10, initial: 100, type: .ColoredBackgroundWithText)
    }
}
