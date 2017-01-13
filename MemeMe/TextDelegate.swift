//
//  TextDelegate.swift
//  MemeMe
//
//  Created by pk on 1/5/17.
//  Copyright © 2017 TinyAppsDev. All rights reserved.
//

import Foundation
import UIKit


class TextDelegate: NSObject, UITextFieldDelegate {
    let mViewController: ViewController
    var mState = [Int:Bool]()
    var curFocusedTextField: UITextField?
    
    init(viewController: ViewController) {
        mViewController = viewController
    }
    
    func reset() {
        if let textField = curFocusedTextField {
            textField.resignFirstResponder()
        }
        mState.removeAll(keepingCapacity: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        curFocusedTextField = textField
        if textField.tag <= 0 {
            return
        }
        
        if let _ = mState[textField.tag] {
            
        } else {
            textField.text = ""
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        curFocusedTextField = nil
        if textField.tag > 0 {
            mState[textField.tag] = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

