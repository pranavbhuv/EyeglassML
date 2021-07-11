//
//  ViewController.swift
//  EyeglassML
//
//  Created by RB on 7/10/21.
//

import CoreML
import Vision
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var chooser: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    let modelnet = MobileNetV2FP16()
    let imagePicker = UIImagePickerController()
    
    var passing = "apple"
    
    var please = URL(string: "https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphics()
        
        ml()
    }
    
    @IBAction func loadImage(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func toDetailView(_ sender: Any) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    func graphics() {
        image.layer.cornerRadius = 25
        
        label.heightAnchor.constraint(equalToConstant: 70).isActive = true
        label.layer.backgroundColor = UIColor(hue: 0.5611, saturation: 0.4, brightness: 0.74, alpha: 1.0).cgColor
        label.layer.cornerRadius = 25
        
        chooser.heightAnchor.constraint(equalToConstant: 70).isActive = true
        chooser.layer.backgroundColor = UIColor(hue: 0.5611, saturation: 0.4, brightness: 0.74, alpha: 1.0).cgColor
        chooser.layer.cornerRadius = 25
        
        detailButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        detailButton.layer.backgroundColor = UIColor(hue: 0.5611, saturation: 0.4, brightness: 0.74, alpha: 1.0).cgColor
        detailButton.layer.cornerRadius = 25
    }
    
    func ml() {
        let model = try! VNCoreMLModel(for: modelnet.model)
        let handler = VNImageRequestHandler(url: please!)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }
    
    func findResults(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Unable to get results")
            label.text = "Unable to find the results."
        }
        var bestGuess = ""
        var bestConfidence: VNConfidence = 0
        for classification in results {
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestGuess = classification.identifier
            }
        }
        let newconfi = lround(Double(bestConfidence) * 100)
        passing = bestGuess
        label.text = "Image is: \(bestGuess)\nConfidence: \(newconfi)%"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
                
        guard let images = info[.editedImage] as? UIImage else {
            print("No Image Found")
            return
        }
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image.contentMode = .scaleAspectFit
            image.image = pickedImage
        }
        
        if(picker.sourceType == UIImagePickerController.SourceType.camera) {
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            let data = images.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath)
            please = photoURL
        }
        
        ml()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailview = segue.destination as! DetailViewController
        let term = byebye()
        detailview.term = term
    }
    
    func byebye() -> String {
        let term = passing
        if term.contains(",") {
            let commaindx = term.firstIndex(of: ",")
            return String(term[..<commaindx!])
        } else {
            return term
        }
    }
}
