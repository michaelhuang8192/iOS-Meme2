//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by pk on 1/4/17.
//  Copyright © 2017 TinyAppsDev. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textBottom: UITextField!
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -5.0,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]
    
    var mTextDelegate: TextDelegate!
    var mMemeIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTextDelegate = TextDelegate(viewController: self)
        resetToDefault()
    }
    
    func configureTextField(textField: UITextField, content: String) {
        textField.text = content
        textField.delegate = mTextDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        buttonCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func pickImageFromSource(_ source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImageFromSource(.camera)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImageFromSource(.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
            buttonShare.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func resetToDefault() {
        var top = "TOP"
        var bottom = "BOTTOM"
        var image: UIImage? = nil
        if mMemeIndex >= 0 {
            let meme = (UIApplication.shared.delegate as! AppDelegate).memes[mMemeIndex]
            top = meme.top
            bottom = meme.bottom
            image = meme.origImg
        }
        
        mTextDelegate.reset(shouldTrackState: mMemeIndex < 0)
        configureTextField(textField:textTop, content:top)
        configureTextField(textField:textBottom, content:bottom)
        imageView.image = image
        buttonShare.isEnabled = image != nil
    }
    
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        goback(true)
        //resetToDefault()
    }
    
    func keyboardWillShow(_ notification:Notification) {
        guard let textField = mTextDelegate.getCurFocusedTextField() else {
            return
        }
        
        guard textField == textBottom else {
            return
        }
        
        self.view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y = 0
        }
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
        
        let rect = CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: view.frame.size.height
        )
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: rect, afterScreenUpdates: true)
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
            if completed {
                self.save(img)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func save(_ img: UIImage) {
        let meme = Meme(top: textTop.text!, bottom: textBottom.text!, origImg: imageView.image, memeImg: img)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if mMemeIndex < 0 {
            appDelegate.memes.append(meme)
        } else {
            appDelegate.memes[mMemeIndex] = meme
        }
        
        goback(false)
    }
    
    func goback(_ animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
    
    static func presentView(_ callee: UIViewController, memeIndex: Int, completion: (() -> Void)? = nil) {
        let controller = callee.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        controller.mMemeIndex = memeIndex
        callee.present(controller, animated: true, completion: nil)
    }
    
}

