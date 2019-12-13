//
//  ToDoIntentHandler.swift
//  SiriIntent
//
//  Created by Pisit W on 13/12/2562 BE.
//  Copyright © 2562 23. All rights reserved.
//

import UIKit

import Foundation
import Intents
import UserNotifications

class ToDoIntentHandler : NSObject, ToDoIntentHandling {
    func resolveDetail(for intent: ToDoIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let details = intent.detail else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: details))
    }
    
    func resolveTitle(for intent: ToDoIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let title = intent.title else {
            completion(INStringResolutionResult.needsValue())
            return
        }
        completion(INStringResolutionResult.success(with: title))
    }
    
    func handle(intent: ToDoIntent, completion: @escaping (ToDoIntentResponse) -> Void) {
        
        
        let listSize = addTODO(title: intent.title!, details: intent.detail!)
        completion(ToDoIntentResponse.success(numberTodo: NSNumber(value: listSize)))
    }
    
    //implement this method to get the to-do list from UserDefaults, add to it, save it again to user defaults
    //and return its size
    func addTODO(title: String, details: String) -> Int{
        let task = URLSession.shared.dataTask(with: URL(string: "https://api.waqi.info/feed/here/?token=4e8659f8c9fadf488c951dd60eb1bbb33f94f802")!) { (data, resp, error) in
            if error == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = json as? [String: Any] {
                    if let number = (dictionary["data"] as? [String: Any])?["aqi"] as? Int {
                        let city = ((dictionary["data"] as? [String: Any])?["city"] as? [String: Any])?["name"]
                        // access individual value in dictionary
                        let notificationContent = UNMutableNotificationContent()
                        notificationContent.title = "Current AQI"
                        notificationContent.body = "\(city ?? ""): \(number)"
                        notificationContent.badge = NSNumber(value: number)
                        
                        if let url = Bundle.main.url(forResource: "dune",
                                                    withExtension: "png") {
                            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                                            url: url,
                                                                            options: nil) {
                                notificationContent.attachments = [attachment]
                            }
                        }
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                                        repeats: false)
                        let request = UNNotificationRequest(identifier: "testNotification",
                                                            content: notificationContent,
                                                            trigger: trigger)
                        let userNotificationCenter = UNUserNotificationCenter.current()

                        userNotificationCenter.add(request) { (error) in
                            if let error = error {
                                print("Notification Error: ", error)
                            }
                        }
                    }
                }
            }
                
        }
        task.resume()
        return 1
    }
}
