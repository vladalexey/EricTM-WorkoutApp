//
//  WorkOutTableViewController.swift
//  EricTM
//
//  Created by Phan Quân on 6/22/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

import FirebaseStorage

class WorkOutTableViewController: UITableViewController {
    
    //MARK: Properties
    var workOutVideos = [WorkOutVideo]()
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    
    //MARK: Private Methods
    
    private func loadSampleWOV() {
        
        let photo1 = UIImage(named: "full_body")
        let photo2 = UIImage(named: "full_body")
        let photo3 = UIImage(named: "full_body")
        
        let path = Bundle.main.path(forResource: "Teaser1Final", ofType: "mp4")
        
        guard let wov1 = WorkOutVideo(name: "FULL BODY", path: path!, image: photo1!) else {
            fatalError("Error")
        }
        
        guard let wov2 = WorkOutVideo(name: "UPPER BODY", path: path!, image: photo2!) else {
            fatalError("Error")
        }
        
        guard let wov3 = WorkOutVideo(name: "LOWER BODY", path: path!, image: photo3!) else {
            fatalError("Error")
        }
        
        workOutVideos += [wov1, wov2, wov3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let videoString1: String? = Bundle.main.path(forResource: "Teaser1Final", ofType: ".mp4")
//        let videoString2: String? = Bundle.main.path(forResource: "Teaser1Final", ofType: ".mp4")
//        let videoString3: String? = Bundle.main.path(forResource: "Teaser1Final", ofType: ".mp4")


//        func playplay(url: NSURL) {
//            let item = AVPlayerItem(url: url! as URL)
//
//            NotificationCenter.defaultCenter().addObserver(self, selector:  "playerDidFinishPlaying:", name:   AVPlayerItemDidPlayToEndTimeNotification, object: item)
//
//            let player = AVPlayer(playerItem: item)
//            player.play()
//        }
//
//        func playerDidFinishPlaying(note: NSNotification) {
//            // Your code here
//        }
//
//        // Process error here
        
        
        
        
        
        
        //MARK: Setup background interface
        let backgroundColor = UIColor(
            red: 0.25,
            green: 0.25,
            blue: 0.25,
            alpha: 1.0
        )
        
        
        self.view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor // color top bar black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]  // color top bar text white
        tabBarController?.tabBar.tintColor = UIColor.white // color tab bar white
        
        
        //MARK: Setting logo on NavBar
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 2, width: 5, height: 5))
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        let image = UIImage(named: "logo")
//        imageView.image = image
//        navigationItem.titleView = imageView
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 40, y: 5, width: 200, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer

        
        //MARK: Load workout sessions
        loadSampleWOV()
        
        
        //MARK: Play videos
//        let videoURL: NSURL? = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/erictmworkout.appspot.com/o/Evie's%20Transformation.mov?alt=media&token=67afdb85-8b44-4359-86f7-b2c9f0dcf016")
//
//        self.player = AVPlayer(url: videoURL! as URL)
//        self.playerController.player = self.player
        
//        NotificationCenter.defaultCenter().addObserver(self, selector: "videoMPMoviePlayerWillEnterFullscreen:", name: MPMoviePlayerWillEnterFullscreenNotification, object: nil);
//        //change orientation to portrait when user exits the full screen
//        
//        
//        NotificationCenter.defaultCenter.addObserver(self, selector: "videoMPMoviePlayerWillExitFullscreenNotification:", name: videoMPMoviePlayerWillExitFullscreenNotification, object: nil);
//        
//        }
//    
//        func  videoMPMoviePlayerWillEnterFullscreen(notification:NSNotification)
//        {
//            let value = UIInterfaceOrientation.landscapeLeft.rawValue ;// UIInterfaceOrientation.LandscapeRight.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
//    
//    
//    
//        func  videoMPMoviePlayerWillExitFullscreenNotification(notification:NSNotification)
//        {
//            let value = UIInterfaceOrientation.portrait.rawValue ;// UIInterfaceOrientation.LandscapeRight.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
//         editButtonItem?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workOutVideos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkOutTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkOutTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkOutTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let workOutVideo = workOutVideos[indexPath.row]
        
        cell.nameLabel.text = workOutVideo.name
        cell.photoImageView.image = workOutVideo.image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playVideo(_ sender: Any) {
<<<<<<< HEAD
        
        var currentTrack = 0
        
        let url = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/erictmworkout.appspot.com/o/Evie's%20Transformation.mov?alt=media&token=67afdb85-8b44-4359-86f7-b2c9f0dcf016")
        
        let item1 = AVPlayerItem(url: url! as URL)
        let item2 = AVPlayerItem(url: url! as URL)
        let item3 = AVPlayerItem(url: url! as URL)
        
        
        let itemsToPlay = [item1, item2, item3]
        
        _ = AVQueuePlayer(items: itemsToPlay)
        
        
        if itemsToPlay.count > 0 {
            player?.replaceCurrentItem(with: itemsToPlay[currentTrack])
            player?.play()
        }
        
//        self.present(self.playerController, animated: true, completion: {
//            self.playerController.player?.play()
//        })
=======
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        self.present(self.playerController, animated: true, completion: {
            self.playerController.player?.play()
        })
        
>>>>>>> bc7d6dcc1d7659882bd478bce034c96521a8ef83
    }
    
}

