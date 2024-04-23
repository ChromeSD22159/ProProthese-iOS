//
//  Spiderdiagram.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 09.10.23.
//

import SwiftUI
import Foundation


enum RayCase: LocalizedStringKey, CaseIterable {
    case Steps = "Steps"
    case Weather = "Weather"
    case TemperatureC = "°C"
    case TemperatureF = "°F"
    case Pressure = "Air pressure"
    case Times = "Times of Day"
}
 
struct Ray:Identifiable {
    var id = UUID()
    var name: LocalizedStringKey
    var maxVal:Double
    var rayCase:RayCase
    init(maxVal:Double, rayCase:RayCase) {
        self.rayCase = rayCase
        self.name = rayCase.rawValue
        self.maxVal = maxVal
        
    }
}



struct RadarChartView: View {
    
    var MainColor:Color
    var SubtleColor:Color
    var LabelColor:Color
    var center:CGPoint
    var labelWidth:CGFloat = 70
    var width:CGFloat
    var quantity_incrementalDividers:Int
    var dimensions:[Ray]
    var data:[DataPoint]
    
    init(width: CGFloat, MainColor:Color, SubtleColor:Color, LabelColor:Color? = nil, quantity_incrementalDividers:Int, dimensions:[Ray], data:[DataPoint]) {
        self.width = width
        self.center = CGPoint(x: width/2, y: width/2)
        self.MainColor = MainColor
        self.SubtleColor = SubtleColor
        self.LabelColor = LabelColor ?? SubtleColor
        self.quantity_incrementalDividers = quantity_incrementalDividers
        self.dimensions = dimensions
        self.data = data
    }
    
    var body: some View { 
        ZStack{
            //Main Spokes
            Path { path in
                
                
                for i in 0..<self.dimensions.count {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                }
                
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            //Labels
            //ForEach(0..<self.dimensions.count){i in
            ForEach(self.dimensions.indices, id: \.self) { i in
                
                Text(self.dimensions[i].rayCase.rawValue)
                    .font(.system(size: 10))
                    .foregroundColor(self.LabelColor)
                    .frame(width:self.labelWidth, height:10)
                    .rotationEffect(.degrees(
                        (degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) > 90 && degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) < 270) ? 180 : 0
                    ))
                
                
                    .background(Color.clear)
                    .offset(x: (self.width - (50))/2)
                    .rotationEffect(.radians(
                        Double( radAngle_fromFraction(numerator: i, denominator: self.dimensions.count) )
                    ))
            }
            //Outer Border
            Path { path in
                
                for i in 0..<self.dimensions.count + 1 {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    if i == 0 {
                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                    }
                }
                
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            //Incremental Dividers
            ForEach(0..<self.quantity_incrementalDividers, id: \.self ){ j in
                Path { path in
                    
                    
                    for i in 0..<self.dimensions.count + 1 {
                        let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(j + 1)/CGFloat(self.quantity_incrementalDividers + 1))
                        
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        //print(size)
                        //print((self.width - (50 + self.labelWidth)))
                        //print("\(x) -- \(y)")
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                        
                    }
                    
                }
                .stroke(self.SubtleColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                
                
            }
            
            //Data Polygons
            ForEach(0..<self.data.count, id: \.self) { j -> AnyView in
                //Create the path
                let path = Path { path in
                    
                    
                    for i in 0..<self.dimensions.count + 1 {
                        let thisDimension = self.dimensions[i == self.dimensions.count ? 0 : i]
                        let maxVal = thisDimension.maxVal
                        let dataPointVal:Double = {
                            
                            for DataPointRay in self.data[j].entrys {
                                if thisDimension.rayCase == DataPointRay.rayCase {
                                    return DataPointRay.value
                                }
                            }
                            
                            return 0
                        }()
                        let angle = radAngle_fromFraction(numerator: i == self.dimensions.count ? 0 : i, denominator: self.dimensions.count)
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(dataPointVal)/CGFloat(maxVal))
                        
                        
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                        
                    }
                    
                }
                //Stroke and Fill
                return AnyView(
                    ZStack{
                        path
                            .stroke(self.data[j].color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        path
                            .foregroundColor(self.data[j].color).opacity(0.2)
                    }
                )
                
                
            }
            
        }.frame(width:width, height:width)
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }
    
    func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
        return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)))
    }
    
    func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
        return 360 * (CGFloat((numerator))/CGFloat(denominator))
        
    }
}

struct DataPoint:Identifiable {
    var id = UUID()
    var entrys:[RayEntry]
    var color:Color
    
    init(Steps:Double, Weather:Double, TemperatureC:Double, TemperatureF:Double, Pressure:Double, Times:Double, color:Color){
        var e:[RayEntry] = []
        
        e.append(RayEntry(rayCase: .Weather, value: Weather))
        e.append(RayEntry(rayCase: .Steps, value: Steps))
        
        if AppConfig.shared.WidgetContentTemp == .c {
            e.append(RayEntry(rayCase: .TemperatureC, value: TemperatureC))
        } else {
            e.append(RayEntry(rayCase: .TemperatureF, value: TemperatureF))
        }
        
        e.append(RayEntry(rayCase: .Pressure, value: Pressure))
        e.append(RayEntry(rayCase: .Times, value: Times))
        
        self.entrys = e
        
        self.color = color
    }
}

struct RayEntry{
    var rayCase:RayCase
    var value:Double
}
