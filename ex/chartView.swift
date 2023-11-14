//
//  chartView.swift
//  ex
//
//  Created by selindegirmenci on 10/25/23.
//

import Foundation
import SwiftUI
import SwiftUICharts
import Charts


/*
struct ChartView: View {
    
    var body: some View {
        VStack {
            Text("Chart Readings")
                .font(.title)
                .padding()
            
            Spacer() // Push the content to the top
            
            HStack {
                Spacer() // Push the content to the left
                LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Pressure")
                    .frame(height: 200)
                    .padding()
                LineChartView(data: [123,23,943,32,132,137,76,93,53], title: "Temperature")
                    .frame(height: 200)
                Spacer() // Push the content to the right
            }
            
            
            Spacer() // Push the content to the bottom
        }
    }
    
} */
     /*@State  var temperatureValue: Int = 0
    @State  var pressureValue: Int = 0
    @State  var voltageValue: Int = 0
    @State  var fuelLevelValue: Int = 0
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Generator 5 Realtime Diagnostics")
                .font(.title)
                .padding()
            Spacer()

            HStack {
                Spacer()
                VStack {
                    Text("Temperature") */
                    
                    
/*
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
} */

/*
struct ChartView: View {
   @State  var temperatureValue: Int = 0
   @State  var pressureValue: Int = 0
   @State  var voltageValue: Int = 0
   @State  var fuelLevelValue: Int = 0
   @State private var currentIndex = 0
   var tankdata = loadCSVData()
   let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Temperature Monitor")
                .font(.largeTitle)
                .foregroundColor(.primary)
            Chart {
                LineMark(x: )
                
            }
            .onReceive(timer) { _ in
                // Update temperature and pressure values from the loaded CSV data
                            if currentIndex < tankdata.count {
                                let data = tankdata[currentIndex]
                                temperatureValue = data.temperatureValue
                                pressureValue = data.pressureValue
                                voltageValue = data.voltageValue
                                fuelLevelValue = data.fuelLevelValue
                                currentIndex = (currentIndex + 1) % tankdata.count // Move to the next row, looping back to the beginning if it reaches the end
                            }
            }
        }
    }
}
*/

/*

struct ChartView: View {
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Temperature Monitor")
                .font(.largeTitle)
                .foregroundColor(.primary)

            LineChart(data: tankdata, currentValue: tankdata[currentIndex].temperatureValue)

            Spacer()
        }
        .onReceive(timer) { _ in
            if currentIndex < tankdata.count {
                currentIndex = (currentIndex + 1) % tankdata.count
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

struct LineChart: View {
    let data: [TankData]
    let currentValue: Int

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) / CGFloat(data.count - 1) * geometry.size.width
                    let y = CGFloat(point.temperatureValue) / CGFloat(data.max(by: { $0.temperatureValue < $1.temperatureValue })?.temperatureValue ?? 1) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .overlay(
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .position(x: CGFloat(data.count - 1) / CGFloat(data.count) * geometry.size.width, y: CGFloat(currentValue) / CGFloat(data.max(by: { $0.temperatureValue < $1.temperatureValue })?.temperatureValue ?? 1) * geometry.size.height)
            )
        }
        .frame(height: 200)
        .padding()
    }
} */

