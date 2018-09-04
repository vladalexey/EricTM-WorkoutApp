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
import MediaPlayer

import FirebaseStorage

class PlayerViewController: AVPlayerViewController {
    
    var timerTest = Timer()
    var sendMetadataTimer = Timer()
    var nowPlayingInfo = [String: Any]()
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    
    var downloadTask1: StorageReference {
        return Storage.storage().reference()
    }
    
    var downloadQueue = DispatchQueue(label: "DownloadVideo")
    
    var random = [Int()]
    
    var playerPlaying: Bool = true
    var showPlayDoneButton: Bool = true
    
    var disappearAnimationControl = UIViewPropertyAnimator()
    var reappearAnimationControl = UIViewPropertyAnimator()
    
    var queuePlayer = AVQueuePlayer()
    var listVideos = [AVPlayerItem]()

    var workoutCode = String()
    var workoutName = String()
    var myIndex = Int()
    var videoCount = Int()
    var numberOfWorkout = 2 // should change to corresponding numbers of total workouts needed

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    let routePickerView: AVRoutePickerView = {
        
        let routepickerview = AVRoutePickerView()
        
        routepickerview.translatesAutoresizingMaskIntoConstraints = false
        routepickerview.tintColor = UIColor.white
        routepickerview.backgroundColor = UIColor.clear
        
        routepickerview.isUserInteractionEnabled = true
        
        return routepickerview
    }()
    
    let controlView: UIView = {
        
        let controlview = UIImageView(image: UIImage(named: "PLAYER BG 2"))
        controlview.translatesAutoresizingMaskIntoConstraints = false
//        controlview.alpha = 0.5

//        controlview.addBlurEffect()
//        controlview.roundedAllCorner()
        
        controlview.isUserInteractionEnabled = true
        
        return controlview
    }()
    
