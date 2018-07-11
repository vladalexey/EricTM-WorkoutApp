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
    
    var playerPlaying: Bool = true
    var showPlayDoneButton: Bool = true
    
    let controlView: UIImageView = {
        
        let controlview = UIImageView(image: UIImage(named: "PLAYER BG"))
        controlview.translatesAutoresizingMaskIntoConstraints = false
        controlview.alpha = 0.5
        
        controlview.addBlurEffect()
//
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurView = UIVisualEffectView(effect: blur)
//
//        blurView.alpha = 0.5
//        blurView.frame = controlview.bounds
//        blurView.roundedAllCorner()

//        controlview.addSubview(blurView)
//        controlview.isUserInteractionEnabled = false
        controlview.roundedAllCorner()
        return controlview
    }()
    
    let topView: UIView = {
        let topview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        topview.backgroundColor = UIColor.clear
        return topview
    }()

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var doneButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "X"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        return button
        }()
    
    lazy var playButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "PAUSE"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        
        
        self.contentOverlayView?.addSubview(topView)
        
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.handleTap)))
        
        
        self.contentOverlayView?.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: (contentOverlayView?.centerYAnchor)!).isActive = true
        
        
        self.contentOverlayView?.addSubview(controlView)
        controlView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        controlView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 20).isActive = true
        controlView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.contentOverlayView?.addSubview(playButton)
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        playButton.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.contentOverlayView?.addSubview(doneButton)
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        doneButton.leftAnchor.constraint(equalTo: (contentOverlayView?.leftAnchor)!, constant: 80).isActive = true
        
        
//        self.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil) //TODO: Hide buttons after video begins to play
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//
//        if touch?.view == self.view {
//            print("appear")
//            playButton.isHidden = false
//            doneButton.isHidden = false
//        }
//    }
//
//    @objc func buttonDisappear() {
//        print("disappear")
//        playButton.isHidden = true
//        doneButton.isHidden = true
//    }
    
    @objc func handleTap() {
        if showPlayDoneButton == true {
            
            showPlayDoneButton = false
            self.controlView.isHidden = true
            self.playButton.isHidden = true
            self.doneButton.isHidden = true
        } else {
            showPlayDoneButton = true
            self.controlView.isHidden = false
            self.playButton.isHidden = false
            self.doneButton.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player?.play()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        self.showsPlaybackControls = false

        self.player?.addObserver(self, forKeyPath: "playerController.status", options: NSKeyValueObservingOptions.new, context: nil) //TODO: Hide buttons after video begins to play
    
        // Do any additional setup after loading the view.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "playerController.status" {
            
            if player?.timeControlStatus == .paused {

                if playerPlaying {
                    player?.play()
                }
            }
        
            if player?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                
//                activityIndicatorView.startAnimating()
                print("Waiting to get metadata")
                print(player?.reasonForWaitingToPlay!)
            }
            
            if player?.status == .readyToPlay {
                
                activityIndicatorView.stopAnimating()
                player?.play()
                
            } else if player?.timeControlStatus == .playing {
                
                activityIndicatorView.stopAnimating()
            }

        } else if keyPath == "currentItem.loadedTimeRanges" {
            print(change!)
        }
    }
    
    @objc func doneButtonPressed(sender: UIButton) {
        print("doneButton")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func playButtonPressed(sender: UIButton) {
        
        if playerPlaying == false {
            self.player?.play()
            playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            playerPlaying = true
            print("playButton")
        } else {
            self.player?.pause()
            playButton.setImage(UIImage(named: "PLAY"), for: .normal)
            playerPlaying = false
            print("pauseButton")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
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
