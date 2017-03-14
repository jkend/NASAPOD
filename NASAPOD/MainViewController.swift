//
//  MainViewController.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/14/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private let apodHandler = APOD()
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func getTodaysPOD(_ sender: UIButton) {
        apodHandler.getTodaysPOD()
    }
    
    @IBAction func getPODFromDate(_ sender: UIButton) {
        let chosenDate = datePicker.date
        apodHandler.getPastPOD(fromDate: chosenDate)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
