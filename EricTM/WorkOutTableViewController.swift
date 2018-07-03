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
import Darwin

import FirebaseStorage

class WorkOutTableViewController: UITableViewController {
    
    //MARK: Properties
    var workOutVideos = [WorkOutVideo]()
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    var videoCount = 0
    var myIndex = 0
    
    var listWorkOut = ["Full", "Upper", "Lower"]
    var workoutLabel = String()
    var workoutCode = String()
    
    let backgroundColor = UIColor(
        red: 0.25,
        green: 0.25,
        blue: 0.25,
        alpha: 1.0
    )
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        loadSampleWOV()
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    self.editButtonItem.setTitleTextAttributes( [NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
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
        cell.backgroundColor = backgroundColor
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to handle actions in cell touch
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // initialization code
        
        myIndex = indexPath.row
        workoutLabel = listWorkOut[myIndex]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "VideoPlayer" {
        
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
            
            if workoutLabel == "Upper" {
                workoutCode = "U"
            } else if workoutLabel == "Lower" {
                workoutCode = "L"
            } else if workoutLabel == "Full" {
                workoutCode = "F"
            }

            
            let random1 = Int(arc4random_uniform(12) + 1)  // get random number

            let videoName1: String = "WO_Ep" + String(random1) + ".mp4"  // get random workout label
            

            videoReference.child(videoName1).downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Error" + videoName1)
                } else {
                    
                    self.videoCount += 1
                    print(self.videoCount)
                    
                    let url1: URL = url!
                    let item1 = AVPlayerItem(url: url1)
                    
                    let random2 = Int(arc4random_uniform(12) + 1)
                    let videoName2: String = "WO_Ep" + String(random2) + ".mp4"
                    
                    self.videoReference.child(videoName2).downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("Error 2" + videoName2)
                        } else {
                            self.videoCount += 1
                            print(self.videoCount)
                            
                            let url2: URL = url!
                            let item2 = AVPlayerItem(url: url2)
                            
                            let random3 = Int(arc4random_uniform(12) + 1)
                            let videoName3: String = "WO_Ep" + String(random3) + ".mp4"
                            
                            self.videoReference.child(videoName3).downloadURL(completion: { (url, error) in
                                if error != nil {
                                    print("Error 3" + videoName3)
                                } else {
                                    self.videoCount += 1
                                    print(self.videoCount)
                                    
                                    let url3: URL = url!
                                    let item3 = AVPlayerItem(url: url3)
                                    
                                    
                                    
                                        let destination = segue.destination as! AVPlayerViewController
                                    
                                    
                                        destination.player = AVQueuePlayer(items: [item1, item2, item3])
        //                                destination.navigationController?.isNavigationBarHidden = true
                                        destination.navigationController?.navigationBar.backgroundColor = UIColor.black
                                        destination.player?.play()
                                    
                                    
                                        destination.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
                                    
                                    
                                        func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                                            
                                            if keyPath == "rate" {
                                                if let rate = change?[NSKeyValueChangeKey.newKey] as? Float {
                                                    if rate == 0.0 {
                                                        
                                                        if destination.player?.timeControlStatus == .paused {
                                                            
                                                            print("playback stopped")
                                                            
        //                                                    destination.navigationController?.navigationBar.backgroundColor = UIColor.black
                                                            destination.navigationController?.isNavigationBarHidden = false
                                                        }
                                                    }
                                                }
                                            }
                                        
                                    }
                                }
                            })
                        }
                    })
                
                }
            })
        }
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
        if editingStyle == .insert {
            
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let videoWorkout = workOutVideos[fromIndexPath.row]
        let listLabel = listWorkOut[fromIndexPath.row]
        
        workOutVideos.remove(at: fromIndexPath.row)
        listWorkOut.remove(at: fromIndexPath.row)
        
        workOutVideos.insert(videoWorkout, at: to.row)
        listWorkOut.insert(listLabel, at: to.row)
        
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
    
    
    //MARK: Private Methods
    
    
    //MARK: Load workout sessions
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

    
    //MARK: Setup background interface
    func setupBackground() {
        
        self.view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor // color top bar black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]  // color top bar text white
//        tabBarController?.tabBar.tintColor = UIColor.white // color tab bar white
        
        //MARK: Setting logo on NavBar
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 40, y: 5, width: 200, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
    
}



