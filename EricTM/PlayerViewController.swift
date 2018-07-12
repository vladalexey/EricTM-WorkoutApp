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
        
        controlview.addBlurEffect()
//
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurView = UIVisualEffectView(effect: blur)
//
//        blurView.alpha = 0.5
//        blurView.frame = controlview.bounds
//        blurView.roundedAllCorner()

//        controlview.addSubview(blurView)
        
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
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//
//        if let firstTouch = touches.first {
//
//            let hitView = self.contentOverlayView?.hitTest(firstTouch.location(in: self.contentOverlayView), with: event)
//
//            if hitView === topView {
//                print("tap on topView")
//                handleTap()
//            }
//        }
//    }
    
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
//        controlView.isUserInteractionEnabled = false
        controlView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        controlView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 20).isActive = true
        controlView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.contentOverlayView?.insertSubview(playButton, aboveSubview: controlView)
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        playButton.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.contentOverlayView?.insertSubview(doneButton, aboveSubview: controlView)
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        doneButton.leftAnchor.constraint(equalTo: (controlView.leftAnchor), constant: 20).isActive = true
        
        self.contentOverlayView?.insertSubview(backward15, aboveSubview: controlView)
        backward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward15.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        backward15.rightAnchor.constraint(equalTo: (playButton.leftAnchor), constant: -50).isActive = true
        
        
        self.contentOverlayView?.insertSubview(forward15, aboveSubview: controlView)
        forward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward15.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        forward15.leftAnchor.constraint(equalTo: (playButton.rightAnchor), constant: 50).isActive = true
        
        self.contentOverlayView?.insertSubview(forward, aboveSubview: controlView)
        forward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        forward.leftAnchor.constraint(equalTo: (playButton.rightAnchor), constant: 120).isActive = true
        
        self.contentOverlayView?.insertSubview(backward, aboveSubview: controlView)
        backward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward.topAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: 310).isActive = true
        backward.rightAnchor.constraint(equalTo: (playButton.leftAnchor), constant: -120).isActive = true
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
            } else {
                
                self.videoCount += 1
                print(videoName1)
                
                let url1: URL = url!
                let item1 = AVPlayerItem(url: url1)
                
                var random2: Int
                
                repeat {
                    random2 = Int(arc4random_uniform(12) + 1)
                } while random1 == random2
                
                let videoName2: String = "WO_Ep" + String(random2) + ".mp4"
                
                self.videoReference.child(videoName2).downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Error 2" + videoName2)
                    } else {
                        self.videoCount += 1
                        print(videoName2)
                        
                        let url2: URL = url!
                        let item2 = AVPlayerItem(url: url2)
                        
                        var random3: Int
                        
                        repeat {
                            random3 = Int(arc4random_uniform(12) + 1)
                        } while (random3 == random2) || (random3 == random1)
                        
                        let videoName3: String = "WO_Ep" + String(random3) + ".mp4"
                        
                        self.videoReference.child(videoName3).downloadURL(completion: { (url, error) in
                            if error != nil {
                                print("Error 3" + videoName3)
                            } else {
                                self.videoCount += 1
                                print(videoName3)
                                
                                let url3: URL = url!
                                let item3 = AVPlayerItem(url: url3)
                                
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
            if (self.topView.bounds.contains(pointInTopView)) && !(self.controlView.bounds.contains(pointInCtrlView)) {
                print("[handleTap] Tap is inside regionView")
        
                if showPlayDoneButton == true {
                    
                    showPlayDoneButton = false
                    toggleHidden()
                } else {
                    
                    showPlayDoneButton = true
                    toggleHidden()
                }
            }
        }
    }
    
    func toggleHidden() {
        
        self.controlView.isHidden = !self.controlView.isHidden
        self.playButton.isHidden = !self.playButton.isHidden
        self.doneButton.isHidden = !self.doneButton.isHidden
        self.forward15.isHidden = !self.forward15.isHidden
        self.backward15.isHidden = !self.backward15.isHidden
        self.forward.isHidden = !self.forward.isHidden
        self.backward.isHidden = !self.backward.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(listVideos.count)
        
        self.player?.play()
        
//        self.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        self.player?.addObserver(self, forKeyPath: "playerController.status", options: NSKeyValueObservingOptions.new, context: nil) //TODO: Hide buttons after video begins to play

        
        self.showsPlaybackControls = false

//        self.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
    
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
                
                activityIndicatorView.startAnimating()
                print("Waiting to get metadata")
                print(player?.reasonForWaitingToPlay!)
                
            } else if player?.timeControlStatus != .waitingToPlayAtSpecifiedRate {
                
                activityIndicatorView.stopAnimating()
            }
            
            if player?.status == .readyToPlay {
                
                activityIndicatorView.stopAnimating()
                player?.play()
                
            } else if player?.status != .readyToPlay {
                
                activityIndicatorView.startAnimating()
            }
            
            if player?.timeControlStatus == .playing {
                
                activityIndicatorView.stopAnimating()
            }

        } else if keyPath == "currentItem.loadedTimeRanges" {
            print(change!)
        }
    }
    
    //MARK: Done button
    @objc func doneButtonPressed(sender: UIButton) {
        print("doneButton")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Play button
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
    
    //MARK: Forward 15 seconds selected
    @objc func forward15(sender: UIButton) {
        
        self.player?.pause()
        
        let seekDuration = CMTimeMake(15, 1)
        let currentTime: CMTime = (self.player?.currentTime())!
        let newTime = seekDuration + currentTime
        self.player?.seek(to: newTime)
        
        self.player?.play()
    }
    
    //MARK: Backward 15 seconds selected
    @objc func backward15(sender: UIButton) {
        
        self.player?.pause()
        
        let seekDuration = CMTimeMake(15, 1)
        let currentTime: CMTime = (self.player?.currentTime())!
        if currentTime - seekDuration < kCMTimeZero {                   // check if seek duration is less than 15 seconds
            
            let newTime = currentTime - seekDuration
            self.player?.seek(to: newTime)
            
        } else {
            
            self.player?.seek(to: kCMTimeZero)
        }
        
        self.player?.play()
    }
    
    //MARK: Forward selected
    @objc func forward(sender: UIButton) {
        
        self.player?.pause()
        
        self.queuePlayer.advanceToNextItem()
        
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
                    print("inserted video")

                    self.player?.seek(to: kCMTimeZero)
                    
                    self.player?.play()
                }
            }
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
