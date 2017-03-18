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


    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var detailView: DetailView!

    private var podImageView = UIImageView()
    
    @IBOutlet weak var detailViewTopConstraint: NSLayoutConstraint!
    var initialDetailViewTop: CGFloat = 0.0
    
    var currentAPOD: APOD! {
        didSet {
            imageURL = currentAPOD.imageURL
            if view.window != nil {
                setUIElements()
            }
        }
    }
    
    @IBOutlet weak var imageTitleLabel: UILabel!

    
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
        if currentAPOD == nil {
            return
        }
        detailView?.detailText = currentAPOD.detailText ?? " "
        imageTitleLabel?.text = currentAPOD.title ?? " "
        imageTitleLabel?.sizeToFit()
        self.title = currentAPOD.dateString ?? "APOD"
        initialDetailViewTop = detailViewTopConstraint.constant
        hideDetailView()
    }
    

    @IBAction func toggleDetailView(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print(detailView.bounds.height)
            if detailViewShowing {
                detailViewTopConstraint.constant = initialDetailViewTop
               UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    self.detailViewShowing = false
                    self.detailView.tabText = "More"
                })
 

            }
            else {
                detailViewTopConstraint.constant = -self.detailView.intrinsicContentSize.height
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    self.detailViewShowing = true
                    self.detailView.tabText = "Hide"
                })
            

            }
        }
    }
    
    private func hideDetailView() {
      //  detailView?.frame.origin.y = view.frame.height - 20
      //  detailView?.tabText = "More"
      //  detailViewShowing = false
      //  detailView.hide()
    }
    
    
    private func downloadImage() {
        guard let imageURL = imageURL else {
            return
        }
        if let url = URL(string: imageURL) {
            loadingSpinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                guard imageURL == url.absoluteString else {
                    return
                }
                let dataFromUrl = NSData(contentsOf: url)
                DispatchQueue.main.async { [weak weakSelf = self] in
                    weakSelf?.loadingSpinner.stopAnimating()
                    if let imageData = dataFromUrl {
                        let apodImage = UIImage(data: imageData as Data)
                        weakSelf?.apodImage = apodImage
                    }
                }

            }
            
        }
        
    }

}

