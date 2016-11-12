//
//  AudioVC.swift
//  Spot
//
//  Created by Bennett Hartrick on 11/12/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation
import UIKit

class AudioVC: UIViewController {
    
    var image = UIImage()
    var mainSongTitle = String()
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    
    override func viewDidLoad() {
        songTitle.text = mainSongTitle
        background.image = image
        mainImageView.image = image
    }
    
}
