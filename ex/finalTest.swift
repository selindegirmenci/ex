import Highcharts
import UIKit
import SwiftUI
import Charts

/*
struct ReadingChartView: View {
    
    @State private var data: [(String, Double?)]
    @State private var test: [Double?]
    @State private var index = 0
    @State private var timer: Timer?
    
    
    var title: String
    var yAxisLabel: String
    
    init(title: String, yAxisLabel: String, testData: [Double?]) {
        self.title = title
        self.yAxisLabel = yAxisLabel
        self.test = testData
        self.data = []
    }
    
    var body: some View {
        VStack {
            ZStack {
                // background
                Rectangle()
                    .fill(Color(red: 1.0, green: 0.98, blue: 0.9))
                    .frame(width: 950, height: 550)
                
                VStack {
                    // chart title
                    Text("\(title) Reading")
                        .font(.title)
                        .padding(.bottom, 10)
                        .foregroundStyle(Color.black)
                    
                    HStack {
                        // y-axis label
                        Text(yAxisLabel)
                            .rotationEffect(.degrees(-90))
                            .font(.system(size: 17))
                            .padding(.trailing, 10)
                            .foregroundStyle(Color.black)
                        
                        VStack {
                            // actual chart
                            Chart {
                                ForEach(data, id: \.0) { point in
                                    LineMark(
                                        x: .value("Time", point.0),
                                        y: .value("Value", point.1 ?? -1)
                                    )
                                    .foregroundStyle(Color.blue)
                                    .interpolationMethod(.cardinal)
                                    .symbol {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 12, height: 12)
                                            .overlay {
                                                // point.1 for the y-value of the data point
                                                Text("\(point.1 ?? -1, specifier: "%.2f")")
                                                    .frame(width: 50)
                                                    .font(.system(size: 12, weight: .medium))
                                                    .offset(y: -15)
                                            }
                                    }
                                }
                            }
                            .chartYAxis {
                                AxisMarks { value in
                                    AxisValueLabel {
                                        Text("\(value.as(Double.self) ?? -1, specifier: "%.2f")")
                                            .font(.system(size: 12))
                                            .foregroundStyle(Color.black)
                                    }
                                    AxisGridLine()
                                        .foregroundStyle(Color.black.opacity(1))
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: data.map { $0.0 }) { value in
                                    AxisGridLine()
                                        .foregroundStyle(Color.black.opacity(1))
                                }
                                AxisMarks { value in
                                    AxisValueLabel {
                                        let timeString = value.as(String.self) ?? ""
                                        Text(timeString)
                                            .font(.system(size: 10))
                                            .foregroundStyle(Color.black)
                                    }
                                }
                            }
                            .frame(width: 800, height: 400)
                            .padding()
                            
                            // x-axis label
                            Text("Time")
                                .font(.system(size: 18))
                                .padding(.top, 10)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
        }
        .onAppear {
            // interval timer when the view appears
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                addPoint()
            }
        }
        .onDisappear {
            // invalidate the timer when the view disappears
            timer?.invalidate()
        }
    }
    
    func addPoint() {
        let currentTime = Date.now.formatted(date: .omitted, time: .standard)
        let yValue = Double(test[index] ?? -1)
        data.append((currentTime, yValue))
        index = (index + 1) % test.count
        
        // fixed number of points in the chart
        if data.count > 10 {
            data.removeFirst()
        }
    }
}

struct CompleteContentView: View {
    //  data arrays for each reading
    /*
    @State private var completetemperatureData = [10.9, 20.2, 15.1, 42.9, 54.4, 9.1, 7.3, 80.4, 124.2, 25.34, 235.23, 32.23, 32.1, 32.9, 20.4, 56.4, 87.6]
    @State private var completepressureData = [101.5, 102.3, 103.1, 104.8, 105.5, 106.34, 107.36, 108.6, 109.76, 110.98, 111.1, 112.2, 113.5]
    @State private var completevoltageData = [12.54, 11.35, 13.78, 14.34, 12.78, 11.98, 13.01, 14.02, 13.56, 12.3, 14.2, 13.6, 11.1]
    @State private var completefanRpmData = [1500.56, 1450.2, 1550.1, 1520.8, 1480.23, 1470.33, 1540.56, 1560.1, 1530.9, 1510.1, 1490.54]
    @State private var completeengineRpmData = [3000.00, 3100.00, 3200.00, 2900.00, 2950.00, 3050.00, 3100.00, 3250.00, 3350.00, 3400.00]
    @State private var completefuelLevelData = [1.00, 0.00, 1.00, 0.00, 0.00, 1.00, 0.00, 1.00] */
    
    @StateObject var readData = ReadData()
 
    var body: some View {
        // create a tab bar
        TabView {
            //tabs for each reading
            ReadingChartView(
                title: "Temperature",
                yAxisLabel: "Temperature",
                testData: readData.temperatureArray
            )
            .tabItem {
                Text("Temperature")
            }
            
            ReadingChartView(
                title: "Pressure",
                yAxisLabel: "Pressure",
                testData: readData.pressureArray // completepressureData
            )
            .tabItem {
                Text("Pressure")
            }
            
            ReadingChartView(
                title: "Voltage",
                yAxisLabel: "Voltage",
                testData: readData.voltageArray //completevoltageData
            )
            .tabItem {
                Text("Voltage")
            }
            
            ReadingChartView(
                title: "Fan RPM",
                yAxisLabel: "Fan RPM",
                testData: readData.fanArray //completefanRpmData
            )
            .tabItem {
                Text("Fan RPM")
            }
            
            ReadingChartView(
                title: "Engine RPM",
                yAxisLabel: "Engine RPM",
                testData: readData.enginerpmArray //completeengineRpmData
            )
            .tabItem {
                Text("Engine RPM")
            }
            
            ReadingChartView(
                title: "Fuel Level",
                yAxisLabel: "Fuel Level",
                testData: readData.levelArray //completefuelLevelData
            )
            .tabItem {
                Text("Fuel Level")
            }
        }
        .frame(width: 950, height: 600)
    }
}


struct CompleteContentView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteContentView()
    }
} */
 