    let topView: IgnoreTouchView = {
        let topview = IgnoreTouchView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        topview.backgroundColor = UIColor.clear
        return topview
    }()

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
//        aiv.startAnimating()
        return aiv
    }()
    
    //MARK: Done button init
    lazy var doneButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "X"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonPressed), for: UIControlEvents.touchUpInside)
        
        button.isUserInteractionEnabled = true
        
        return button
        }()
    
    //MARK: Play button init
    lazy var playButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "PAUSE"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonPressed), for: UIControlEvents.touchUpInside)
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    //MARK: Forward15 button init
    lazy var forward15: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "15FORWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forward15Pressed), for: UIControlEvents.touchUpInside)
        
        button.isUserInteractionEnabled = true
        
        return button
    }()

    //MARK: Backward15 button init
    lazy var backward15: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "15BACKWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backward15Pressed), for: UIControlEvents.touchUpInside)
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    //MARK: Forward button init
    lazy var forward: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "FORWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forwardPressed), for: UIControlEvents.touchUpInside)
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    //MARK: Backward button init
    lazy var backward: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "BACKWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backwardPressed), for: UIControlEvents.touchUpInside)
        
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    func setupUI() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        self.contentOverlayView?.addSubview(topView)
        
        let tapOnTopView = UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.handleTap))
        
        let doubleTapOnTopView = UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.handleDoubleTap))
        doubleTapOnTopView.numberOfTapsRequired = 2

        self.contentOverlayView?.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: (contentOverlayView?.centerYAnchor)!).isActive = true
        
        self.contentOverlayView?.addSubview(controlView)

        controlView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        controlView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 20).isActive = true
        controlView.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        contentOverlayView?.addGestureRecognizer(tapOnTopView)
        
        tapOnTopView.require(toFail: doubleTapOnTopView)
        
        self.controlView.addSubview(playButton)
        self.controlView.bringSubview(toFront: playButton)
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        playButton.centerXAnchor.constraint(equalTo: (contentOverlayView?.centerXAnchor)!).isActive = true
        
        
        self.controlView.addSubview(doneButton)
        self.controlView.bringSubview(toFront: doneButton)
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        doneButton.leftAnchor.constraint(equalTo: (controlView.leftAnchor), constant: 20).isActive = true
        
        self.controlView.addSubview(backward15)
        self.controlView.bringSubview(toFront: backward15)
        backward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward15.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        backward15.rightAnchor.constraint(equalTo: (playButton.centerXAnchor), constant: -60).isActive = true
        
        
        self.controlView.addSubview(forward15)
        self.controlView.bringSubview(toFront: forward15)
        forward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward15.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        forward15.leftAnchor.constraint(equalTo: (playButton.centerXAnchor), constant: 60).isActive = true
        
        self.controlView.addSubview(forward)
        self.controlView.bringSubview(toFront: forward)
        forward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        forward.leftAnchor.constraint(equalTo: (playButton.centerXAnchor), constant: 140).isActive = true
        
        self.controlView.addSubview(backward)
        self.controlView.bringSubview(toFront: backward)
        backward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        backward.rightAnchor.constraint(equalTo: (playButton.centerXAnchor), constant: -140).isActive = true
        
        self.controlView.addSubview(routePickerView)
        self.controlView.bringSubview(toFront: routePickerView)
        routePickerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        routePickerView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        routePickerView.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -20).isActive = true
        
        controlView.addGestureRecognizer(doubleTapOnTopView)
    }
    
    
    func exitVideoPlayer() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let exitVideo = DispatchQueue(label: "exitVideoPlayer")
        
        exitVideo.sync {
            
            UIApplication.shared.endReceivingRemoteControlEvents() // when video ends and app in background
            
            self.player?.pause()
            self.player = nil
            self.queuePlayer.removeAllItems()
            
            NotificationCenter.default.removeObserver(self)
            self.toggleHidden()
            
            checkPortrait()
            
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func checkPortrait() {
        
        let checkPortrait = DispatchQueue(label: "checkPortrait")
        
        checkPortrait.sync {

            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("[Screen Orientation] changing to portrait")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        checkPortrait()
    }
    
    //MARK: Exit video due to Error
    func exitVideoPlayerError() {
        
        print("[Error] Exit video player")
        
        let alertView = UIAlertController(title: "Error", message: "Cannot load videos", preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in

            print("[Error] OK")

            self.navigationController?.popViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }

        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)

        
        let checkPortrait = DispatchQueue(label: "checkPortrait")
        
        checkPortrait.sync {
            
            alertView.dismiss(animated: true, completion: nil)
            
            self.player = nil
            
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("[Error] exit changing to Portrait")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
        }
    }
    
    func checkFileAvailableLocal(nameFileToCheck: String) -> Bool {
        
         //check if file is available local by search name in directory
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(nameFileToCheck) {
            
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("[Check Local] FILE AVAILABLE")
                return true

            } else {
                print("[Check Local] FILE NOT AVAILABLE")
                return false
            }
        } else {
            print("[Check Local] FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    @objc func playRemote() {
        self.queuePlayer.play()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        print("[Remote] play")
    }
    
    @objc func pauseRemote() {
        self.queuePlayer.pause()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        print("[Remote] pause")
        
    }
    
    @objc func forward15Remote() {
        
        if let currentPlayingItem: AVPlayerItem = self.queuePlayer.currentItem {
            
            if currentPlayingItem != listVideos[listVideos.count - 1] {
                
                print("[Remote] forward 15")
                
                let seekDuration = CMTimeMake(15, 1)
                let currentTime: CMTime = (self.queuePlayer.currentItem!.currentTime())
                
                if currentTime + seekDuration > (self.queuePlayer.currentItem!.duration) && !(self.queuePlayer.currentItem! === listVideos[listVideos.count - 1]) {
                    
                    self.queuePlayer.pause()
                    self.queuePlayer.advanceToNextItem()
                    self.queuePlayer.play()
                    self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                    
                    return
                }
                
            } else {
                
                let seekDuration = CMTimeMake(15, 1)
                let currentTime: CMTime = (self.queuePlayer.currentItem!.currentTime())
                
                if currentTime + seekDuration > (self.queuePlayer.currentItem!.duration) && (self.queuePlayer.currentItem! === listVideos[listVideos.count - 1]) {
                    
                    print("[Remote] Exit video when forward 15")
                    exitVideoPlayer()
                    AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
                    
                    return
                }
            }
        
            let seekDuration = CMTimeMake(15, 1)
            let currentTime: CMTime = (self.queuePlayer.currentItem!.currentTime())
            
            self.queuePlayer.currentItem!.seek(to: currentTime + seekDuration, completionHandler: nil)
            self.queuePlayer.play()
        }
    }
    
    @objc func backward15Remote() {
        
        let seekDuration = CMTimeMake(15, 1)
        if let currentItem: AVPlayerItem = self.queuePlayer.currentItem {
            
            let currentTime: CMTime = currentItem.currentTime()
            
            if currentTime - seekDuration > kCMTimeZero {                   // check if remaining time is less than 15 seconds
                
                let newTime = currentTime - seekDuration
                self.queuePlayer.currentItem!.seek(to: newTime, completionHandler: nil)
                self.queuePlayer.play()
                
            } else {
                
                self.queuePlayer.currentItem!.seek(to: kCMTimeZero, completionHandler: nil)
                self.queuePlayer.play()
            }
        }
        print("[Remote] backward15")
    }
    
    @objc func setNowPlayingInfo() {
    
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Eric Workout"
        
        if let image = UIImage(named: "iTunesArtwork") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        guard let currentVideo = self.queuePlayer.currentItem
            else {return}
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentVideo.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = currentVideo.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.queuePlayer.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        
    }
    
    @objc func didEnterBackground() {
        
        sendMetadataTimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(setNowPlayingInfo), userInfo: nil, repeats: true)
        
        let beginRemoteControl = DispatchQueue(label: "beginRemoteControl")
        
            beginRemoteControl.sync {
                
                print("[Remote] Enter background + Begin syncing")
                
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    let _ = try AVAudioSession.sharedInstance().setActive(true)
                    print("[Remote] Set audio session Playback + setActive")
                } catch let error as NSError {
                    print("[Remote] An error occurred when audio session category.\n \(error)")
                }
                
                self.player = nil
                
                UIApplication.shared.beginReceivingRemoteControlEvents()
                self.becomeFirstResponder()
                
                // Get the shared MPRemoteCommandCenter
                let commandCenter = MPRemoteCommandCenter.shared()
                
                commandCenter.playCommand.isEnabled = true
    //            commandCenter.playCommand.addTarget(self, action: #selector(playRemote))

                commandCenter.playCommand.addTarget(handler: { (event) in    // Begin playing the current track
                    
                    if self.queuePlayer.rate == 0 {
                        self.queuePlayer.play()
                        print("[Remote] play")
                    }
                    
                    return MPRemoteCommandHandlerStatus.success})
                
                commandCenter.skipForwardCommand.isEnabled = true
                commandCenter.skipForwardCommand.addTarget(self, action: #selector(self.forward15Remote))
                
                commandCenter.skipBackwardCommand.isEnabled = true
                commandCenter.skipBackwardCommand.addTarget(self, action: #selector(self.backward15Remote))
                
                commandCenter.pauseCommand.isEnabled = true
    //            commandCenter.pauseCommand.addTarget(self, action: #selector(pauseRemote))
                
                commandCenter.pauseCommand.addTarget(handler: { (event) in    // Begin playing the current track
                    
                    if self.queuePlayer.rate > 0 {
                        self.queuePlayer.pause()
                        print("[Remote] pause")
                    }
                    return MPRemoteCommandHandlerStatus.success})
                
                commandCenter.changePlaybackPositionCommand.isEnabled = false  // disable user interaction to change
            }
        
        sendMetadataTimer.fire()
    }
    
    @objc func willEnterForeground() {
        
        let enterForeground = DispatchQueue(label: "enterForeground")
        enterForeground.sync {
            
            print("[Remote] entering foreground + end receiving")
            UIApplication.shared.endReceivingRemoteControlEvents()
            
            self.player = queuePlayer
            self.player?.play()
            
            if UIApplication.shared.statusBarOrientation.isLandscape == false {
                print("[Enter foreground] change to Landscape")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
            }
            
            playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            playerPlaying = true
        }
        
        sendMetadataTimer.invalidate()

    }
    
    func getVideos(videoToGet: VideoExercise, numberDownload: Int) {
        
        let videoName = videoToGet.name
        
        if checkFileAvailableLocal(nameFileToCheck: videoToGet.name) == false {            //check if file is available local by search name in directory
            
            // Download video to stream
            videoReference.child(videoName).downloadURL(completion: { (url, error) in
                if error != nil {
                    
                    print("[Play Video] Error streaming \(error, videoName, numberDownload)" )
                    self.exitVideoPlayerError()
                    return
                    
                } else {
                    
                    videoToGet.serverURL = url!
                    
                    self.videoCount += 1
                    print("[Play Video]" + videoName + String(self.videoCount))
                    
                    let url1: URL = url!
                    let item1 = AVPlayerItem(url: url1)
                    
                    item1.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
                    item1.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                    item1.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                    item1.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
                    item1.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                    
                    self.queuePlayer.insert(item1, after: nil)
                    self.listVideos.append(item1)
                }
            })
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let localURL = documentsURL.appendingPathComponent(videoName)

            // Download to the local system
            downloadTask1.child(videoName).write(toFile: localURL) { url, error in
                if let error = error {
                    
                    print("[Play Video] Error when downloading to local \(error, videoName, numberDownload)" )
                    self.exitVideoPlayerError()
                    return
                    
                } else {
                    
                    print("[Play Video] sucessfully downloaded video \(numberDownload)")
                    
                    videoToGet.localURL = localURL
                }
            }
            
        //MARK: check available = true video 1
        } else {
            
            print("[Play Video] successfully loaded video from local \(videoName)")
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let localURL = documentsURL.appendingPathComponent(videoName)
            
            videoToGet.localURL = localURL            
            
            let item1 = AVPlayerItem(url: localURL)
            
            self.queuePlayer.insert(item1, after: nil)
            self.listVideos.append(item1)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func getRandomList() {
        
        var rand = Int()
        random = [Int(arc4random_uniform(4) + 1)] // get random number //change number to actual number of videos on Firebase
        
        repeat {
            rand = Int(arc4random_uniform(4) + 1)  // get random number //change number to actual number of videos on Firebase
        } while rand == random[0]
        
        random.append(rand)
        
        repeat {
            rand = Int(arc4random_uniform(4) + 1)  // get random number //change number to actual number of videos on Firebase
        } while random[0] == rand || random[1] == rand
        
        random.append(rand)
        print("[Get Random List] \(random)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
        setupUI()
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        videoCount = 0
        
        
        //MARK: Get list of local videos
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files

        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        //MARK: Get randome workout videos
        
        getRandomList()
        queuePlayer.removeAllItems()
        
        let downloadQueue = DispatchQueue.main
        
        let currentWorkout = global.workOutVideos[self.myIndex]
        
        downloadQueue.async {
            self.getVideos(videoToGet: (global.subWorkoutList[currentWorkout.workoutLabel + "Introduction"]?.contain[0])!, numberDownload: 0) // TODO: Uncomment when finalize uploading
        }
        
        downloadQueue.async {
            
            for workout in currentWorkout.containSubworkout {    // get a list of sub-workouts from a Workout and iterate through
                
                let rand = Int(arc4random_uniform(4) + 1)
                
                self.getVideos(videoToGet: workout.contain[rand], numberDownload: rand)  // randomly get one video for each sub-workout
                //TODO: if there are more than 1 consecutive sub-workout of same type, make sure they aren't the same
            }
        }
        
        downloadQueue.async {
            self.getVideos(videoToGet: (global.subWorkoutList[currentWorkout.workoutLabel + "Ending"]?.contain[0])!, numberDownload: 9) // TODO: Uncomment when finalize uploading
        }
        
        self.player = self.queuePlayer
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.queuePlayer.currentItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioInterruptionHandle), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)

        
        self.player?.play()
    }
    
    @objc func handleDoubleTap(tap: UIGestureRecognizer) {
        
        print("[Handle Double Tap] double Tap")
        
        if tap.state == UIGestureRecognizerState.ended {
            
            let point = tap.location(in: self.view)
            
            if controlView.bounds.contains(controlView.convert(point, from: self.view)) {
                print("[Handle Double Tap] invalidate in ctrl view")
                
                timerTest.invalidate()
                enableInteract()
                
                setTimer()
            }
            
            if playButton.bounds.contains(playButton.convert(point, from: self.view)) {
                print("[Handle Double Tap] PlayPause")
                playButtonPressed()
            }
            
            if doneButton.bounds.contains(doneButton.convert(point, from: self.view)) {
                print("[Handle Double Tap] doneButton")
                doneButtonPressed()
            }
            
            if backward15.bounds.contains(backward15.convert(point, from: self.view)) {
                print("[Handle Double Tap] Backward15")
                backward15Pressed()
            }
            
            if backward.bounds.contains(backward.convert(point, from: self.view)) {
                print("[Handle Double Tap] Backward")
                backwardPressed()
            }
            
            if forward15.bounds.contains(forward15.convert(point, from: self.view)) {
                print("[Handle Double Tap] Forward15")
                forward15Pressed()
            }
            
            if routePickerView.bounds.contains(routePickerView.convert(point, from: self.view)) {
                print("[Handle Double Tap] routePickerView")
                airplayButton()
            }
        }
    }
    
    @objc func handleTap(tap: UIGestureRecognizer) {
        
        if tap.state == UIGestureRecognizerState.ended {
            
            disappearAnimationControl = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
                
                self.toggleHidden()
            }
            
            disappearAnimationControl.isInterruptible = true
            
            reappearAnimationControl = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
                self.toggleAppear()
            }
            
            disappearAnimationControl.isInterruptible = true

            let point = tap.location(in: self.view)

            let pointInTopView = self.topView.convert(point, from: self.view)
            let pointInCtrlView = self.controlView.convert(point, from: self.view)
            
            let pointInPlayView = self.playButton.convert(point, from: self.view)
            let pointInDoneView = self.doneButton.convert(point, from: self.view)
            let pointInForward = self.forward.convert(point, from: self.view)
            let pointInForward15 = self.forward15.convert(point, from: self.view)
            let pointInBackward = self.backward.convert(point, from: self.view)
            let pointInBackward15 = self.backward15.convert(point, from: self.view)
            
            let arrayPointButton = [pointInPlayView, pointInDoneView, pointInForward, pointInForward15, pointInBackward, pointInBackward15]
            
            disappearAnimationControl.isReversed = false
            reappearAnimationControl.isReversed = false

            if checkInView(points: arrayPointButton) == false && self.topView.bounds.contains(pointInTopView) && !(self.controlView.bounds.contains(pointInCtrlView)) && self.showPlayDoneButton {

                let disableInteractManualQueue = DispatchQueue(label: "disableInteractManualQueue")
                
                disableInteractManualQueue.sync {
                    print("[Handle Tap] Tap is inside topView -> Disappear")
                    timerTest.invalidate()
                    disableInteract()
                    disableHighlighted()
                    disappearAnimationControl.startAnimation()
                }

            } else if ((self.topView.bounds.contains(pointInTopView)) && self.showPlayDoneButton != true) || disappearAnimationControl.fractionComplete > 0.0 {
                
                let enableInteractQueue = DispatchQueue(label: "enableInteractQueue")
                
                enableInteractQueue.sync {
                    
                    timerTest.invalidate()
                    
                    if disappearAnimationControl.isRunning {
                        
                        disappearAnimationControl.stopAnimation(false)
                        disappearAnimationControl.isReversed = true
                        disappearAnimationControl.finishAnimation(at: UIViewAnimatingPosition.start)
                        
                        print("[Handle Tap] Tap is inside topView -> Reappear")
                    } else {
                        print("[Handle Tap] Tap is inside topView -> Appear")
                        reappearAnimationControl.startAnimation()
                    }
                    
                    enableInteract()
                    setTimer()
                }
                
            } else if ((checkInView(points: arrayPointButton) == true) || (self.topView.bounds.contains(pointInTopView)) && self.showPlayDoneButton == true) {
                
                let disableInteractQueue = DispatchQueue(label: "disableInteractQueue")
                
                disableInteractQueue.sync {
                    
                    timerTest.invalidate()
                    enableInteract()
                    
                    if disappearAnimationControl.isRunning {
                        
                        disappearAnimationControl.stopAnimation(false)
                        disappearAnimationControl.isReversed = true
                        disappearAnimationControl.finishAnimation(at: UIViewAnimatingPosition.start)
                        
                        print("[Handle Tap] Tap is inside topView -> Reappear")
                    }
                    
                    print("[Handle Tap] Invalidate in ctrl view")
                    
                    setTimer()
                }
            }
        }
    }
    
    func checkInView(points: Array<CGPoint>) -> Bool {
        
        for point in points {
        
            if self.playButton.imageView?.bounds.contains(point) == true {
                return true
            } else if self.doneButton.imageView?.bounds.contains(point) == true {
                return true
            } else if self.backward15.imageView?.bounds.contains(point) == true {
                return true
            } else if self.forward15.imageView?.bounds.contains(point) == true {
                return true
            } else if self.backward.imageView?.bounds.contains(point) == true {
                return true
            } else if self.forward.imageView?.bounds.contains(point) == true {
                return true
            }
        }
        
        return false
    }
    
    func enableInteract() {
        
        self.doneButton.isEnabled = true
        self.playButton.isEnabled = true
        self.backward15.isEnabled = true
        self.backward.isEnabled = true
        self.forward15.isEnabled = true
        self.forward.isEnabled = true
        self.routePickerView.isUserInteractionEnabled = true

    }
    
    @objc func disableInteract() {
        
        self.doneButton.isEnabled = false
        self.playButton.isEnabled = false
        self.backward15.isEnabled = false
        self.backward.isEnabled = false
        self.forward15.isEnabled = false
        self.forward.isEnabled = false
        self.routePickerView.isUserInteractionEnabled = false
        
    }
    
    func disableHighlighted() {
        
        self.doneButton.tintAdjustmentMode = .normal
        self.playButton.tintAdjustmentMode = .normal
        self.backward15.tintAdjustmentMode = .normal
        self.backward.tintAdjustmentMode = .normal
        self.forward15.tintAdjustmentMode = .normal
        self.forward.tintAdjustmentMode = .normal
    }
    
    @objc func initHiddenAuto() {
        
        disableHighlighted()
        disableInteract()
        
        disappearAnimationControl = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            
            self.toggleHidden()
        }
        
        disappearAnimationControl.isInterruptible = true
        
        disappearAnimationControl.startAnimation()
        
        print("[Handle Tap] Disappear Auto")
    }
    
    func toggleHidden() {
        
        self.showPlayDoneButton = false
        
        self.controlView.alpha = 0.0
        self.playButton.alpha = 0.0
        self.doneButton.alpha = 0.0
        self.forward15.alpha = 0.0
        self.backward15.alpha = 0.0
        self.forward.alpha = 0.0
        self.backward.alpha = 0.0
        self.routePickerView.alpha = 0.0
    }
    
    func toggleAppear() {

        enableInteract()
        
        self.showPlayDoneButton = true
        
        self.controlView.alpha = 1.0
        self.playButton.alpha = 1.0
        self.doneButton.alpha = 1.0
        self.forward15.alpha = 1.0
        self.backward15.alpha = 1.0
        self.forward.alpha = 1.0
        self.backward.alpha = 1.0
        self.routePickerView.alpha = 1.0
    }
    
    @objc func playerDidPlayToEnd() {
        
        if self.queuePlayer.currentItem == listVideos[listVideos.count - 1] || self.player?.currentItem == listVideos[listVideos.count - 1] {
            
            exitVideoPlayer()
            return
        }
    }
    
    @objc func audioInterruptionHandle(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        
        if type == .began {
            // Interruption began, take appropriate actions
            self.queuePlayer.pause()
            
        } else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    
                    // Interruption Ended - playback should resume
                    self.queuePlayer.play()
                } else {
                    // Interruption Ended - playback should NOT resume
                }
            }
        }
    }
    func setTimer() {
        
        timerTest =  Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target      : self,
            selector    : #selector(initHiddenAuto),
            userInfo    : nil,
            repeats     : false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.showsPlaybackControls = false

        setTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.queuePlayer.currentItem)
    }

    override func remoteControlReceived(with event: UIEvent?) {

        if let event = event {
            
            if event.type == .remoteControl {

                print("[Remote Received] Event \(event)")
                
                switch event.subtype {

                case .remoteControlPlay:
                    print("[Remote Received] Play")
                    playRemote()

                case .remoteControlPause:
                    print("[Remote Received] Pause")
                    pauseRemote()

                case .remoteControlNextTrack:
                    print("[Remote Received] Forward")
                    forward15Remote()
                    
                case .remoteControlPreviousTrack:
                    print("[Remote Received] Backward")
                    backward15Remote()
                    
                default:
                    print("[Remote Received] haven't setup")
                }
            }
        }
    }

    //MARK: Observe changes in AVPlayer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
            
        case "status":
            
            if player?.status == .readyToPlay {

                print("[Notification] ready to play")
                
                if playerPlaying {
                    
                    print("[Notification] playing")
                    player?.play()
                }
            }
            
