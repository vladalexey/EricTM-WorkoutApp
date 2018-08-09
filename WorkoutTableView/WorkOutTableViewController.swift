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

class WorkOutTableViewController: UITableViewController, DataSentDelegate {
    
    //MARK: Properties
    
    var workOutVideos = [WorkOutVideo]()
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    var queuePlayer = AVQueuePlayer()
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    var videoCount = 0
    var myIndex = 0
    
    var listWorkOut = ["Full", "Upper", "Lower"]
    var workoutLabel = String()
    var workoutCode = String()
    
    let backgroundColor = UIColor(
        red: 0.20,
        green: 0.20,
        blue: 0.20,
        alpha: 1.0
    )
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("check Portrait in Table view")
        
        let checkPortraitWorkoutTable = DispatchQueue(label: "checkPortraitWorkoutTable")
        checkPortraitWorkoutTable.sync {
            
            if (self.navigationController?.navigationBar.isHidden)! {
                self.navigationController?.isNavigationBarHidden = false
            }
            
            print("check Portrait in Table view")
            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("change to Portrait")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.reloadData()
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait //TODO: Navigation Bar disappear error after add this line
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if editing {
            tableView.setEditing(true, animated: true)
            self.editButtonItem.title = "Done"
        } else {
            tableView.setEditing(false, animated: true)
            self.editButtonItem.title = "Edit"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension

        setupBackground()
        loadDefaultWOV()
        
        tableView.allowsSelectionDuringEditing = false
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//
//            self.tableView.setNeedsLayout()
//            self.tableView.layoutIfNeeded()
//
//            self.tableView.reloadData()
//        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // enter Edit mode by long press in cell
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(WorkOutTableViewController.longPressCellHandle))
//        tableView.addGestureRecognizer(longPress)
        
//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func longPressCellHandle(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            let touchPoint = gesture.location(in: tableView)
            if self.isEditing == false {
                self.setEditing(true, animated: true)
            }
        }
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workOutVideos.count
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkOutTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkOutTableViewCell else {
            fatalError("The dequeued cell is not an instance of WorkOutTableViewCell.")
        }
        
        // Fetches the appropriate workout for the data source layout.
        let workOutVideo = workOutVideos[indexPath.row]
        
        cell.nameLabel.text = workOutVideo.name.uppercased()
        cell.photoImageView.image = workOutVideo.image
        cell.Vignette.image = workOutVideo.background
        cell.minuteWorkout.text = workOutVideo.length.uppercased()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = backgroundColor

    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        tableView.reloadRows(at: [indexPath!], with: .automatic)
//        tableView.updateConstraints()
    }
    
    // Override to handle actions in cell touch
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // initialization code
        
        myIndex = indexPath.row
        workoutLabel = workOutVideos[indexPath.row].workoutLabel
        performSegue(withIdentifier: "VideoPlayer", sender: self)
        print(listWorkOut)
        print(workoutLabel)

    }

//    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//        tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
//    }
    
    func alertOnDefaultWorkouts() {
        
        let alertView = UIAlertController(title: "Error", message: "Cannot delete default", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            alertView.dismiss(animated: true, completion: nil)
            
            print("OK")
        }
        
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("Edit content")
            
        }
        edit.backgroundColor = .lightGray
        
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            print("remove button tapped")
            
            if (self.workOutVideos[indexPath.row].name != "FULL BODY") && (self.workOutVideos[indexPath.row].name != "UPPER BODY") && (self.workOutVideos[indexPath.row].name != "LOWER BODY") {
                
                print(self.workOutVideos[indexPath.row].name + " deleted")
                
//                tableView.beginUpdates()
                
                self.workOutVideos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
//                tableView.endUpdates()
                
            } else {
                
                self.alertOnDefaultWorkouts()
            }

        }
        remove.backgroundColor = .red
        
        return [remove, edit]
    }
    
    func exitEditModeIfTrue() {
        
        if self.isEditing {
            self.setEditing(false, animated: true)
            //TODO: Done button still shows after go back from Add Workout
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addWorkout" {
            
            exitEditModeIfTrue()
            
            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("change to Portrait")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
            
            let destVC = segue.destination as? UINavigationController

            let AddWorkoutViewController = destVC?.topViewController as! AddWorkoutViewController
            AddWorkoutViewController.delegate = self
            
        }
        else if segue.identifier == "VideoPlayer" {
            
            exitEditModeIfTrue()
        
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
            
            let destVC = segue.destination as? PlayerViewController
            
            if workoutLabel == "Upper" {
                workoutCode = "Upper"
                destVC?.workoutCode = self.workoutCode
                print(destVC?.workoutCode)
                
            } else if workoutLabel == "Lower" {
                workoutCode = "Lower"
                destVC?.workoutCode = self.workoutCode
                print(destVC?.workoutCode)
                
            } else if workoutLabel == "Full" {
                workoutCode = "Full"
                destVC?.workoutCode = self.workoutCode
                print(destVC?.workoutCode)
            }

        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            self.workOutVideos.remove(at: indexPath.row)
            
//            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
            
//            tableView.updateConstraints()
        }
        if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        print(listWorkOut)
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let videoWorkout = workOutVideos[fromIndexPath.row]
        let listLabel = listWorkOut[fromIndexPath.row]
        
        
        workOutVideos.remove(at: fromIndexPath.row)
        listWorkOut.remove(at: fromIndexPath.row)
        
        workOutVideos.insert(videoWorkout, at: to.row)
        listWorkOut.insert(listLabel, at: to.row)
        
//        tableView.updateConstraints()
        
        print(listWorkOut)
        
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    //MARK: Private Methods
    
    func userDidEnterData(nameWorkout: String, lengthWorkout: String, workoutLabel: String) {    //delegate function for add custom workout
        
        if nameWorkout != "" && lengthWorkout != "" && workoutLabel != "" {
            
            let newWorkout = WorkOutVideo(name: nameWorkout, length: lengthWorkout, workoutLabel: workoutLabel)
            let newIndex = IndexPath(row: workOutVideos.count, section: 0)
            workOutVideos.append(newWorkout!)
            listWorkOut.append(nameWorkout)
            
//            tableView.beginUpdates()
            tableView.insertRows(at: [newIndex], with: .bottom)
//            tableView.endUpdates()
            
//            tableView.updateConstraints()

            print(listWorkOut)
        } 
    }

    
    //MARK: Load workout sessions
    private func loadDefaultWOV() {
      
        guard let wov1 = WorkOutVideo(name: "FULL BODY", length: "45 minutes", workoutLabel: "Full") else {
            fatalError("Error")
        }
        
        guard let wov2 = WorkOutVideo(name: "UPPER BODY", length: "45 minutes", workoutLabel: "Upper") else {
            fatalError("Error")
        }
        
        guard let wov3 = WorkOutVideo(name: "LOWER BODY", length: "45 minutes", workoutLabel: "Lower") else {
            fatalError("Error")
        }
        
        workOutVideos += [wov1, wov2, wov3]
    }

    //MARK: Setup background interface
    func setupBackground() {
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        
        self.view.backgroundColor = backgroundColor
        navigationController?.navigationBar.barTintColor = backgroundColor // color top bar black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]  // color top bar text white
        
        //MARK: Setting logo on NavBar
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 25, y: 5, width: 100, height: 20))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo")
        imageView.image = image
        logoContainer.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor).isActive = true

        navigationItem.titleView = logoContainer
        navigationItem.titleView?.sendSubview(toBack: logoContainer)
        
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.tabBarController?.tabBar.layer.shadowRadius = 4.0
        self.tabBarController?.tabBar.layer.shadowOpacity = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
}



