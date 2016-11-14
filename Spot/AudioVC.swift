//
//  AudioVC.swift
//  Spot
//
//  Created by Bennett Hartrick on 11/12/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioVC: UIViewController {
    
    var image = UIImage()
    var mainSongTitle = String()
    var mainPreviewURL = String()
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        songTitle.text = mainSongTitle
        background.image = image
        mainImageView.image = image
        
        downloadFileFromURL(url: URL(string: mainPreviewURL)!)
        
        playPauseButton.setTitle("Pause", for: .normal)
    }
    
    func downloadFileFromURL(url: URL) {
        
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (customURL, response, error) in
            self.play(url: customURL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL) {
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
        
    }
    
}
