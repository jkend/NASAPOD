//
//  MainViewController.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/14/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UISplitViewControllerDelegate {

    private let apodFetcher = APODFetcher()
    @IBOutlet weak var datePicker: UIDatePicker!
    private var chosenApod: APOD?
    
    private struct Storyboard {
        static let ShowAPODSegue = "Show APOD"
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
        apodFetcher.getTodaysPOD() { [weak weakself = self] (apod: APOD) -> Void  in
            weakself?.chosenApod = apod
            DispatchQueue.main.async {
                weakself?.setupAPOD()
            }
        }
    }
    
    @IBAction func getPODFromDate(_ sender: UIButton) {
        let chosenDate = datePicker.date
        apodFetcher.getPastPOD(fromDate: chosenDate) { [weak weakself = self] (apod: APOD) -> Void  in
            weakself?.chosenApod = apod
            DispatchQueue.main.async {
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
        if let apodvc = self.splitViewController?.viewControllers.last?.contentViewController as? PODViewController {
            //apodvc.imageURL = chosenApod?.imageURL
            //apodvc.imageTitle = chosenApod?.title
            apodvc.currentAPOD = chosenApod
        }
        else {
            performSegue(withIdentifier: Storyboard.ShowAPODSegue, sender: nil)
        }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowAPODSegue {
            if let apodvc = segue.destination.contentViewController as? PODViewController {
                //apodvc.imageURL = chosenApod?.imageURL
                //apodvc.imageTitle = chosenApod?.title
                apodvc.currentAPOD = chosenApod
            }
        }
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
