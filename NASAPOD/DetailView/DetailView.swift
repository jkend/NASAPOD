//
//  DetailView.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/16/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit
@IBDesignable
class DetailView: UIView {

    @IBOutlet weak var moreLabel: UILabel!

    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet var topView: UIView!
    
    var minimized = true
    
    var tabText: String? {
        didSet {
            moreLabel?.text = tabText
        }
    }
    var detailText: String? {
        didSet {
            self.layoutIfNeeded()
            textView?.layoutIfNeeded()
            textView?.text = detailText
            textView?.sizeToFit()
            print("textview height = \(textView?.frame.height)")
            print("intrinsic height = \(textView?.intrinsicContentSize.height)")
            
            self.sizeToFit()
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if textView == nil {
            return CGSize.zero
        }
        textView.sizeToFit()
        let textFrame = textView.frame
        // TODO that constant is silly, use constraint vertical values maybe?
        return CGSize(width: textFrame.width, height: textFrame.height + moreLabel.frame.height + 20)
    }
    
    // MARK: init/load from nib
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        topView = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        topView.frame = bounds
        
        // Make the view stretch with containing view
        topView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(topView)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: DetailView.self)
        let nib = UINib(nibName: "DetailView", bundle: bundle)
        let view = nib.instantiate(withOwner:self, options: nil)[0] as! UIView
        
        return view
    }
    
    func show() {
        guard let parentView = superview else {
            return
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.frame.origin.y = parentView.frame.height - self.frame.height
        }, completion: { (finished: Bool) in
            self.minimized = false
            self.moreLabel.text = "Hide"
        })
    }
    
    func hide() {
        guard let parentView = superview else {
            return
        }
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.frame.origin.y = parentView.frame.height - self.moreLabel.frame.height
        }, completion: { (finished: Bool) in
            self.minimized = true
            self.moreLabel.text = "More"
        })
    }
}