/*

struct LineChart: View {
    var data: [Int]
    var xLabels: [String]
    var yLabels: [String]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    ForEach(0..<xLabels.count, id: \.self) { index in
                        Text(xLabels[index])
                            .frame(width: geometry.size.width / CGFloat(xLabels.count))
                    }
                    Spacer()
                }

                Spacer()

                ZStack(alignment: .leading) {
                    // Grid Lines
                    ForEach(1..<yLabels.count, id: \.self) { index in
                        let y = CGFloat(index) / CGFloat(yLabels.count - 1) * geometry.size.height
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                    }

                    Path { path in
                        for (index, value) in data.enumerated() {
                            let x = CGFloat(index) / CGFloat(data.count - 1) * geometry.size.width
                            let y = CGFloat(value) / CGFloat(data.max() ?? 1) * geometry.size.height
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                    HStack {
                        Spacer()
                        ForEach(0..<yLabels.count, id: \.self) { index in
                            Text(yLabels[index])
                                .frame(height: geometry.size.height / CGFloat(yLabels.count))
                        }
                    }
                }
            }
        }
        .frame(height: 180)
    }
}





struct ChartView: View {
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var temperatureValues: [Int] = []
    @State private var pressureValues: [Int] = []
    @State private var voltageValues: [Int] = []
    @State private var fuelLevelValues: [Int] = []

    var body: some View {
        VStack {
            Text("Generator 5 SCADA Dashboard")
                .font(.title)
                .padding()
            Spacer()

            HStack {
                Spacer()
                VStack {
                    Text("Temperature Chart")
                    LineChart(data: temperatureValues, xLabels: ["Time"], yLabels: ["0", "50", "100", "150", "200", "250"])
                        .frame(height: 120)

                    /*
                    Text("Pressure Chart")
                    LineChart(data: pressureValues)
                        .frame(height: 120)

                    Text("Voltage Chart")
                    LineChart(data: voltageValues)
                        .frame(height: 120)

                    Text("Fuel Level Chart")
                    LineChart(data: fuelLevelValues)
                        .frame(height: 120) */
                }
                .padding()
                Spacer()
            }
            Spacer()
        }
        .onReceive(timer) { _ in
            if currentIndex < tankdata.count {
                let data = tankdata[currentIndex]
                temperatureValues.append(data.temperatureValue)
                pressureValues.append(data.pressureValue)
                voltageValues.append(data.voltageValue)
                fuelLevelValues.append(data.fuelLevelValue)

                currentIndex = (currentIndex + 1) % tankdata.count
            }
        }
    }
} */
/*
let dataList = [ "Temperature", "Pressure", "Voltage", "Fuel Level"]



struct LineChart: View {
    var data: [Int]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) / CGFloat(data.count - 1) * geometry.size.width
                    let y = CGFloat(value) / CGFloat(data.max() ?? 1) * geometry.size.height
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .frame(height: 120)
    }
}

struct ChartView: View {
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var temperatureValues: [Int] = []
    @State private var pressureValues: [Int] = []
    @State private var voltageValues: [Int] = []
    @State private var fuelLevelValues: [Int] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataList, id: \.self) { item in
                    NavigationLink(destination: Text(item)) {
                        getImageIcon(for: item)
                        Text(item)
                    } .padding()
                }
                .navigationTitle("Generator 5 Monitor")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

    
    func getImageIcon(for item: String) -> some View {
            // You can customize the images based on the item if needed
            let imageName: String
            switch item {
            case "Temperature":
                imageName = "thermometer"
            case "Pressure":
                imageName = "gauge"
            case "Voltage":
                imageName = "bolt.fill"
            case "Fuel Level":
                imageName = "fuelpump.fill"
            default:
                imageName = "circle" // Default image or placeholder
            }
            
            return Image(systemName: imageName)
        } */

struct ChartView: View {
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var temperatureValues: [Int] = []
    @State private var pressureValues: [Int] = []
    @State private var voltageValues: [Int] = []
    @State private var fuelLevelValues: [Int] = []

    var dataList = ["Temperature", "Pressure", "Voltage", "Fuel Level"]
    @State private var selectedReading: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("Generator 5 Charts")
                    .font(.title)
                    .padding()
                Spacer()

