//
//  APOD.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/13/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import Foundation

class APOD {
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private struct Constants {
        static let ApiKey: String = "DEMO_KEY"
        static let BaseUrl: String = "https://api.nasa.gov/planetary/apod?api_key="
    }
    
    func getTodaysPOD() {
        let url = String(format: "%@%@", Constants.BaseUrl, Constants.ApiKey)
        getPODJson(url)
    }
    
    func getPastPOD(fromDate: Date) {
        let dateString = dateFormatter.string(from: fromDate)
        let url = String(format: "%@%@&date=%@", Constants.BaseUrl, Constants.ApiKey, dateString)
        print(url)
        getPODJson(url)
  
    }
    
    private func getPODJson(_ urlString: String) {
        let requestURL = URL(string: urlString)
        let urlRequest = URLRequest(url: requestURL!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            guard let responseData = data else {
                print("Error: No data")
                return
            }
            do {
                guard let apodData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                print(apodData)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}
