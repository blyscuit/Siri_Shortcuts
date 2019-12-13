//
//  IntentHandler.swift
//  SiriIntent
//
//  Created by Pisit W on 13/12/2562 BE.
//  Copyright © 2562 23. All rights reserved.
//

import Intents
import UserNotifications

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is ToDoIntent else {
            fatalError("Unhandled Intent error : \(intent)")
        }
        return  ToDoIntentHandler()
    }
    
}
