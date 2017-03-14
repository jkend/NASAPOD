//
//  APOD.swift
//  NASAPOD
//
//  Created by Joy Kendall on 3/13/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import Foundation

class APODFetcher {
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
    
    func getTodaysPOD(completion:@escaping (APOD) -> Void) {
        let url = String(format: "%@%@", Constants.BaseUrl, Constants.ApiKey)
        getPODJson(url, completionHandler: completion)
    }
    
    func getPastPOD(fromDate: Date, completionHandler completion:@escaping (APOD) -> Void) {
        let dateString = dateFormatter.string(from: fromDate)
        let url = String(format: "%@%@&date=%@", Constants.BaseUrl, Constants.ApiKey, dateString)
        print(url)
        getPODJson(url, completionHandler: completion)
  
    }
    
    private func getPODJson(_ urlString: String, completionHandler: @escaping (APOD) -> Void) {
        let requestURL = URL(string: urlString)
        let urlRequest = URLRequest(url: requestURL!)
        let session = URLSession.shared
        let apodResponse = APOD()
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
                apodResponse.title = apodData["title"] as! String?
                apodResponse.detailText = apodData["explanation"] as! String?
                apodResponse.imageURL = apodData["url"] as! String?
                print(apodData)
                completionHandler(apodResponse)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}
