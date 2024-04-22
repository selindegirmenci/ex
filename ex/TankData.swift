//
//  TankData.swift
//  ex
//
//  Created by selindegirmenci on 3/28/24.
//

import Foundation
import SwiftUI
import GaugeKit
//import Highcharts
import SceneKit
import Charts


public struct Tank: Codable, Identifiable {
    
    public var id: Int?
    public var datetime: String
    public var Temperature: Double?
    public var Pressure: Double?
    public var Level: Double?
    public var engine_rpm: Double?
    public var voltage: Double?
    public var fanRPM: Double?
    
}

class ReadData: ObservableObject {
    @Published var tank: Tank?
    
    public var timer: Timer?
    // arrays for chart
    static var selectedArray = "Temperature"
    @Published var temperatureArray: [Double?] = []
    @Published var pressureArray: [Double?] = []
    @Published var levelArray: [Double?] = []
    @Published var enginerpmArray: [Double?] = []
    @Published var voltageArray: [Double?] = []
    @Published var fanArray: [Double?] = []
    
    init() {
        fetchData()
        // Schedule timer to fetch data every second
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.fetchData()
            //print("Fetching new data")
        }
    }
    
    public func fetchData() {
        guard let url = URL(string: "http://10.228.40.86/myWebService1/getLatestData.php") else {
            print("Invalid URL")
            return
        }
        let startTime = Date()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //let endTime = Date() // Record end time
            
            //let elapsedTime = endTime.timeIntervalSince(startTime) // Calculate elapsed time
            
            //print("Time to access php: \(elapsedTime)") // Print elapsed time
            do {
                if let tankData = data {
                    let decodedData = try JSONDecoder().decode(Tank.self, from: tankData)
                    
                    DispatchQueue.main.async {
                        //print("Dispatch - adding data to arrays")
                        self.tank = decodedData
                        //array stuff
                        if let temperaturex = decodedData.Temperature {
                            // Append temperature reading to the array
                            self.temperatureArray.append(temperaturex)
                            //print(temperaturex)
                            //print(ReadData.temperatureArray)
                        }
                        
                        if let pressurex = decodedData.Pressure {
                            // Append temperature reading to the array
                            self.pressureArray.append(pressurex)
                            //print(self.pressureArray)
                        }
                        
                        if let levelx = decodedData.Level {
                            // Append temperature reading to the array
                            self.levelArray.append(levelx)
                        }
                        
                        if let enginex = decodedData.engine_rpm {
                            // Append temperature reading to the array
                            self.enginerpmArray.append(enginex)
                        }
                        
                        if let voltagex = decodedData.voltage {
                            // Append temperature reading to the array
                            self.voltageArray.append(voltagex)
                        }
                        
                        if let fanx = decodedData.fanRPM {
                            // Append temperature reading to the array
                            self.fanArray.append(fanx)
                        }
                    }
                } else {
                    print("No data")
                }
                
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}


/////////// CONTENT VIEW
///
///
struct TabItem<Content: View>: View {
    let title: String
    let systemImage: String
    let content: Content

    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        content
            .tabItem {
                Label(title, systemImage: systemImage)
            }
    }
}

struct ContentView: View {

    var body: some View {
        TabView {
            TabItem(title: "Dashboard", systemImage: "house") {
                DashboardView()
            }
            
            TabItem(title: "Charts", systemImage: "chart.line.uptrend.xyaxis.circle.fill") {
                CompleteContentView()
            }
            TabItem(title: "QR Scanner", systemImage: "qrcode.viewfinder") {
                ScannerView()
            }
            
            TabItem(title: "Documentation", systemImage: "doc.viewfinder") {
                docContentView()
            }
            
            TabItem(title: "Network", systemImage: "network.badge.shield.half.filled") {
                NetworkView()
            }

        }
    }

}

struct DashboardView: View {
    @StateObject var fetch = ReadData()
    
    var body: some View {
        VStack {
            if let tank = fetch.tank {
                Home(tank: tank)
            } else {
                Text("Error Loading Data: Check Database Connection")
                    .onAppear {
                                    sendNotification()
                                }
                
            }
        }
  
    }
    func sendNotification() {
           let content = UNMutableNotificationContent()
           content.title = "Data Loading Error"
           content.body = "There was an error loading the data."
           
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
           let request = UNNotificationRequest(identifier: "DataLoadingError", content: content, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Error displaying notification: \(error.localizedDescription)")
               }
           }
       }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Data Model...

