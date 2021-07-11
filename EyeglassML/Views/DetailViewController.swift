//
//  DetailViewController.swift
//  EyeglassML
//
//  Created by RB on 7/10/21.
//

import WikipediaKit
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var wikititle: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var maintext: UITextView!
    
    var term = ""
    
    let wikipedia = Wikipedia()
    let language = WikipediaLanguage("en")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphics()
        
        Wikipedia.sharedFormattingDelegate = MyFormattingDelegate.shared
        WikipediaNetworking.appAuthorEmailForAPI = "pranavbhuv@gmail.com"
        
        let language = WikipediaLanguage("en")

        let _ = Wikipedia.shared.requestArticle(language: language, title: term, imageWidth: 50) { result in
            switch result {
            case .success(let article):
                self.getImage(from: article.imageURL!)
                self.wikititle.text = article.displayTitle
                self.maintext.text = article.displayText
            case .failure(let error):
              print(error)
            }
        }
        
    }
    
    func graphics() {
        maintext.layer.backgroundColor = UIColor(hue: 0.5611, saturation: 0.4, brightness: 0.74, alpha: 1.0).cgColor
        maintext.layer.cornerRadius = 30
        maintext.sizeToFit()
        maintext.clipsToBounds = true
        maintext.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        maintext.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        imageview.layer.cornerRadius = 15
        imageview.layer.masksToBounds = true
    }
    
    func getImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.imageview.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

class MyFormattingDelegate: WikipediaTextFormattingDelegate {

    static let shared = MyFormattingDelegate()

    func format(context: WikipediaTextFormattingDelegateContext, rawText: String, title: String?, language: WikipediaLanguage, isHTML: Bool) -> String {
        // Do the formatting! But don’t actually use this regex method to strip HTML tags. 🤪
        let formattedText = rawText.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression)
        return formattedText
    }
}
