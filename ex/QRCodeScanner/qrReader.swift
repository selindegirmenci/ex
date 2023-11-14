//
//  qrReader.swift
//  ex
//
//  Created by selindegirmenci on 10/23/23.
//

/*
 import Foundation
 import SwiftUI
 import AVFoundation
 
 
 
 struct QRView: View {
 @State var scanResult = "No QR code detected"
 
 var body: some View {
 ZStack(alignment: .bottom) {
 
 QRScanner(scanResult: $scanResult)
 Text(scanResult)
 .padding()
 .background(.black)
 .foregroundColor(.white)
 .padding(.bottom)
 }
 }
 
 }
 
 class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
 
 @Binding var scanResult: String
 
 init(_ scanResult: Binding<String>) {
 self._scanResult = scanResult
 }
 
 func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
 
 // Check if the metadataObjects array is not nil and it contains at least one object.
 if metadataObjects.count == 0 {
 scanResult = "No QR code detected"
 return
 }
 
 // Get the metadata object.
 let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
 
 if metadataObj.type == AVMetadataObject.ObjectType.qr,
 let result = metadataObj.stringValue {
 
 scanResult = result
 print(scanResult)
 
 
 }
 }
 func makeCoordinator() -> Coordinator {
 Coordinator($scanResult)
 }
 
 }
 
 class QRScannerController: UIViewController {
 @Binding var scanResult: String
 var captureSession = AVCaptureSession()
 var videoPreviewLayer: AVCaptureVideoPreviewLayer?
 var qrCodeFrameView: UIView?
 
 var delegate: AVCaptureMetadataOutputObjectsDelegate?
 
 init(scanResult: Binding<String>) {  // Add this initializer
 self._scanResult = scanResult
 super.init(nibName: nil, bundle: nil)
 }
 
 required init?(coder: NSCoder) {
 fatalError("init(coder:) has not been implemented. You must use init(scanResult:) to create an instance of QRScannerController.")
 //super.init(coder: coder) // Comment out or remove this line
 }
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Get the back-facing camera for capturing videos
 guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
 print("Failed to get the camera device")
 return
 }
 
 let videoInput: AVCaptureDeviceInput
 
 do {
 // Get an instance of the AVCaptureDeviceInput class using the previous device object.
 videoInput = try AVCaptureDeviceInput(device: captureDevice)
 
 } catch {
 // If any error occurs, simply print it out and don't continue any more.
 print(error)
 return
 }
 
 // Set the input device on the capture session.
 captureSession.addInput(videoInput)
 
 // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
 let captureMetadataOutput = AVCaptureMetadataOutput()
 captureSession.addOutput(captureMetadataOutput)
 
 // Set delegate and use the default dispatch queue to execute the call back
 captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
 captureMetadataOutput.metadataObjectTypes = [ .qr ]
 
 // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
 videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
 videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
 videoPreviewLayer?.frame = view.layer.bounds
 view.layer.addSublayer(videoPreviewLayer!)
 
 // Start video capture.
 DispatchQueue.global(qos: .background).async {
 self.captureSession.startRunning()
 }
 
 }
 
 }
 
 struct QRScanner: UIViewControllerRepresentable {
 @Binding var scanResult: String
 
 func makeUIViewController(context: Context) -> QRScannerController {
 let controller = QRScannerController(scanResult: $scanResult)
 
 return controller
 }
 
 func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
 }
 }
 */
/*
import SwiftUI
import Foundation
import AVKit


struct ScannerView: View {
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Button {
                        // Handle the "xmark" button action
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(Color(.blue))
                    }
                }
                .padding(.horizontal)

                Text("Align the QR code inside the area")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.top, 20)

                Text("Scanner will start automatically")
                    .font(.callout)
                    .foregroundColor(.gray)

                Spacer()

                let size = min(geometry.size.width, geometry.size.height) * 0.5// Adjust size to 50%

                ZStack {
                    CameraView(frameSize: size, session: $session>)
                    
                    ForEach(0...3, id: \.self) { index in
                        let rotation = Double(index) * 90
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color(.blue), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation)
                        )
                    }
                }
                .frame(width: size, height: size)
                .overlay(alignment: .top, content: {
                    Rectangle()
                        .fill(Color(.blue))
                        .frame(height: 2.5)
                        .shadow(color: .black.opacity(0.8), radius: 8, y: isScanning ? 15 : -15)
                        .offset(y: isScanning ? size : 0)
                })

                Spacer(minLength: 45)

                Button {
                    // Handle the "qrcode.viewfinder" button action
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .onAppear
        .alert(errorMessage, isPresented: $showError) {
            
        }
    }

    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    //check camera permission
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video){
                case .authorized:
                    cameraPermission = .approved
                case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video){
                    cameraPermission = .approved
                }
                else {
                    cameraPermission = .denied
                }
                
                case .denied, .restricted:
                cameraPermission = .denied
                default: break
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
} */

