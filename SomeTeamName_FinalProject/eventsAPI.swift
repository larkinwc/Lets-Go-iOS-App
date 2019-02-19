//
//  eventsAPI.swift
//  SomeTeamName_FinalProject
//
//  Created by luhrkin on 11/28/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import Foundation
import UIKit

protocol eventProtocol
{
    func responseDataHandler(data: [Any]) // returns array of event JSON objects
    func responseError(message:String)
}

class eventAPI {
    private let urlPathBase = "https://us-central1-aetsc-217501.cloudfunctions.net/eventAPI" // custom flask API running on Google Cloud Platform's Cloud Functions, expanding to use queries and aggregate data from multiple sources.
    var delegate:eventProtocol? = nil
    
    init() {}
    
    func parseJSON(json: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print(jsonData!)
        var urlOrigin = self.urlPathBase;
        // urlOrigin += (query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
        let urlTarget = URL(string: urlOrigin)
        var request = URLRequest(url: urlTarget!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData!;
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            guard error == nil else {
                self.delegate?.responseError(message: "Error bad request was made")
                return
            }
            guard let content = data else {
                self.delegate?.responseError(message: "Data not found in response")
                return
            }
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                self.delegate?.responseError(message: "Error bad response")
                return
            }
            // print(json)
             if let res = json["events"] as? [Any] { // convert current condition value to array
                self.delegate?.responseDataHandler(data: res)
            } else {
                self.delegate?.responseError(message: "Error bad input")
            }
        }
        task.resume()
    }
    
}