struct Model: Identifiable {
    var id: Int
    var name: String
    var modelName: String
    var details: String
}



// Home View...

struct Home: View {

    var tank: Tank

    var body: some View {
        VStack {
            Text("Generator 5 SCADA Dashboard")
                .font(.title)
                .fontWeight(.heavy)
                .padding()

            Spacer()

            HStack {
                // Left side
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 175, height: 150)
                        .overlay(
                            VStack(spacing: 40) {
                                HStack(alignment: .top) {
                                    Image(systemName: "thermometer")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25) // Adjust size of icon
                                    Text("Temperature")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                if let temperature = tank.Temperature{
                                    Text("\(temperature)°C")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.title2)
                            
                                }
                            }
                        
                        )
                        .padding(.vertical, 20)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 175, height: 150)
                        .overlay(
                            VStack(spacing: 40) {
                                HStack(alignment: .top) {
                                    Image(systemName: "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25) // Adjust size of icon
                                    Text("Pressure")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                if let pressure = tank.Pressure{
                                    Text("\(pressure) psi")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.title2)
                                }}
                    
                        )
                        .padding(.vertical, 20)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.red]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 175, height: 150)
                        .overlay(
                            VStack(spacing: 40){
                                HStack(alignment: .top) {
                                    Image(systemName: "fuelpump.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25) // Adjust size of icon
                                    Text("Fuel Level")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                if let level = tank.Level {
                                    Text("\(level)%")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.title2)
                                }}
                        )
                }

                // 3D model
                var scene = SCNScene(named: "Turbo-_Generator_1986.usdz")
                ZStack{
                    SceneView(scene: scene, options: [.autoenablesDefaultLighting, .allowsCameraControl])
                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                    let _ = scene?.background.contents = UIColor.black
                }
                

                // Right side
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 175, height: 150)
                        .overlay(
                            VStack(spacing: 40){
                                HStack(alignment: .top) {
                                    Image(systemName: "engine.combustion")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25) // Adjust size of icon
                                    Text("Engine RPM")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                if let engineRpm = tank.engine_rpm {
                                    Text("\(engineRpm) RPM")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.title2)
                                }}
                               
                        )
                        .padding(.vertical, 20)
                    
                
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 175, height: 150)
                        .overlay(
                            VStack(spacing: 40){
                                HStack(alignment: .top) {
                                    Image(systemName: "bolt.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25) // Adjust size of icon
                                    Text("Voltage")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                if let voltage = tank.voltage {
                                    Text("\(voltage) V")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.title2)
                                }}
                        )
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 175, height: 150)
                        .overlay(
                            VStack(spacing: 40){
                                HStack(alignment: .top) {
                                    Image(systemName: "fanblades.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25, height: 25) // Adjust size of icon
                                    Text("Fan RPM")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                if let fanRpm = tank.fanRPM {
                                    Text("\(fanRpm) RPM")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.title2)
                                }}
                            )
                        .padding(.vertical, 20)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}


///// :(

/*
struct lmaosContentView: View {
    @State private var data: [(Date, Double)] = []
    @State private var index = 0
    @State private var timer: Timer?
    @StateObject var readData = ReadData()
    
    var body: some View {
        VStack {
            Chart {
                ForEach(data, id: \.0) { point in
                    LineMark(
                        x: .value("Time", point.0),
                        y: .value("Value", point.1)
                    )
                    .foregroundStyle(Color.blue)
                    .interpolationMethod(.cardinal)
                    .symbol {
                                            Circle()
                            .fill(Color.blue)
                                                .frame(width: 12, height: 12)
                                
                                        }
                }
            }

            .frame(height: 300)
            .padding()
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                addPoint()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func addPoint() {
        let currentTime = Date()
        let yValue = Double(readData.voltageArray[index] ?? -1)
        data.append((currentTime, yValue))
        
        index = (index + 1) % readData.voltageArray.count
        

        if data.count > 20 {
            data.removeFirst()
        }
    }
}

struct lmaosContentView_Previews: PreviewProvider {
    static var previews: some View {
        lmaosContentView()
    }
} */



