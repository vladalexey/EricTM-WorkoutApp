//
//  PlayerViewController.swift
//  EricTM
//
//  Created by Phan Quân on 7/2/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit
import Foundation
import AVKit

class PlayerViewController: AVPlayerViewController {
    
    @IBOutlet var doneButtonSubview: UIView!
    
    var playerPlaying: Bool = true

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var doneButton: UIButton = {
        
        let button = UIButton(type: .system)
        
//        button.frame = CGRect(x: 40, y: 40, width: 40, height: 40)
        button.setImage(UIImage(named: "X"), for: .normal)
        button.tintColor = UIColor.white
//        button.setTitle("Done", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(PlayerViewController.doneButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        return button
        }()
    
    lazy var playButton: UIButton = {
        
        let button = UIButton(type: .system)
        
//        button.frame = CGRect(x: 40, y: 300, width: 40, height: 40)
        button.setImage(UIImage(named: "PAUSE"), for: .normal)
        button.tintColor = UIColor.white
//        button.setTitle("Pause", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(PlayerViewController.playButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil) //TODO: Hide buttons after video begins to play
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view == self.view {
            print("appear")
            playButton.isHidden = false
            doneButton.isHidden = false
        }
    }
    
    @objc func buttonDisappear() {
        print("disappear")
        playButton.isHidden = true
        doneButton.isHidden = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showsPlaybackControls = false
        
        
        self.player?.play()
//        self.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil) //TODO: Hide buttons after video begins to play
        self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.contentOverlayView?.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: (contentOverlayView?.centerYAnchor)!).isActive = true
        
        self.contentOverlayView?.addSubview(playButton)
        playButton.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 300).isActive = true
        playButton.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.contentOverlayView?.addSubview(doneButton)
        doneButton.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 300).isActive = true
        doneButton.leftAnchor.constraint(equalTo: (contentOverlayView?.leftAnchor)!, constant: 80).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        


        // Do any additional setup after loading the view.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

//        if keyPath == "rate" {
//            if let rate = change?[NSKeyValueChangeKey.newKey] as? Float {
//
//                print(change)
//                    if rate == 0.0 {
//
//                    if player?.timeControlStatus == .paused {
//
//                        print("playback stopped")
//
//                    }
//                } else if rate == 1.0 {
//
//                    if player?.timeControlStatus == .playing {
//                        print("playback")
//                    }
//                }
//            }
       if keyPath == "currentItem.loadedTimeRanges" {
            print(change)
        }
    }
    
    @objc func doneButtonPressed(sender: UIButton) {
        print("doneButton")
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func playButtonPressed(sender: UIButton) {
        
        if playerPlaying == false {
            self.player?.play()
//            playButton.setTitle("Pause", for: .normal)
            playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            playerPlaying = true
            print("playButton")
        } else {
            self.player?.pause()
//            playButton.setTitle("Play", for: .normal)
            playButton.setImage(UIImage(named: "PLAY"), for: .normal)
            playerPlaying = false
            print("pauseButton")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
