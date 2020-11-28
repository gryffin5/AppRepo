//
//  InfoViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 8/12/20.
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
    
    
     let alertVC = UIAlertController(title: "Error", message: "There are no results for this image", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        imageView?.image = image
        if self.image != nil {
            print ("is working in avc")
            let ciImage = CIImage(image: image!)
            detect(image: ciImage!)
        }
    }
 
    func detect(image: CIImage) {
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: EyeDiseaseClassifier_1(configuration: config).model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            if let firstResult = results.first {
                self.textView?.text = firstResult.identifier.capitalized
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
        
    }