struct ReadingChartView: View {
    
    @State private var data: [(String, Double?)]
    @State private var test: [Double?]
    @State private var index = 0
    @State private var timer: Timer?
    @ObservedObject var readData = ReadData()
    static var currentArray = ""
    
    var title: String
    var yAxisLabel: String
    
    init(title: String, yAxisLabel: String, testData: [Double?]) {
        self.title = title
        //ReadData.selectedArray = title
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
        
        //@StateObject var readData = ReadData()
        if(ReadingChartView.currentArray != ReadData.selectedArray){
            index = 0;
            ReadingChartView.currentArray = ReadData.selectedArray
            print("Reset Index")
        }
        if(ReadData.selectedArray == "Temperature"){
            self.test = readData.temperatureArray
            if(self.test.count == 0){
                self.test = [0.0]
            }
        }
        else if(ReadData.selectedArray == "Pressure"){
            self.test = readData.pressureArray
            if(self.test.count == 0){
                self.test = [0.0]
            }
        }
        else if(ReadData.selectedArray == "Voltage") {
            
            self.test = readData.voltageArray
            if(self.test.count == 0){
                self.test = [0.0]
            }
        }
        
        else if(ReadData.selectedArray == "Fan RPM") {
            
            self.test = readData.fanArray
            if(self.test.count == 0){
                self.test = [0.0]
            }
        }
        
        else if(ReadData.selectedArray == "Fuel Level") {
            
            self.test = readData.levelArray
            if(self.test.count == 0){
                self.test = [0.0]
            }
        }
        
        else if(ReadData.selectedArray == "Engine RPM") {
            
            self.test = readData.enginerpmArray
            if(self.test.count == 0){
                self.test = [0.0]
            }
        }
        
         
        //print(ReadData.selectedArray)
        //print(ReadingChartView.)
        let currentTime = Date.now.formatted(date: .omitted, time: .standard)
        print(index)
        print(test.count)
        let yValue = Double(test[index] ?? -1)
        data.append((currentTime, yValue))
        index = (index + 1) % test.count
        
        // fixed number of points in the chart
        if data.count > 10 {
            data.removeFirst()
        }
        //print(data)
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
    
    @ObservedObject var readData = ReadData()
    @State private var selectedTab: String = "Temperature"
 
    var body: some View {
        // create a tab bar
        TabView(selection: $selectedTab) {
            //tabs for each reading
            ReadingChartView(
                title: "Temperature",
                yAxisLabel: "Temperature",
                testData: readData.temperatureArray
            )
            .tabItem {
                Text("Temperature")
            }
            .tag("Temperature")
            
            ReadingChartView(
                title: "Pressure",
                yAxisLabel: "Pressure",
                testData: readData.pressureArray // completepressureData
            )
            .tabItem {
                Text("Pressure")
            }
            .tag("Pressure")
            
            ReadingChartView(
                title: "Voltage",
                yAxisLabel: "Voltage",
                testData: readData.voltageArray //completevoltageData
            )
            .tabItem {
                Text("Voltage")
            }
            .tag("Voltage")
            
            ReadingChartView(
                title: "Fan RPM",
                yAxisLabel: "Fan RPM",
                testData: readData.fanArray //completefanRpmData
            )
            .tabItem {
                Text("Fan RPM")
            }
            .tag("Fan RPM")
            
            ReadingChartView(
                title: "Engine RPM",
                yAxisLabel: "Engine RPM",
                testData: readData.enginerpmArray //completeengineRpmData
            )
            .tabItem {
                Text("Engine RPM")
            }
            .tag("Engine RPM")
            
            ReadingChartView(
                title: "Fuel Level",
                yAxisLabel: "Fuel Level",
                testData: readData.levelArray //completefuelLevelData
            )
            .tabItem {
                Text("Fuel Level")
            }
            .tag("Fuel Level")
        }
        .frame(width: 950, height: 600)
        .onChange(of: selectedTab){ newValue in
            print("selected Tab: \(newValue)")
            ReadData.selectedArray = newValue
        }
    }
}
/*

struct CompleteContentView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteContentView()
    }
} */
 
