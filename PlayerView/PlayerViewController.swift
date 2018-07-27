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

class Global {
    
    var videoName1: String = ""
    var videoName2: String = ""
    var videoName3: String = ""
}

let global = Global()

class PlayerViewController: AVPlayerViewController {
    
    var playerViewController: AVPlayerViewController = AVPlayerViewController()
    
    var timerTest = Timer()
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    
    var downloadTask1: StorageReference {
        return Storage.storage().reference().child(global.videoName1)
    }
    
    var downloadTask2: StorageReference {
        return Storage.storage().reference().child(global.videoName2)
    }
    
    var downloadTask3: StorageReference {
        return Storage.storage().reference().child(global.videoName3)
    }
    
    var playerPlaying: Bool = true
    var showPlayDoneButton: Bool = true
    
    var queuePlayer = AVQueuePlayer()
    var listVideos = [AVPlayerItem]()
    
    var workoutCode = String()
    var videoCount = Int()
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    let routePickerView: AVRoutePickerView = {
        
        let routepickerview = AVRoutePickerView()
        
        routepickerview.translatesAutoresizingMaskIntoConstraints = false
        routepickerview.tintColor = UIColor.white
        routepickerview.backgroundColor = UIColor.clear
        
        return routepickerview
    }()
    
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
    
