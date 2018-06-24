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

class WorkOutTableViewController: UITableViewController {
    
    //MARK: Properties
    var workOutVideos = [WorkOutVideo]()
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    //MARK: Private Methods
    
    private func loadSampleWOV() {
        
        let photo1 = UIImage(named: "full_body")
        let photo2 = UIImage(named: "full_body")
        let photo3 = UIImage(named: "full_body")
        
        let path = Bundle.main.path(forResource: "Teaser1Final", ofType: "mp4")
        
        guard let wov1 = WorkOutVideo(name: "Full Body", path: path!, image: photo1!) else {
            fatalError("Error")
        }
        
        guard let wov2 = WorkOutVideo(name: "Upper Body", path: path!, image: photo2!) else {
            fatalError("Error")
        }
        
        guard let wov3 = WorkOutVideo(name: "Lower Body", path: path!, image: photo3!) else {
            fatalError("Error")
        }
        
        workOutVideos += [wov1, wov2, wov3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        loadSampleWOV()
        
        let videoString: String? = Bundle.main.path(forResource: "Teaser1Final", ofType: ".mp4")
        
        if let url = videoString {
            
            let videoURL = NSURL(fileURLWithPath: url)
            
            self.player = AVPlayer(url: videoURL as URL)
            self.playerController.player = self.player
        }
        
//        self.tableView.isEditing = true  // allow users to reorder cells

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playVideo(_ sender: Any) {
        
        self.present(self.playerController, animated: true, completion: {
            self.playerController.player?.play()
        })
    }
    
}
