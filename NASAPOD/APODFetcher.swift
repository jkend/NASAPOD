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
    
    private struct ErrorMessages {
        static let NoData: String = "We were unable to download the APOD for this date."
        static let UnexpectedFormat: String = "The APOD from this date is in a format we aren't expecting!"
        static let NoImage: String = "It seems that this day's APOD isn't on NASA's server at the moment."
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
                apodResponse.errorMessage = error.localizedDescription
                completionHandler(apodResponse)
                return
                
            }
            guard let responseData = data else {
                apodResponse.errorMessage = ErrorMessages.NoData
                completionHandler(apodResponse)
                return
            }
            do {
                guard let apodData = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        apodResponse.errorMessage = ErrorMessages.UnexpectedFormat
                        completionHandler(apodResponse)
                        return
                }
                if apodData["code"] != nil {
                    apodResponse.errorMessage = ErrorMessages.NoImage
                    completionHandler(apodResponse)
                    return
                }
                apodResponse.title = apodData["title"] as! String?
                apodResponse.detailText = apodData["explanation"] as! String?
                apodResponse.imageURL = apodData["url"] as! String?
                completionHandler(apodResponse)
            } catch  {
                apodResponse.errorMessage = ErrorMessages.UnexpectedFormat
                completionHandler(apodResponse)
                return
            }
        }
        task.resume()
    }
    
}
