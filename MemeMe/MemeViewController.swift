//
//  MemeViewController.swift
//  MemeMe
//
//  Created by pk on 1/21/17.
//  Copyright © 2017 TinyAppsDev. All rights reserved.
//

import Foundation
import UIKit

class MemeViewController : UIViewController {
    var memeIndex: Int = 0

    @IBOutlet weak var memeImageView: UIImageView!
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tabBarController?.tabBar.isHidden = true
        
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex]
        memeImageView.image = meme.memeImg
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(gotoMemeEditor)
        )
    }
    
    func gotoMemeEditor() {
        MemeEditorViewController.presentView(self, memeIndex: self.memeIndex, completion: nil)
    }
    
    static func pushView(_ callee: UIViewController, memeIndex: Int) {
        let controller = callee.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        controller.memeIndex = memeIndex
        callee.navigationController!.pushViewController(controller, animated: true)
    }
    
}
