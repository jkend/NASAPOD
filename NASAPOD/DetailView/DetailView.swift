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
    
    // TODO should be read only
    var minimized = true
    
    var tabText: String? {
        didSet {
            moreLabel?.text = tabText
        }
    }
    var detailText: String? {
        didSet {
            textView?.text = detailText
         //   textView?.sizeToFit()
         //   self.layoutIfNeeded()
        //    textView?.layoutIfNeeded()
        //    textView?.text = detailText
        //    textView?.sizeToFit()
            print("textview height = \(textView?.frame.height)")
            print("intrinsic height = \(textView?.intrinsicContentSize.height)")
            
           self.sizeToFit()
            print("views intrinsic size = \(self.intrinsicContentSize)")
        }
    }
    override var bounds: CGRect {
        didSet {
            print("set bounds!")
            print(bounds)
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        print("Detailview calling sizeThatFits")
        if textView == nil {
            print("Returning 0")
            return CGSize.zero
        }
        textView.sizeToFit()
        let textFrame = textView.frame
        // TODO that constant is silly, use constraint vertical values maybe?
        let mysize = CGSize(width: textFrame.width, height: textFrame.height + moreLabel.frame.height + 20)
        print(mysize)
        return mysize
    }
    
    override var intrinsicContentSize: CGSize {
        print("intrinsic size!")
        return sizeThatFits(CGSize(width: 0, height: 0))
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
    
}
