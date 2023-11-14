//
//  CameraView.swift
//  ex
//
//  Created by selindegirmenci on 10/24/23.
//

import AVFoundation
import SwiftUI
import Foundation

struct CameraView: UIViewRepresentable {
    var frameSize: CGSize
    @Binding var session: AVCaptureSession

    class Coordinator: NSObject {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        @objc func orientationChanged() {
            if let connection = parent.cameraLayer?.connection,
               connection.isVideoOrientationSupported {
                switch UIDevice.current.orientation {
                case .portrait:
                    connection.videoOrientation = .portrait
                case .portraitUpsideDown:
                    connection.videoOrientation = .portraitUpsideDown
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeRight
                case .landscapeRight:
                    connection.videoOrientation = .landscapeLeft
                default:
                    connection.videoOrientation = .portrait
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear

        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = CGRect(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill // Maintain the aspect ratio

        view.layer.addSublayer(cameraLayer)

        context.coordinator.parent.cameraLayer = cameraLayer

        // Set the initial video orientation based on the device orientation
        if let connection = cameraLayer.connection,
           connection.isVideoOrientationSupported {
            let deviceOrientation = UIDevice.current.orientation
            switch deviceOrientation {
            case .landscapeLeft:
                connection.videoOrientation = .landscapeRight
            case .landscapeRight:
                connection.videoOrientation = .landscapeLeft
            default:
                connection.videoOrientation = .portrait
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    var cameraLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            if let connection = cameraLayer?.connection,
               connection.isVideoOrientationSupported {
                let deviceOrientation = UIDevice.current.orientation
                switch deviceOrientation {
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeRight
                case .landscapeRight:
                    connection.videoOrientation = .landscapeLeft
                default:
                    connection.videoOrientation = .portrait
                }
            }
        }
    }
}





/*
struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
} */
