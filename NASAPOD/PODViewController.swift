//
//  PODViewController.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/13/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class PODViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.contentSize = podImageView.frame.size
        }
    }

    private var podImageView = UIImageView()
    
    var apodImage: UIImage? {
        get {
            return podImageView.image
        }
        set {
            podImageView.image = newValue
            podImageView.sizeToFit()
            imageScrollView?.contentSize = podImageView.frame.size
        }
    }
    
    var imageURL: String? {
        didSet {
            podImageView.image = nil
            if view.window != nil {
                downloadImage()
            }
        }
    }
    var imageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.addSubview(podImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (apodImage == nil) {
            downloadImage()
        }
    }
    
    
    private func downloadImage() {
        guard let imageURL = imageURL else {
            return
        }
        if let url = URL(string: imageURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                guard imageURL == url.absoluteString else {
                    return
                }
                let dataFromUrl = NSData(contentsOf: url)
                DispatchQueue.main.async { [weak weakSelf = self] in
                    if let imageData = dataFromUrl {
                        let apodImage = UIImage(data: imageData as Data)
                        weakSelf?.apodImage = apodImage
                    }
                }

            }
            
        }
        
    }

}

