//
//  InfoViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 11/12/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//
import CoreML
import Vision
import UIKit

class AnalysisViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var textView: UILabel?
    var image: UIImage? = nil
    
    var PreviewVC = PreviewViewController()
    
    // For future use if Alert is needed
     let alertVC = UIAlertController(title: "Error", message: "There are no results for this image", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Set up where result for picture is shown
        view.backgroundColor = .white
        imageView?.image = image
        if self.image != nil {
            print ("is working in avc")
            // Convert normal image to CIimage
            let ciImage = CIImage(image: image!)
            detect(image: ciImage!)
        }
    }
 
    func detect(image: CIImage) {
        let config = MLModelConfiguration()
        // Container for CoreML requests
        guard let model = try? VNCoreMLModel(for: EyeDiseaseClassifier_2_copy_2(configuration: config).model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        // Request image and uses CoreML to process images
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            if let firstResult = results.first {
                // display result
                self.textView?.text = firstResult.identifier.capitalized
            }
        }
        // Model analyzes image passed into it
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
        
    }

