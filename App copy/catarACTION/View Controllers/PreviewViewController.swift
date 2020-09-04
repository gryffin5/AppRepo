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
import Kingfisher

struct MyKeys {
    static let imagesFolder = "imagesFolder"
    static let imagesCollection = "imagesCollection"
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
    fileprivate func uploadPhoto() {
        guard let image = imageView?.image, let data = image.jpegData(compressionQuality: 1.0)
            else {
            let alertVC = UIAlertController(title: "Error", message: "#1", preferredStyle: .alert)
            self.present(alertVC,animated: true, completion: nil)
            return
        }
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(MyKeys.imagesFolder).child(imageName)

        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                let alertVC = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                self.present(alertVC,animated: true, completion: nil)
                return
            }
            imageReference.downloadURL(completion: {(url, err) in
            if let err = err {
                let alertVC = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                self.present(alertVC,animated: true, completion: nil)
                return
            }
                guard let url = url else {
                        let alertVC = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                    self.present(alertVC,animated: true, completion: nil)
                        return
                }

                let dataReference = Firestore.firestore().collection(MyKeys.imagesCollection).document()
                let documentUid = dataReference.documentID

                let urlString = url.absoluteString

                let data = [
                    MyKeys.uid: documentUid,
                    MyKeys.imageUrl: urlString
                ]

                dataReference.setData(data, completion: { (err) in
                    if let err = err {
                        let alertVC = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                        self.present(alertVC,animated: true, completion: nil)
                        return
                    }
                    UserDefaults.standard.set(documentUid, forKey: MyKeys.uid)

                    self.imageView?.image = UIImage()

                    let alertVC = UIAlertController(title: "Success", message: "Successfully saved image to database", preferredStyle: .alert)
                    self.present(alertVC,animated: true, completion: nil)

                })

            })

        }
    }
    
}
