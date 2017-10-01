//
//  BarcodeReaderVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 9. 3..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeReaderVcDelegate {
    func barcodeReaderVC(sender: BarcodeReaderVC, didRead value: String?)
}

// MARK: - BarcodeReaderVC
class BarcodeReaderVC: UIViewController {
    // MARK: Variable
    let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    let captureSession = AVCaptureSession()
    var delegate: BarcodeReaderVcDelegate? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QR 코드 스캔"
        self.startDevice()
    }
}

// MARK: Function
extension BarcodeReaderVC {
    func startDevice() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video),
            let input = try? AVCaptureDeviceInput(device: device)
        {
            self.captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            self.captureSession.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = self.supportedCodeTypes
            
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = self.view.layer.bounds
            self.view.layer.addSublayer(videoPreviewLayer)

            self.captureSession.startRunning()
        } else {
            self.delegate?.barcodeReaderVC(sender: self, didRead: nil)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension BarcodeReaderVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if 0 < metadataObjects.count,
            let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            let stringValue = object.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        {
            prLog(stringValue)
            self.captureSession.stopRunning()
            self.delegate?.barcodeReaderVC(sender: self, didRead: stringValue)
        }
    }
}