                HStack {
                    Spacer()
                    VStack {
                        NavigationLink(
                            destination: LineChartView(data: getChart(for: selectedReading ?? ""), title: selectedReading ?? ""),
                            isActive: .constant(selectedReading != nil),
                            label: {
                                EmptyView()
                            })
                            .hidden()

                        List {
                            ForEach(dataList, id: \.self) { item in
                                Button(action: {
                                    selectedReading = item
                                    updateChartData()
                                }) {
                                    HStack {
                                        getImageIcon(for: item)
                                        Text(item)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
            .onReceive(timer) { _ in
                updateChartData()
            }
            //.navigationBarTitle("Generator 5 Monitor", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func updateChartData() {
        if currentIndex < tankdata.count {
            let data = tankdata[currentIndex]
            temperatureValues.append(data.temperatureValue)
            pressureValues.append(data.pressureValue)
            voltageValues.append(data.voltageValue)
            fuelLevelValues.append(data.fuelLevelValue)

            currentIndex = (currentIndex + 1) % tankdata.count
        }
    }

    func getImageIcon(for item: String) -> some View {
        let imageName: String
        switch item {
        case "Temperature":
            imageName = "thermometer"
        case "Pressure":
            imageName = "gauge"
        case "Voltage":
            imageName = "bolt.fill"
        case "Fuel Level":
            imageName = "fuelpump.fill"
        default:
            imageName = "circle" // Default image or placeholder
        }

        return Image(systemName: imageName)
    }

    func getChart(for readingType: String) -> [Int] {
        switch readingType {
        case "Temperature":
            return temperatureValues
        case "Pressure":
            return pressureValues
        case "Voltage":
            return voltageValues
        case "Fuel Level":
            return fuelLevelValues
        default:
            return []
        }
    }
}

struct LineChartView: View {
    var data: [Int]
    var title: String

    var body: some View {
        VStack {
            Text("\(title) Reading")
                .font(.title)
                .padding()

            LineChart(data: data)
                .frame(width: 500, height: 300) // Adjust width and height as needed
                .padding()

            // Additional details or customization for the chart view
        }
    }
}

struct LineChart: View {
    var data: [Int]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid
                Path { path in
                    let yStep = geometry.size.height / CGFloat(data.count - 1)
                    for i in 0..<data.count {
                        let y = CGFloat(i) * yStep
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }

                    let xStep = geometry.size.width / CGFloat(data.count - 1)
                    for i in 0..<data.count {
                        let x = CGFloat(i) * xStep
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                }
                .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))

                // Line Chart
                Path { path in
                    for (index, value) in data.enumerated() {
                        let x = CGFloat(index) / CGFloat(data.count - 1) * geometry.size.width
                        let y = CGFloat(value) / CGFloat(data.max() ?? 1) * geometry.size.height
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
            .drawingGroup() // Improve performance for complex views
        }
        .frame(height: 200) // Adjust height as needed
    }
}




/*
struct ChartView: View {
    @State private var currentIndex = 0
    var tankdata = loadCSVData()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var temperatureValues: [Int] = []
    @State private var pressureValues: [Int] = []
    @State private var voltageValues: [Int] = []
    @State private var fuelLevelValues: [Int] = []

    var body: some View {
        VStack {
            Text("Generator 5 Readings")
                .font(.title)
                .padding()
            Spacer()

            HStack {
                Spacer()
                VStack {
                    Text("Temperature ")
                    LineChart(data: temperatureValues)
                        .frame(height: 120)

                    Text("Pressure ")
                    LineChart(data: pressureValues)
                        .frame(height: 120)

                    Text("Voltage")
                    LineChart(data: voltageValues)
                        .frame(height: 120)

                    Text("Fuel Level")
                    LineChart(data: fuelLevelValues)
                        .frame(height: 120)
                }
                .padding()
                Spacer()
            }
            Spacer()
        }
        .onReceive(timer) { _ in
            if currentIndex < tankdata.count {
                let data = tankdata[currentIndex]
                temperatureValues.append(data.temperatureValue)
                pressureValues.append(data.pressureValue)
                voltageValues.append(data.voltageValue)
                fuelLevelValues.append(data.fuelLevelValue)

                currentIndex = (currentIndex + 1) % tankdata.count
            }
        }
    }
} */







struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
