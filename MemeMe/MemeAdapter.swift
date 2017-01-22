//
//  MemeAdapter.swift
//  MemeMe
//
//  Created by pk on 1/21/17.
//  Copyright © 2017 TinyAppsDev. All rights reserved.
//

import Foundation


class MemeAdapter {
    
    static let sOnMemeUpdatedNotificationName = NSNotification.Name(rawValue: "OnMemeUpdatedNotification")
    
    var memes = [Meme]()
    
    func notifyChanged() {
        NotificationCenter.default.post(name: MemeAdapter.sOnMemeUpdatedNotificationName, object: nil)
    }
    
    func registerObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: MemeAdapter.sOnMemeUpdatedNotificationName, object: nil)
    }
    
    func unregisterObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: MemeAdapter.sOnMemeUpdatedNotificationName, object: nil)
    }
    
}
