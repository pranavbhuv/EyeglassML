//
//  HomeViewController.swift
//  EyeglassML
//
//  Created by RB on 7/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var toMain: UIButton!
    @IBOutlet weak var toAbout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphics()
        
    }
    
    @IBAction func toMLMain(_ sender: Any) {
        performSegue(withIdentifier: "toML", sender: self)
    }
    
    @IBAction func toAboutS(_ sender: Any) {
        performSegue(withIdentifier: "toAbout", sender: self)
    }
    
    func graphics() {
        let bg = UIImage(named: "backgroundlmao")
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.clipsToBounds = true
        imageView.image = bg
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        toMain.heightAnchor.constraint(equalToConstant: 70).isActive = true
        toMain.layer.backgroundColor = UIColor(hue: 0.5611, saturation: 0.4, brightness: 0.74, alpha: 1.0).cgColor
        toMain.layer.cornerRadius = 30
        
        toAbout.heightAnchor.constraint(equalToConstant: 70).isActive = true
        toAbout.layer.backgroundColor = UIColor(hue: 0.5611, saturation: 0.4, brightness: 0.74, alpha: 1.0).cgColor
        toAbout.layer.cornerRadius = 30
    }
}
