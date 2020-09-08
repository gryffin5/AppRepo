//
//  PreviewViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 8/28/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

struct MyKeys {
    static let imagesFolder = "imagesFolder"
    static let imagesAnalysis = "imagesAnalysis"
    static let uid = "uid"
    static let imageUrl = "imageUrl"
}

class PreviewViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    
    var image: UIImage?
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
    }
    
    @IBAction func cancelButton(_ sender: Any) {
           dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let imageToSave = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        uploadPhoto()
        dismiss(animated: true, completion: nil)
    }
    func uploadPhoto() {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(MyKeys.imagesFolder).child("\(imageName)")
        
        if let imageData = image!.jpegData(compressionQuality: 1) {
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
                if error != nil {
                    print(error?.localizedDescription as Any)
                return
                }
                print(metadata as Any)
                
        })
        }
        else {
            let alertVC = UIAlertController(title: "Error", message: "Unable to Upload Image", preferredStyle: .alert)
            self.present(alertVC, animated: true, completion: nil)
        }
        }
    }
    

