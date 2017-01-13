//
//  ViewController.swift
//  MemeMe
//
//  Created by pk on 1/4/17.
//  Copyright © 2017 TinyAppsDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textBottom: UITextField!
    
    struct Meme {
        var top: String!
        var bottom: String!
        var origImg: UIImage!
        var memeImg: UIImage!
    }
    
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -5.0,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    var mTextDelegate: TextDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTextDelegate = TextDelegate(viewController: self)
        
        textTop.delegate = mTextDelegate
        textTop.defaultTextAttributes = memeTextAttributes
        textTop.textAlignment = NSTextAlignment.center
        
        textBottom.delegate = mTextDelegate
        textBottom.defaultTextAttributes = memeTextAttributes
        textBottom.textAlignment = NSTextAlignment.center
        
        buttonCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        resetToDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
            buttonShare.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func resetToDefault() {
        mTextDelegate.reset()
        
        imageView.image = nil
        textTop.text = "TOP"
        textBottom.text = "BOTTOM"
        buttonShare.isEnabled = false
        
    }
    
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        resetToDefault()
    }
    
    func keyboardWillShow(_ notification:Notification) {
        self.view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        return (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func generateMemeImage() -> UIImage {
        toolbarTop.isHidden = true
        toolbarBottom.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbarTop.isHidden = false
        toolbarBottom.isHidden = false
        
        return img
    }
    
    @IBAction func onClickBtnShare(_ sender: Any) {
        let img = generateMemeImage()
        let controller = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            activityType, completed, returnedItems, activityError -> Void in
            self.save(img)
        }
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func save(_ img: UIImage) {
        let meme = Meme(top: textTop.text!, bottom: textBottom.text!, origImg: imageView.image, memeImg: img)
    }
    
}