//        case "loadedTimeRanges":
//            activityIndicatorView.stopAnimating()
//            print("loadedTimeRanges")

        case "playbackBufferEmpty":
            
            activityIndicatorView.startAnimating()
            print("[Notification] playbackBufferEmpty")

        case "playbackLikelyToKeepUp":
            activityIndicatorView.stopAnimating()
            print("[Notification] playbackLikelyToKeepUp")

        case "playbackBufferFull":
            activityIndicatorView.stopAnimating()
            print("[Notification] playbackBufferFull")
  
        default:
            return
        }
    }
    
    //MARK: Done button
    @objc func doneButtonPressed() {
        
        if doneButton.isEnabled {

            print("[Done] doneButtonPressed")
        
            exitVideoPlayer()
        }
        
        return
    }
    
    //MARK: Play button
    @objc func playButtonPressed() {
        
        timerTest.invalidate()
        
        if playButton.isEnabled {
            
            if playerPlaying == false {
                self.player?.play()
                playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                playerPlaying = true
                print("[Play] playButtonPressed")
            } else {
                self.player?.pause()
                playButton.setImage(UIImage(named: "PLAY"), for: .normal)
                playerPlaying = false
                print("[Pause] pauseButtonPressed")
            }
        }
        setTimer()
        return
    }
    
    //MARK: Forward 15 seconds selected
    @objc func forward15Pressed() {
        
        timerTest.invalidate()
        
        if forward15.isEnabled {
            self.player?.pause()
            playButton.setImage(UIImage(named: "PLAY"), for: .normal)
            playerPlaying = false
        
            let seekDuration = CMTimeMake(15, 1)
            let currentTime: CMTime = (self.player?.currentTime())!
        
            if currentTime + seekDuration > (self.player?.currentItem?.duration)! && !(self.player?.currentItem == listVideos[listVideos.count - 1]) {
                
                self.player?.pause()
                self.queuePlayer.advanceToNextItem()
                self.player?.play()
                self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                
                return
            } else if currentTime + seekDuration > (self.player?.currentItem?.duration)! && (self.player?.currentItem == listVideos[listVideos.count - 1]) {
                
                self.player?.pause()
                self.exitVideoPlayer()
            }
        
            self.player?.seek(to: currentTime + seekDuration)
        
            print("[Forward] forward15ButtonPressed")
        
            self.player?.play()
            playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            playerPlaying = true
        
            setTimer()
        }
        
        return
        
    }
    
    //MARK: Backward 15 seconds selected
    @objc func backward15Pressed() {
        
        timerTest.invalidate()
        
        if backward15.isEnabled {
        
            self.player?.pause()
            playButton.setImage(UIImage(named: "PLAY"), for: .normal)
            playerPlaying = false
        
            let seekDuration = CMTimeMake(15, 1)
            let currentTime: CMTime = (self.player?.currentTime())!
            if currentTime - seekDuration > kCMTimeZero {                   // check if seek duration is less than 15 seconds
                
                let newTime = currentTime - seekDuration
                self.player?.seek(to: newTime)
                
            } else {
                
                self.player?.seek(to: kCMTimeZero)
            }
        
            print("[Backward 15] backward15ButtonPressed")
        
            self.player?.play()
            playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            playerPlaying = true
        
            setTimer()
        }
        
        return
    }
    
    //MARK: Forward selected
    @objc func forwardPressed() {
        
        timerTest.invalidate()
        
        if forward.isEnabled {
        
            self.player?.pause()
        
            for item in listVideos {                    // get and insert previous video into queue
                
                if item == self.player?.currentItem {
                    
                    let currentIndex = listVideos.index(of: item)
                    print("[Forward] CurrentIndex: \(currentIndex!)")
                    
                    if currentIndex! < listVideos.count - 1 {
                        
                        self.queuePlayer.advanceToNextItem()
                        self.player?.seek(to: kCMTimeZero)
                        
                        print("[Forward] forwardButtonPressed")
                        
                        self.player?.play()
                        self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                        
                        return
                        
                    } else if currentIndex == listVideos.count - 1 {
                        
                        exitVideoPlayer()
                        return
                    }
                }
            }
        
            print("[Forward] forwardButtonPressed")
        
            self.player?.play()
            self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
        
            setTimer()
        }
        
        return
    }
    
    //MARK: Backward selected
    @objc func backwardPressed() {
        
        timerTest.invalidate()
        
        if backward.isEnabled {
        
            for item in listVideos {                    // get and insert previous video into queue
                if item == self.player?.currentItem {
                    
                    let currentIndex = listVideos.index(of: item)
                    print(currentIndex!)
                    
                    if currentIndex! > 0 {
                        
                        self.player?.pause()
                        
                        let moveBackIndex = currentIndex! - 1
                    
                        let currentItem = self.player?.currentItem
                        let newItem = listVideos[moveBackIndex]
                        
                        self.queuePlayer.replaceCurrentItem(with: newItem)
                        print("[Backward] replace video successfully")
                        
                        self.player?.pause()
                        
                        self.queuePlayer.insert(currentItem!, after: newItem)
                        print("[Backward] inserted curent video")

                        self.player?.seek(to: kCMTimeZero)
                        
                        print("[Backward] backwardButtonPressed")
                        
                        self.player?.play()
                        self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                        
                    } else if currentIndex == 0 {
                        
                        self.player?.pause()
                        
                        self.player?.seek(to: kCMTimeZero)
                        
                        self.player?.play()
                        self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                    }
                }
            }
            setTimer()
        }
        
        return
    }
    
    @objc func airplayButton() {

        print("[Airplay] airplayButtonPressed")
    
        self.contentOverlayView?.addSubview(routePickerView)
    
        routePickerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        routePickerView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        routePickerView.rightAnchor.constraint(equalTo: (controlView.rightAnchor), constant: -20).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.player = nil
        self.queuePlayer.removeAllItems()
        NotificationCenter.default.removeObserver(self)
    
        checkPortrait()
    }
    
    deinit {
//        self.player = nil
        self.queuePlayer.removeAllItems()
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
