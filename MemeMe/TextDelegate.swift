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
    let mViewController: MemeEditorViewController
    var mState = [Int:Bool]()
    var curFocusedTextField: UITextField?
    var shouldTrackState = true
    
    init(viewController: MemeEditorViewController) {
        mViewController = viewController
    }
    
    func reset(shouldTrackState: Bool) {
        self.shouldTrackState = shouldTrackState
        if let textField = curFocusedTextField {
            textField.resignFirstResponder()
        }
        mState.removeAll(keepingCapacity: true)
    }
    
    func getCurFocusedTextField() -> UITextField? {
        return curFocusedTextField
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        curFocusedTextField = textField
        if textField.tag <= 0 {
            return
        }
        
        if shouldTrackState {
            if let _ = mState[textField.tag] {
            
            } else {
                textField.text = ""
            }
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
        return true
    }
    
}

