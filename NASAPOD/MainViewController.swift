//
//  MainViewController.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/14/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISplitViewControllerDelegate {
    // MARK: Instance variables
    private let apodFetcher = APODFetcher()
    private var chosenApod: APOD?
    
    // MARK: Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
 
    @IBOutlet weak var todaysLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var pastLoadingSpinner: UIActivityIndicatorView!
    
    // MARK: Constants
    private struct Storyboard {
        static let ShowAPODSegue = "Show APOD"
    }
    
    private struct StringConstants {
        static let GeneralErrorMessage: String = "We can't show you that one."
    }
    
    
    // MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        self.splitViewController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Actions
    @IBAction func getTodaysPOD(_ sender: UIButton) {
        todaysLoadingSpinner.startAnimating()
        apodFetcher.getTodaysPOD() { [weak weakself = self] (apod: APOD) -> Void  in
            weakself?.chosenApod = apod
            DispatchQueue.main.async {
                weakself?.todaysLoadingSpinner.stopAnimating()
                weakself?.setupAPOD()
            }
        }
    }
    
    @IBAction func getPODFromDate(_ sender: UIButton) {
        let chosenDate = datePicker.date
        pastLoadingSpinner.startAnimating()
        apodFetcher.getPastPOD(fromDate: chosenDate) { [weak weakself = self] (apod: APOD) -> Void  in
            weakself?.chosenApod = apod
            DispatchQueue.main.async {
                weakself?.pastLoadingSpinner.stopAnimating()
                weakself?.setupAPOD()
            }
        }
    }

    // MARK: UISplitViewControllerDelegate
    // This corker helps for the starting case on iPhone, where the detail view shows at first even when it's not ready.  So we've got
    // this awesome function to tell the splitViewController that we "handled" the situation when the secondaryViewController isn't ready
    // to be seen (ie show the master in this case).
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if primaryViewController.contentViewController == self {
            if let podvc = secondaryViewController.contentViewController as? PODViewController, podvc.imageURL == nil {
                return true
            }
        }
        return false
    }
    
    
    // MARK: - Navigation
     
     private func setupAPOD() {
        if let errMsg = chosenApod?.errorMessage  {
            showError(errMsg)
            return
        }
        if let apodvc = self.splitViewController?.viewControllers.last?.contentViewController as? PODViewController {
            apodvc.currentAPOD = chosenApod
        }
        else {
            performSegue(withIdentifier: Storyboard.ShowAPODSegue, sender: nil)
        }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowAPODSegue {
            if let apodvc = segue.destination.contentViewController as? PODViewController {
                apodvc.currentAPOD = chosenApod
            }
        }
    }
    
    // MARK: Showing errors
    private func showError(_ errorMessage: String) {
        let fullErrorText = "\(StringConstants.GeneralErrorMessage)\n\n\(errorMessage)"
        let errorPopup = UIAlertController(title: "Darn", message: fullErrorText, preferredStyle: .alert)
        errorPopup.addAction(UIAlertAction(title: "OK", style: .default) { action in
        })
        self.present(errorPopup, animated: true, completion: nil)
    }
}


extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        else {
            return self
        }
    }
}
