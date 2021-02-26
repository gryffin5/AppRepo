//
//  PreviewViewController.swift
//  catarACTION
//
//  Created by Elizabeth Winters on 10/28/20.
//  Copyright © 2020 Sruti Peddi. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

struct MyKeys {
    // Create keys to be used later
    static let imagesFolder = "imagesFolder"
    static let imagesAnalysis = "imagesAnalysis"
    static let uid = "uid"
    static let imageUrl = "imageUrl"
}

class PreviewViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    
    let alertVC = UIAlertController(title: "Error", message: "Unable to Upload Image", preferredStyle: .alert)
    var image: UIImage?
    var imageView: UIImageView?
    var context = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
    }
    // Discard image
    @IBAction func cancelButton(_ sender: Any) {
           dismiss(animated: true, completion: nil)
    }
    // Save Image to Camera Roll
    @IBAction func saveButton(_ sender: Any) {
        guard let imageToSave = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        uploadPhoto()
        // downloadPhoto()
        dismiss(animated: true, completion: nil)
    }
    // Upload to Firebase Storage
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
            self.present(alertVC, animated: true, completion: nil)
            return
        }
    }
    // For future use if downloaded photo is needed
    func downloadPhoto() {
        guard let uid = UserDefaults.standard.value(forKey: MyKeys.uid) else {
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        
        let query = Firestore.firestore().collection(MyKeys.imagesAnalysis).whereField(MyKeys.uid, isEqualTo: uid)
        
        query.getDocuments {(snapshot, err) in
             
            if err != nil {
                self.present(self.alertVC, animated: true, completion: nil)
                return
            }
            
            guard let snapshot = snapshot,
                let data = snapshot.documents.first?.data(),
                let urlString = data[MyKeys.imageUrl] as? String,
                let url = URL (string: urlString) else {
                self.present(self.alertVC, animated: true, completion: nil)
                return
            }
            
            let resource = ImageResource(downloadURL: url)
            self.imageView?.kf.setImage(with: resource, completionHandler: { (result) in
                switch result {
                case .success(_):
                    let newAlertVC = UIAlertController(title: "Success", message: "Able to Download Image", preferredStyle: .alert)
                    self.present(newAlertVC, animated: true, completion: nil)
                case .failure(_):
                    self.present(self.alertVC, animated: true, completion: nil)
                }
            })
        }
        
    }
  
    // Send image to AnalysisVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            print ("beginning of segue is working")
             if segue.identifier == "showImage"
             {
                let vc = segue.destination as! AnalysisViewController
                vc.image = self.image
                print ("segue is working")
             }
        }
}

