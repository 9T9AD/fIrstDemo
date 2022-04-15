//
//  ViewController.swift
//  Demo FYP
//
//  Created by Adewale Sanusi on 14/04/2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        /* if you want .allowEditing to be true, change userPickedImage to info[UIImagePickerController.InfoKey.edittedImage] */
        imagePicker.allowsEditing = false
        
        /*The source of the image is set to camera, app will crash if run on simulator.
         To run on simulator use " imagePicker.sourceType = .photoLibrary " */
        imagePicker.sourceType = .camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let myOwnCiImage = CIImage(image: userPickedImage) else {
                
                fatalError("Cannot convert to CIImage")
            }
            
            //if it succeeds call myOwnCiImage
            detect(image: myOwnCiImage)
            
            imageView.image = userPickedImage
            
        }
        
        
        //Once user finish picking image, dismiss image picker
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // Fuction for the CoreML model
    func detect(image: CIImage){
    
        
//        let model: VNCoreMLModel = {
//            do {
//                let config = DemoCUPlantImageClassifier().model
//                return try VNCoreMLModel(for: config)
//            } catch {
//                print(error)
//                fatalError("cooooo")
//            }
//        }()
        
        guard let model = try? VNCoreMLModel(for: DemoCUPlantImageClassifier().model) else {
            
            fatalError("Cannot Import Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            let classification = request.results?.first as? VNClassificationObservation
            
            
            self.navigationItem.title = classification?.identifier
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        
        catch{
            print(error)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}

