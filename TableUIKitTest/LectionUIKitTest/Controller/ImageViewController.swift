//
//  ImageViewController.swift
//  LectionUIKitTest
//
//  Created by Никита Максаковский on 07.11.2019.
//  Copyright © 2019 Konstantin Polin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var GifView: UIImageView!
    @IBOutlet var greetingLabel: UILabel!
    
    var name: String = ""
    var surname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GifView.loadGif(name: "Ded")
        greetingLabel.text = "Hello, \(name) \(surname)"
    }
    
    
}
