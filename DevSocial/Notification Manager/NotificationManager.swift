//
//  NotificationManager.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/5/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import Firebase

final class NotificationManager {
    static var shared = NotificationManager()
    
    func sendPushNotification(token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAGavO6uA:APA91bFIOGZpF1Np5i2di3e24DAaAVBtqhMFf2pnHJY5g8GwFmpfj9jAaK60ibC3SJE8rjioR1xwDwqFa2sSl7cNw2BFsDq6u1M1aHLgxhrqnJQe62YPYF02EAtqVZEG-uH-pEccZNxI", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