/*
import Foundation
import SwiftUI
import AVKit

struct ScannerView: View {
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    @StateObject private var qrDelegate = QRScannerDelegate()
    @State private var scannedCode: String = ""
    
   var body: some View {
       VStack(spacing: 8) {
           Button {
               
           } label: {
               Image(systemName: "xmark")
                   .font(.title3)
                   .foregroundColor(Color(.blue))
           }
           .frame(maxWidth: .infinity, alignment: .leading)
           
           Text("Align the QR code inside the area")
               .font(.title3)
               .foregroundColor(.black.opacity(0.8))
               .padding(.top,20)
           
           Text("Scanner will start automatically")
               .font(.callout)
               .foregroundColor(.gray)
           
           Spacer(minLength: 0)
           
           //scanner
           GeometryReader {
               let size = $0.size
               
               ZStack {
                   
                   CameraView(frameSize: CGSize(width:size.width, height: size.width), session: $session)
                       .scaleEffect(0.97)
                   ForEach(0...4, id: \.self) {index in let rotation = Double(index) * 90
                       
                       RoundedRectangle(cornerRadius:2, style: .circular)
                       //trim
                           .trim(from: 0.61, to:0.64)
                           .stroke(Color(.blue), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                           .rotationEffect(.init(degrees:rotation))
                       
                   }

               }
               //square
               .frame(width: size.width, height: size.width)
               //scan animate
               .overlay(alignment: .top, content:{
                   Rectangle()
                       .fill(Color(.blue))
                       .frame(height: 2.5)
                       .shadow(color: .black.opacity(0.8), radius: 8, y: isScanning ? 15 : -15)
                       .offset(y: isScanning ? size.width : 0)
               })
               //center it
               .frame(maxWidth: .infinity, maxHeight: .infinity)
           }
           .padding(.horizontal,45)
           
           
           Spacer(minLength: 15)
           
           Button{
               if !session.isRunning && cameraPermission == .approved {
                   reactivateCamera()
                   activateScannerAnimation()
               }
           } label: {
               Image(systemName: "qrcode.viewfinder")
                   .font(.largeTitle)
                   .foregroundColor(.gray)
           }
           
           Spacer(minLength: 45)
       }
       
       .padding(15)
       .onAppear(perform: checkCameraPermission)
       .alert(errorMessage, isPresented: $showError) {
           if cameraPermission == .denied {
               Button("Settings") {
                   let settingsString = UIApplication.openSettingsURLString
                   if let settingsURL = URL(string: settingsString) {
                       //open settings
                       openURL(settingsURL)
                   }
               }
               Button("Cancel", role: .cancel) {
                   
               }
           }
       }
       .onChange(of: qrDelegate.scannedCode) {
           newValue in
           if let code = newValue {
               scannedCode = code
               session.stopRunning()
               deactivateScannerAnimation()
               qrDelegate.scannedCode = nil
           }
       }
       
   }
    
    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
   //activate scanner
   func activateScannerAnimation() {
       withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
           isScanning = true
       }
   }
    
    //deactivate scanner
    func deactivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    //check camera permission
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video){
                case .authorized:
                    cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    reactivateCamera()

                }
                case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video){
                    cameraPermission = .approved
                    setupCamera()
                }
                else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera")
                }
                
                case .denied, .restricted:
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera")
                default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            //find back camera, MIGHT HAVE TO CHECK DEVICE TYPE NOT SURE
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN ERROR")
                return
            }
            //camera input
            let input = try AVCaptureDeviceInput(device: device)
            //check if input and output can be added to session
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN ERROR")
                return
            }
            
            //add input output to cam session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            //set output to read qr
            qrOutput.metadataObjectTypes = [.qr]
            // retreive fetched code
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
   static var previews: some View {
       ScannerView()
   }
} */

import Foundation
import SwiftUI
import AVKit

struct ScannerView: View {
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    @StateObject private var qrDelegate = QRScannerDelegate()
    @State private var scannedCode: String = ""

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                Button {

                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(Color(.blue))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("Align the QR code inside the area")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.top, 20)

                Text("Scanner will start automatically")
                    .font(.callout)
                    .foregroundColor(.gray)

                Spacer(minLength: 0)

                // Scanner
                ZStack {
                    CameraView(frameSize: CGSize(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4), session: $session)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5 * 0.4)
                                .stroke(Color(.blue), lineWidth: 2)
                        )
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90

                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color(.blue), style: StrokeStyle(lineWidth: 5 * 0.4, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                    Rectangle()
                        .fill(Color(.blue))
                        .frame(height: 2.5 * 0.4)
                        .shadow(color: .black.opacity(0.8), radius: 8, y: isScanning ? -15 * 0.4 : 15 * 0.4) // Adjust the shadow offset
                        .offset(y: isScanning ? -geometry.size.width * 0.2 : 0) // Negative offset to cover the entire square
                }
                .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                .overlay(
                    RoundedRectangle(cornerRadius: 5 * 0.4)
                        .stroke(Color(.blue), lineWidth: 2)
                )
                .padding(.horizontal, geometry.size.width * 0.3)

                Button {
                    if !session.isRunning && cameraPermission == .approved {
                        reactivateCamera()
                        activateScannerAnimation()
                    }
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }

                Spacer(minLength: 45)
            }
            .padding(15)
            .onAppear(perform: checkCameraPermission)
            .alert(errorMessage, isPresented: $showError) {
                if cameraPermission == .denied {
                    Button("Settings") {
                        let settingsString = UIApplication.openSettingsURLString
                        if let settingsURL = URL(string: settingsString) {
                            openURL(settingsURL)
                        }
                    }
                    Button("Cancel", role: .cancel) {

                    }
                }
            }
            .onChange(of: qrDelegate.scannedCode) { newValue in
                if let code = newValue {
                    scannedCode = code
                    session.stopRunning()
                    deactivateScannerAnimation()
                    qrDelegate.scannedCode = nil
                    
                    if let url = URL(string: code) {
                        openURL(url)
                    }
                }
            }
        }
    }

    func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }

    func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }

    func deactivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }

    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    reactivateCamera()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to Camera")
            default:
                break
            }
        }
    }

    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("UNKNOWN ERROR")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("UNKNOWN ERROR")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }

    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}


