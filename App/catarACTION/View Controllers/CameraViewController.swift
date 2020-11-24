//
//  CameraViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 8/23/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
       
    var photoOutput: AVCapturePhotoOutput?
       
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
       
    var image: UIImage?
       
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setupCaptureSession()
           setupDevice()
           setupInputOutput()
           setupPreviewLayer()
           captureSession.startRunning()
           
           // Zoom In recognizer
           zoomInGestureRecognizer.direction = .up
           zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
           view.addGestureRecognizer(zoomInGestureRecognizer)
           
           // Zoom Out recognizer
           zoomOutGestureRecognizer.direction = .down
           zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
           view.addGestureRecognizer(zoomOutGestureRecognizer)
        
        // Camera Focus
        currentDevice?.isFocusModeSupported(.continuousAutoFocus)
        try! currentDevice?.lockForConfiguration()
        currentDevice?.focusMode = .continuousAutoFocus
        currentDevice?.unlockForConfiguration()
       }
       
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentDevice = backCamera
    }
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = view.frame
        
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }


    @IBAction func rotateCamera(_ sender: Any) {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    @IBAction func didTouchFlashButton(_ sender: Any) {
        if let avDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            if (avDevice.hasTorch) {
                do {
                    try avDevice.lockForConfiguration()
                } catch {
                    print(error.localizedDescription)
                }

                if avDevice.isTorchActive {
                    avDevice.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    avDevice.torchMode = AVCaptureDevice.TorchMode.on
                }
            }
            // unlock your device
            avDevice.unlockForConfiguration()
        }
    }
    @objc func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
//    @objc func tapToFocus(_ sender: UITapGestureRecognizer) {
//        if (sender.state == .ended) {
//            let thisFocusPoint = sender.location(in: previewView)
//
//            print("touch to focus ", thisFocusPoint)
//
//            let focus_x = thisFocusPoint.x / previewView.frame.size.width
//            let focus_y = thisFocusPoint.y / previewView.frame.size.height
//
//            if (captureDevice!.isFocusModeSupported(.autoFocus) && captureDevice!.isFocusPointOfInterestSupported) {
//                do {
//                    try captureDevice?.lockForConfiguration()
//                    captureDevice?.focusMode = .autoFocus
//                    captureDevice?.focusPointOfInterest = CGPoint(x: focus_x, y: focus_y)
//
//                    if (captureDevice!.isExposureModeSupported(.autoExpose) && captureDevice!.isExposurePointOfInterestSupported) {
//                        captureDevice?.exposureMode = .autoExpose;
//                        captureDevice?.exposurePointOfInterest = CGPoint(x: focus_x, y: focus_y);
//                     }
//
//                    captureDevice?.unlockForConfiguration()
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
    @IBAction func imageCapture(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto_Segue" {
            let previewViewController = segue.destination as! PreviewViewController
            previewViewController.image = self.image
        }
    }
    }

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let imageData = photo.fileDataRepresentation() {
        self.image = UIImage(data: imageData)
        self.performSegue(withIdentifier: "showPhoto_Segue", sender: self)


    }
}
}
