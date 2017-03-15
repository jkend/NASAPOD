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

    @IBOutlet weak var detailView: UIView!

    private var podImageView = UIImageView()
    
    var currentAPOD: APOD! {
        didSet {
            imageURL = currentAPOD.imageURL
            if view.window != nil {
                setUIElements()
            }
        }
    }
    
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var detailMoreLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var apodImage: UIImage? {
        get {
            return podImageView.image
        }
        set {
            podImageView.image = newValue
            podImageView.contentMode = .scaleAspectFit
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
    private var detailViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.addSubview(podImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIElements()
        if (apodImage == nil) {
            downloadImage()
        }
    }
    
    private func setUIElements() {
        detailTextView.text = currentAPOD.detailText!
        imageTitleLabel.text = currentAPOD.title!
        detailView.sizeToFit()
        hideDetailView()
    }
    
    @IBAction func toggleDetailView(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if detailViewShowing {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                    self.detailView.frame.origin.y = self.view.frame.height - 20
                }, completion: { (finished: Bool) in
                    self.detailViewShowing = false
                    self.detailMoreLabel.text = "More"
                })
            }
            else {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                    self.detailView.frame.origin.y = self.view.frame.height - self.detailView.frame.height
                }, completion: { (finished: Bool) in
                    self.detailViewShowing = true
                    self.detailMoreLabel.text = "Hide"
                })

            }
        }
    }
    
    private func hideDetailView() {
        detailView.frame.origin.y = view.frame.height - 20
        detailMoreLabel.text = "More"
        detailViewShowing = false
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