    //MARK: Done button init
    lazy var doneButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "X"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        return button
        }()
    
    //MARK: Play button init
    lazy var playButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "PAUSE"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    //MARK: Forward15 button init
    lazy var forward15: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "15FORWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forward15(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()

    //MARK: Backward15 button init
    lazy var backward15: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "15BACKWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backward15(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    //MARK: Forward button init
    lazy var forward: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "FORWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(forward(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    //MARK: Backward button init
    lazy var backward: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "BACKWARD"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backward(sender:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    //MARK: Airplay button init
    lazy var airplay: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        button.setImage(UIImage(named: "AIRPLAY"), for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(airplayButton(sender:)), for: UIControlEvents.touchUpInside)  //TODO: Airplay function
        
        return button
    }()
    
    func setupUI() {
        
        self.view.isMultipleTouchEnabled = false
        
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
        backward15.rightAnchor.constraint(equalTo: (playButton.centerXAnchor), constant: -60).isActive = true
        
        
        self.contentOverlayView?.insertSubview(forward15, aboveSubview: controlView)
        forward15.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward15.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        forward15.leftAnchor.constraint(equalTo: (playButton.centerXAnchor), constant: 60).isActive = true
        
        self.contentOverlayView?.insertSubview(forward, aboveSubview: controlView)
        forward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forward.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        forward.leftAnchor.constraint(equalTo: (playButton.rightAnchor), constant: 120).isActive = true
        
        self.contentOverlayView?.insertSubview(backward, aboveSubview: controlView)
        backward.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backward.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        backward.rightAnchor.constraint(equalTo: (playButton.leftAnchor), constant: -120).isActive = true
        
//        self.contentOverlayView?.insertSubview(airplay, aboveSubview: controlView)
//        airplay.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        airplay.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
//        airplay.rightAnchor.constraint(equalTo: (controlView.rightAnchor), constant: -20).isActive = true
        
        self.contentOverlayView?.addSubview(routePickerView)
        routePickerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        routePickerView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        routePickerView.rightAnchor.constraint(equalTo: controlView.rightAnchor, constant: -20).isActive = true
        
    }
    
    func exitDueToForward() {
        
        self.queuePlayer.removeAllItems()
        
        NotificationCenter.default.removeObserver(self)
        
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Exit video due to Error
    func exitVideoPlayer() {
        
        print("exit video player")
        
        self.player?.pause()
        
        let alertView = UIAlertController(title: "Error", message: "Cannot load videos", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Try again", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            self.queuePlayer.removeAllItems()
            
            NotificationCenter.default.removeObserver(self)
            
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            print("OK")
        }
        
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func checkFileAvailableLocal(nameFileToCheck: String) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(nameFileToCheck) {
            
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                
                print("FILE AVAILABLE")
                return true
                
            } else {
                print("FILE NOT AVAILABLE")
                return false
                
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    @objc func didEnterBackground() {
        
        self.player = nil
        self.player?.pause()
        
        playButton.setImage(UIImage(named: "PLAY"), for: .normal)
        playerPlaying = false
        
        return
    }
    
    @objc func willEnterForeground() {
        
        self.player = queuePlayer
        self.player?.play()
        
        playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
        playerPlaying = true
        
        return
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
      
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
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

        let random1 = Int(arc4random_uniform(12) + 1)  // get random number
        global.videoName1 = "WO_Ep" + String(random1) + ".mp4"  // get random workout label
        
//        let downloadTask1 = videoReference.child(global.videoName1)

        if checkFileAvailableLocal(nameFileToCheck: global.videoName1) == false {

            videoReference.child(global.videoName1).downloadURL(completion: { (url, error) in
                if error != nil {
                    
                    print("Error " + global.videoName1)
                    self.exitVideoPlayer()
                    return
                    
                } else {

                    self.videoCount += 1
                    print(global.videoName1)

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
            
            let localURL = documentsURL.appendingPathComponent(global.videoName1)

            // Download to the local filesystem
            downloadTask1.write(toFile: localURL) { url, error in
                if let error = error {
                    
                    self.exitVideoPlayer()
                    print("Uh-oh, an error occurred!")
                    return
                    
                } else {
                    
                    print("sucessfully downloaded video 1")
                }
            }
            
//            downloadTask.observe(.progress) { snapshot in
//                // Download reported progress
//                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount)
//
//                print("video 1 " + String(percentComplete))
//            }
            
        //MARK: check available true video 1
        } else {
            
            print(global.videoName1)

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let localURL = documentsURL.appendingPathComponent(global.videoName1)

            let item1 = AVPlayerItem(url: localURL)
            
            item1.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            item1.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item1.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            item1.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
            item1.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            
            self.queuePlayer.insert(item1, after: nil)
            self.listVideos.append(item1)
        }
        

        var random2: Int

        repeat {
            random2 = Int(arc4random_uniform(12) + 1)
        } while random1 == random2

        global.videoName2 = "WO_Ep" + String(random2) + ".mp4"
        
        let downloadTask2 = videoReference.child(global.videoName2)

        if self.checkFileAvailableLocal(nameFileToCheck: global.videoName2) == false {

            self.videoReference.child(global.videoName2).downloadURL(completion: { (url, error) in
                if error != nil {
                    
                    print("Error 2" + global.videoName2)
                    self.exitVideoPlayer()
                    return

                } else {

                    self.videoCount += 1
                    print(global.videoName2)

                    let url2: URL = url!
                    let item2 = AVPlayerItem(url: url2)

                    item2.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
                    item2.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                    item2.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                    item2.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
                    item2.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                    
                    self.queuePlayer.insert(item2, after: nil)
                    self.listVideos.append(item2)
                }
            })
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let localURL = documentsURL.appendingPathComponent(global.videoName2)
            
            // Download to the local filesystem
            downloadTask2.write(toFile: localURL) { url, error in
                if let error = error {
                    
                    self.exitVideoPlayer()
                    print("Uh-oh, an error occurred!")
                    return
                    
                } else {
                    
                    print("sucessfully downloaded video 2")
                }
            }
            
//            downloadTask2.observe(.progress) { snapshot in
//                // Download reported progress
//                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount)
//
//                print("video 2 " + String(percentComplete))
//            }
            
        //MARK: check available true video 2
        } else {
            
            print(global.videoName2)

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let localURL = documentsURL.appendingPathComponent(global.videoName2)

            let item2 = AVPlayerItem(url: localURL)

            self.queuePlayer.insert(item2, after: nil)
            self.listVideos.append(item2)
        }
    

        var random3: Int

        repeat {
            random3 = Int(arc4random_uniform(12) + 1)
        } while (random3 == random2) || (random3 == random1)

        global.videoName3 = "WO_Ep" + String(random3) + ".mp4"
        
        let downloadTask3 = videoReference.child(global.videoName3)

        if self.checkFileAvailableLocal(nameFileToCheck: global.videoName3) == false {

            self.videoReference.child(global.videoName3).downloadURL(completion: { (url, error) in
                if error != nil {
                    
                    print("Error 3" + global.videoName3)
                    self.exitVideoPlayer()
                    return

                } else {

                    self.videoCount += 1
                    print(global.videoName3)

                    let url3: URL = url!
                    let item3 = AVPlayerItem(url: url3)

                    item3.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
                    item3.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                    item3.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                    item3.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
                    item3.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)

                    self.queuePlayer.insert(item3, after: nil)
                    self.listVideos.append(item3)
                    
                    print(self.queuePlayer.items().count)

                    self.player = self.queuePlayer

                }
            })
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let localURL = documentsURL.appendingPathComponent(global.videoName3)
            
            // Download to the local filesystem
            downloadTask3.write(toFile: localURL) { url, error in
                if let error = error {
                    
                    self.exitVideoPlayer()
                    print("Uh-oh, an error occurred!")
                    return
                    
                } else {
                    
                    print("sucessfully downloaded video 3")
                }
            }
            
//            downloadTask3.observe(.progress) { snapshot in
//                // Download reported progress
//                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount)
//
//                print("video 3 " + String(percentComplete))
//            }
            
            //MARK: check available true video 3
        } else {
            
            print(global.videoName3)

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let localURL = documentsURL.appendingPathComponent(global.videoName3)

            let item3 = AVPlayerItem(url: localURL)

            item3.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            item3.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item3.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            item3.addObserver(self, forKeyPath: "playbackBufferFull", options: NSKeyValueObservingOptions.new, context: nil)
            item3.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            
            self.queuePlayer.insert(item3, after: nil)
            self.listVideos.append(item3)
            
            print(queuePlayer.items())
            print(listVideos)
        }
    }
    
    @objc func handleTap(tap: UIGestureRecognizer) {
        
        if tap.state == UIGestureRecognizerState.ended {
          
            let disappearAnimationControll = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {

                self.toggleHidden()
            }
            
            let reappearAnimationControl = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                
                self.toggleAppear()
            }

            let point = tap.location(in: self.view)

            let pointInTopView = self.topView.convert(point, from: self.view)
            let pointInCtrlView = self.controlView.convert(point, from: self.view)

            if (self.topView.bounds.contains(pointInTopView)) && !(self.controlView.bounds.contains(pointInCtrlView)) && self.showPlayDoneButton {

                print("[handleTap] Tap is inside topView -> Disappear")
                
                disappearAnimationControll.startAnimation()

                timerTest.invalidate()

            } else if (self.topView.bounds.contains(pointInTopView)) && self.showPlayDoneButton != true {
                
                timerTest.invalidate()
 
                print("[handleTap] Tap is inside topView -> Reappear")
            
                reappearAnimationControl.startAnimation()
                
                setTimer()
            } else if (self.controlView.bounds.contains(pointInCtrlView)) && self.showPlayDoneButton == true {
                
                timerTest.invalidate()
                
                setTimer()
            }
        }
    }
    
    @objc func initHiddenAuto() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.playButton.isUserInteractionEnabled = false
        self.doneButton.isUserInteractionEnabled = false
        self.forward.isUserInteractionEnabled = false
        self.forward15.isUserInteractionEnabled = false
        self.backward.isUserInteractionEnabled = false
        self.backward15.isUserInteractionEnabled = false
        self.routePickerView.isUserInteractionEnabled = false
        
        let disappearAnimationControll = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            
            self.toggleHidden()
        }
        
        disappearAnimationControll.startAnimation()

        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func toggleHidden() {
        
        // Added extra timerTest.isValid check on July 27
        
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
            self.routePickerView.alpha = 0.0

        }
        
        return
        
    }
    
    func toggleAppear() {
        
        if showPlayDoneButton == false {
            
            self.playButton.isUserInteractionEnabled = true
            self.doneButton.isUserInteractionEnabled = true
            self.forward.isUserInteractionEnabled = true
            self.forward15.isUserInteractionEnabled = true
            self.backward.isUserInteractionEnabled = true
            self.backward15.isUserInteractionEnabled = true
            self.routePickerView.isUserInteractionEnabled = true
            
            self.showPlayDoneButton = true
            
            self.controlView.alpha = 0.5
            self.playButton.alpha = 1.0
            self.doneButton.alpha = 1.0
            self.forward15.alpha = 1.0
            self.backward15.alpha = 1.0
            self.forward.alpha = 1.0
            self.backward.alpha = 1.0
            self.airplay.alpha = 1.0
            self.routePickerView.alpha = 1.0
        }

        return
    }
    
    @objc func playerDidPlayToEnd() {
        
        if player?.currentItem == listVideos[2] {
            
            exitDueToForward()
            
            return
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Implement background video's audio when user exit app
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.player = self.queuePlayer
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        UIApplication.shared.endIgnoringInteractionEvents()

        self.player?.play()
        self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
        self.showsPlaybackControls = false
        
        setTimer()

    }
    
    //MARK: Observe changes in AVPlayer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch keyPath {
            
        case "status":
            
            if player?.status == .readyToPlay {
                
//                activityIndicatorView.stopAnimating()
                print("ready to play")
                
                if playerPlaying {
                    
                    player?.play()
                    self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
//                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
            
//        case "loadedTimeRanges":
//            activityIndicatorView.stopAnimating()
//            print("loadedTimeRanges")

        case "playbackBufferEmpty":
            activityIndicatorView.startAnimating()
            
            self.player?.pause()
            self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            print("playbackBufferEmpty")

        case "playbackLikelyToKeepUp":
            activityIndicatorView.stopAnimating()
            print("playbackLikelyToKeepUp")

        case "playbackBufferFull":
            activityIndicatorView.stopAnimating()
            print("playbackBufferFull")
  
        default:
            return
        }
    }
    
    //MARK: Done button
    @objc func doneButtonPressed(sender: UIButton) {
        
        print("doneButtonPressed")
        
        queuePlayer.removeAllItems()
        
        NotificationCenter.default.removeObserver(self)
        
        self.toggleHidden()
        
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        return
    }
    
    //MARK: Play button
    @objc func playButtonPressed(sender: UIButton) {
        
        timerTest.invalidate()
        
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
        
        setTimer()
        
        return
    }
    
    //MARK: Forward 15 seconds selected
    @objc func forward15(sender: UIButton) {
        
        timerTest.invalidate()
        
        self.player?.pause()
        playButton.setImage(UIImage(named: "PLAY"), for: .normal)
        playerPlaying = false
        
        let seekDuration = CMTimeMake(15, 1)
        let currentTime: CMTime = (self.player?.currentTime())!
        
        if currentTime + seekDuration > (self.player?.currentItem?.duration)! && !(self.player?.currentItem === listVideos[2]) {
            
            
            self.player?.pause()
            self.queuePlayer.advanceToNextItem()
            self.player?.play()
            self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
            
            return
            
        }
        
        self.player?.seek(to: currentTime + seekDuration)
        
        print("forward15ButtonPressed")
        
        self.player?.play()
        playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
        playerPlaying = true
        
        setTimer()
        
        return
        
    }
    
    //MARK: Backward 15 seconds selected
    @objc func backward15(sender: UIButton) {
        
        timerTest.invalidate()
        
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
        
        print("backward15ButtonPressed")
        
        self.player?.play()
        playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
        playerPlaying = true
        
        setTimer()
        
        return
    }
    
    //MARK: Forward selected
    @objc func forward(sender: UIButton) {
        
        timerTest.invalidate()
        
        self.player?.pause()
        
        for item in listVideos {                    // get and insert previous video into queue
            
            if item == self.player?.currentItem {
                
                let currentIndex = listVideos.index(of: item)
                print(currentIndex!)
                
                if currentIndex! < 2 {
                    
                    self.queuePlayer.advanceToNextItem()
                    self.player?.seek(to: kCMTimeZero)
                    
                    print("forwardButtonPressed")
                    
                    self.player?.play()
                    self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
                    
                    return
                    
                } else if currentIndex == 2 {
                    
                    exitDueToForward()
                    return
                }
            }
        }
        
        print("forwardButtonPressed")
        
        self.player?.play()
        self.playButton.setImage(UIImage(named: "PAUSE"), for: .normal)
        
        setTimer()
        
        return
    }
    
    //MARK: Backward selected
    @objc func backward(sender: UIButton) {
        
        timerTest.invalidate()
        
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
                    print("replace video successfully")
                    
                    self.player?.pause()
                    
                    self.queuePlayer.insert(currentItem!, after: newItem)
                    print("inserted curent video")

                    self.player?.seek(to: kCMTimeZero)
                    
                    print("backwardButtonPressed")
                    
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
        
        return
    }
    
    @objc func airplayButton(sender: UIButton) {
        
        print("airplayButtonPressed")
        
        self.contentOverlayView?.addSubview(routePickerView)
        
        routePickerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        routePickerView.bottomAnchor.constraint(equalTo: (contentOverlayView?.topAnchor)!, constant: UIScreen.main.bounds.height - 25).isActive = true
        routePickerView.rightAnchor.constraint(equalTo: (controlView.rightAnchor), constant: -20).isActive = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        queuePlayer.removeAllItems()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        NotificationCenter.default.removeObserver(self)
        
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
