//
//  AboutViewController.swift
//  EyeglassML
//
//  Created by RB on 7/10/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "ver 1.0\n\nThis app was made in 2 days for the Hack the Cloud 2.0 Hackathon.\nThe app uses ML models provided by Apple as well as the library WikipediaKit by Raureif.\n\nDeveloped by Pranav B\nAlso check out SAT Daily!"
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 15
    }

}
