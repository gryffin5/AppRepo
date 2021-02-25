//
//  CameraViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/23/20.
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
        self.navigationController?.isNavigationBarHidden = true
           // Set up inputs and outputs
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
    
    // Real Time Capture
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        // check if current device can take pictures
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
            // Check if flash is possible
            if (avDevice.hasTorch) {
                do {
                    try avDevice.lockForConfiguration()
                } catch {
                    print(error.localizedDescription)
                }
                // Toggle flash on or off based on current state
                if avDevice.isTorchActive {
                    avDevice.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    avDevice.torchMode = AVCaptureDevice.TorchMode.on
                }
            }
            // Unlock your device
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
    
    @IBAction func imageCapture(_ sender: Any) {
        // Take photo
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
    // Convert image to data
    if let imageData = photo.fileDataRepresentation() {
        self.image = UIImage(data: imageData)
        self.performSegue(withIdentifier: "showPhoto_Segue", sender: self)


    }
}
}
