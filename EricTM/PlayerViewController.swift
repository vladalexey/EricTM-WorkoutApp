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

import FirebaseStorage

class PlayerViewController: AVPlayerViewController {
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    
    var playerPlaying: Bool = true
    var showPlayDoneButton: Bool = true
    
    var queuePlayer = AVQueuePlayer()
    var listVideos = [AVPlayerItem]()
    
    var workoutCode = String()
    var videoCount = Int()
    
    let controlView: UIImageView = {
        
        let controlview = UIImageView(image: UIImage(named: "PLAYER BG"))
        controlview.translatesAutoresizingMaskIntoConstraints = false
        controlview.alpha = 0.5

//        controlview.addBlurEffect()

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = controlview.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        controlview.sendSubview(toBack: blurEffectView)
        
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
    
    lazy var forward15: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "15FORWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forward15(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()

    lazy var backward15: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "15BACKWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backward15(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    lazy var forward: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "FORWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forward(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    lazy var backward: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "BACKWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backward(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    lazy var airplay: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "AIRPLAY"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(airplayButton(sender:)), for: UIControlEvents.touchUpInside)  //TODO: Airplay function
        
        return button
    }()
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    
    func setupUI() {
        
        self.view.isMultipleTouchEnabled = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.contentOverlayView?.addSubview(topView)
        
        let tapOnTopView = UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.handleTap))
        topView.addGestureRecognizer(tapOnTopView)
        
        
        self.contentOverlayView?.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: (contentOverlayView?.centerYAnchor)!).isActive = true
        
        
        self.contentOverlayView?.insertSubview(controlView, aboveSubview: topView)
        controlView.alpha = 0.5
        controlView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        controlView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 20).isActive = true
        controlView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.contentOverlayView?.insertSubview(playButton, aboveSubview: controlView)
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        playButton.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.contentOverlayView?.insertSubview(doneButton, aboveSubview: controlView)
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        doneButton.leftAnchor.constraint(equalTo: (controlView.leftAnchor), constant: 20).isActive = true
        
        self.contentOverlayView?.insertSubview(backward15, aboveSubview: controlView)
        backward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward15.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        backward15.rightAnchor.constraint(equalTo: (playButton.leftAnchor), constant: -50).isActive = true
        
        
        self.contentOverlayView?.insertSubview(forward15, aboveSubview: controlView)
        forward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward15.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        forward15.leftAnchor.constraint(equalTo: (playButton.rightAnchor), constant: 50).isActive = true
        
        self.contentOverlayView?.insertSubview(forward, aboveSubview: controlView)
        forward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        forward.leftAnchor.constraint(equalTo: (playButton.rightAnchor), constant: 120).isActive = true
        
        self.contentOverlayView?.insertSubview(backward, aboveSubview: controlView)
        backward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        backward.rightAnchor.constraint(equalTo: (playButton.leftAnchor), constant: -120).isActive = true
        
        self.contentOverlayView?.insertSubview(airplay, aboveSubview: controlView)
        airplay.heightAnchor.constraint(equalToConstant: 40).isActive = true
        airplay.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        airplay.rightAnchor.constraint(equalTo: (controlView.rightAnchor), constant: -20).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupUI()
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        videoCount = 0
        
        let random1 = Int(arc4random_uniform(12) + 1)  // get random number
        let videoName1: String = "WO_Ep" + String(random1) + ".mp4"  // get random workout label
    
        videoReference.child(videoName1).downloadURL(completion: { (url, error) in
            if error != nil {
                print("Error" + videoName1)
                self.exitVideoPlayer()
                
            } else {
                
                self.videoCount += 1
                print(videoName1)
                
                let url1: URL = url!
                let item1 = AVPlayerItem(url: url1)
                
                item1.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
                item1.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                item1.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                item1.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
                item1.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                
                var random2: Int
                
                repeat {
                    random2 = Int(arc4random_uniform(12) + 1)
                } while random1 == random2
                
                let videoName2: String = "WO_Ep" + String(random2) + ".mp4"
                
                self.videoReference.child(videoName2).downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Error 2" + videoName2)
                        self.exitVideoPlayer()
                        
                    } else {
                        self.videoCount += 1
                        print(videoName2)
                        
                        let url2: URL = url!
                        let item2 = AVPlayerItem(url: url2)
                        
                        item2.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
                        item2.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                        item2.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                        item2.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
                        item2.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                        
                        var random3: Int
                        
                        repeat {
                            random3 = Int(arc4random_uniform(12) + 1)
                        } while (random3 == random2) || (random3 == random1)
                        
                        let videoName3: String = "WO_Ep" + String(random3) + ".mp4"
                        
                        self.videoReference.child(videoName3).downloadURL(completion: { (url, error) in
                            if error != nil {
                                print("Error 3" + videoName3)
                                self.exitVideoPlayer()
                                
                            } else {
                                self.videoCount += 1
                                print(videoName3)
                                
                                let url3: URL = url!
                                let item3 = AVPlayerItem(url: url3)
                                
                                item3.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
                                item3.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                                item3.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                                item3.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
                                item3.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                                
                                self.queuePlayer = AVQueuePlayer(items: [item1, item2, item3])
                                self.listVideos = [item1, item2, item3]
                                print(self.queuePlayer.items().count)
                                
                                self.player = self.queuePlayer
                            }
                        })
                    }
                })
            }
        })
    }
    
    @objc func handleTap(tap: UIGestureRecognizer) {
        
        if tap.state == UIGestureRecognizerState.ended {
            
            let point = tap.location(in: self.view)
            
            let pointInTopView = self.topView.convert(point, from: self.view)
            let pointInCtrlView = self.controlView.convert(point, from: self.view)
            
            if (self.topView.bounds.contains(pointInTopView)) && !(self.controlView.bounds.contains(pointInCtrlView)) && self.showPlayDoneButton {
                
                print("[handleTap] Tap is inside topView -> Disappear")
                
                let disappearAnimationControll = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                    
                    self.toggleHidden()
    
                }
                
                disappearAnimationControll.startAnimation()
                
            } else if (self.topView.bounds.contains(pointInTopView)) && self.showPlayDoneButton != true {
                
                print("[handleTap] Tap is inside topView -> Reappear")
                
                let disappearAnimationControll = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                    
                    self.toggleHidden()
                    
                    
                }
                
                disappearAnimationControll.startAnimation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
                    
                    let disappearAnimationControll = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                        
                        if self.showPlayDoneButton == true {
                            
                            self.showPlayDoneButton = false
                            
                            self.controlView.alpha = 0.0
                            self.playButton.alpha = 0.0
                            self.doneButton.alpha = 0.0
                            self.forward15.alpha = 0.0
                            self.backward15.alpha = 0.0
                            self.forward.alpha = 0.0
                            self.backward.alpha = 0.0
                            self.airplay.alpha = 0.0
                            
                        }

                    }
                    
                    disappearAnimationControll.startAnimation()
                    
                }
                
            }
        }
    }
    
    @objc func toggleHiddenAuto() {
        
        if showPlayDoneButton == true {
            
            self.showPlayDoneButton = false
            
            self.controlView.alpha = 0.0
            self.playButton.alpha = 0.0
            self.doneButton.alpha = 0.0
            self.forward15.alpha = 0.0
            self.backward15.alpha = 0.0
            self.forward.alpha = 0.0
            self.backward.alpha = 0.0
            self.airplay.alpha = 0.0
            
        } else {
            
            self.showPlayDoneButton = true
            
            self.controlView.alpha = 0.5
            self.playButton.alpha = 1.0
            self.doneButton.alpha = 1.0
            self.forward15.alpha = 1.0
            self.backward15.alpha = 1.0
            self.forward.alpha = 1.0
            self.backward.alpha = 1.0
            self.airplay.alpha = 1.0
        }
        
    }
    
    func toggleHidden() {
        
        if showPlayDoneButton == true {
            
            self.showPlayDoneButton = false
            
            self.controlView.alpha = 0.0
            self.playButton.alpha = 0.0
            self.doneButton.alpha = 0.0
            self.forward15.alpha = 0.0
            self.backward15.alpha = 0.0
            self.forward.alpha = 0.0
            self.backward.alpha = 0.0
            self.airplay.alpha = 0.0

        } else {
            
            self.showPlayDoneButton = true
            
            self.controlView.alpha = 0.5
            self.playButton.alpha = 1.0
            self.doneButton.alpha = 1.0
            self.forward15.alpha = 1.0
            self.backward15.alpha = 1.0
            self.forward.alpha = 1.0
            self.backward.alpha = 1.0
            self.airplay.alpha = 1.0
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.player?.play()
        self.showsPlaybackControls = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            
            let disappearAnimationControll = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                
                if self.showPlayDoneButton == true {
                    
                    self.showPlayDoneButton = false
                    
                    self.controlView.alpha = 0.0
                    self.playButton.alpha = 0.0
                    self.doneButton.alpha = 0.0
                    self.forward15.alpha = 0.0
                    self.backward15.alpha = 0.0
                    self.forward.alpha = 0.0
                    self.backward.alpha = 0.0
                    self.airplay.alpha = 0.0
                    
                }
                
            }
            
            disappearAnimationControll.startAnimation()
            
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
            
        case "status":
            if player?.status == .readyToPlay {
                
                activityIndicatorView.stopAnimating()
                print("ready to play")
                
                player?.play()
            }
            
        case "loadedTimeRanges":
            activityIndicatorView.stopAnimating()
            print("loadedTimeRanges")

        case "playbackBufferEmpty":
            activityIndicatorView.startAnimating()
            print("playbackBufferEmpty")

        case "playbackLikelyToKeepUp":
            activityIndicatorView.stopAnimating()
            print("playbackLikelyToKeepUp")

        case "playbackBufferFull":
            activityIndicatorView.stopAnimating()
            print("playbackBufferFull")
  
        default:
            print(change!)
        }
    }
    
    //MARK: Exit video
    func exitVideoPlayer() {
        
        print("exit video player")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Done button
    @objc func doneButtonPressed(sender: UIButton) {
        
        print("doneButtonPressed")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Play button
    @objc func playButtonPressed(sender: UIButton) {
        
        if playerPlaying == false {
            self.player?.play()
            playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            playerPlaying = true
            print("playButtonPressed")
        } else {
            self.player?.pause()
            playButton.setImage(UIImage(named: "PLAY"), for: .normal)
            playerPlaying = false
            print("pauseButtonPressed")
        }
    }
    
    //MARK: Forward 15 seconds selected
    @objc func forward15(sender: UIButton) {
        
        self.player?.pause()
        
        let seekDuration = CMTimeMake(15, 1)
        let currentTime: CMTime = (self.player?.currentTime())!
        let newTime = seekDuration + currentTime
        self.player?.seek(to: newTime)
        
        print("forward15ButtonPressed")
        
        self.player?.play()
    }
    
    //MARK: Backward 15 seconds selected
    @objc func backward15(sender: UIButton) {
        
        self.player?.pause()
        
        let seekDuration = CMTimeMake(15, 1)
        let currentTime: CMTime = (self.player?.currentTime())!
        if currentTime - seekDuration > kCMTimeZero {                   // check if seek duration is less than 15 seconds
            
            let newTime = currentTime - seekDuration
            self.player?.seek(to: newTime)
            
        } else {
            
            self.player?.seek(to: kCMTimeZero)
        }
        
        print("backward15ButtonPressed")
        
        self.player?.play()
    }
    
    //MARK: Forward selected
    @objc func forward(sender: UIButton) {
        
        self.player?.pause()
        
        self.queuePlayer.advanceToNextItem()
        self.player?.seek(to: kCMTimeZero)
        
        print("forwardButtonPressed")
        
        self.player?.play()
    }
    
    //MARK: Backward selected
    @objc func backward(sender: UIButton) {
        
        for item in listVideos {                    // get and insert previous video into queue
            
            if item == self.player?.currentItem {
                
                let currentIndex = listVideos.index(of: item)
                print(currentIndex!)
                
                if currentIndex! >= 1 {
                    
                    self.player?.pause()
                    
                    let moveBackIndex = currentIndex! - 1
                
                    let currentItem = self.player?.currentItem
                    let newItem = listVideos[moveBackIndex]
                    
                    self.queuePlayer.replaceCurrentItem(with: newItem)
                    print("replace video successfully")
                    
                    self.player?.pause()
                    
                    self.queuePlayer.insert(currentItem!, after: newItem)
                    print("inserted curent video")

                    self.player?.seek(to: kCMTimeZero)
                    
                    print("backwardButtonPressed")
                    
                    self.player?.play()
                }
            }
        }
    }
    
    @objc func airplayButton(sender: UIButton) {
        
        print("airplayButtonPressed")
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
