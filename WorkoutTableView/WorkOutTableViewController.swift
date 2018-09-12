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
    
//    var workOutVideos = [WorkOutVideo]()
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    var queuePlayer = AVQueuePlayer()
    
    var videoReference: StorageReference {
        return Storage.storage().reference()
    }
    var videoCount = 0
    var myIndex = 0

    var listWorkOut = ["FullBodyUpper", "FullBodyGlutes", "UpperBody", "LowerBody", "Abs", "AbsIntermediate"]
    var workoutLabel = String()
    var workoutCode = String()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let checkPortraitWorkoutTable = DispatchQueue(label: "checkPortraitWorkoutTable")
        checkPortraitWorkoutTable.sync {
            
            if (self.navigationController?.navigationBar.isHidden)! {
                self.navigationController?.isNavigationBarHidden = false
            }
            
            print("[Screen Orientation] check Portrait in Table view")
            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("[Screen Orientation] change to Portrait")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
        }
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.tintColor = UIColor.lightGray 
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
        return global.workOutVideos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkOutTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkOutTableViewCell else {
            fatalError("[Loading Cell] The dequeued cell is not an instance of WorkOutTableViewCell.")
        }
        
        // Fetches the appropriate workout for the data source layout.
        let workOutVideo = global.workOutVideos[indexPath.row]
        
        cell.nameLabel.text = workOutVideo.name.uppercased()
        cell.photoImageView.image = workOutVideo.image
        cell.Vignette.image = workOutVideo.background
        cell.minuteWorkout.text = workOutVideo.length.uppercased()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to handle actions in cell touch
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // initialization code
        
        myIndex = indexPath.row
        workoutLabel = global.workOutVideos[indexPath.row].workoutLabel
        performSegue(withIdentifier: "VideoPlayer", sender: self)
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
    
    func listFilesFromDocumentsFolder() -> [String]?
    {
        let fileMngr = FileManager.default;
        
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        // List all contents of directory and return as [String] OR nil if failed
        return try? fileMngr.contentsOfDirectory(atPath:docs)
    }

    func alertOnDefaultWorkouts() {
        
        let alertView = UIAlertController(title: "Error", message: "Cannot delete default", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            alertView.dismiss(animated: true, completion: nil)
            
            print("[Table Editing] OK")
        }
        
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func deleteContentFromLocal(fileNameToDelete: String) {
        
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("[Remove Content] Local path = \(filePath)")
            
        } else {
            print("[Remove Content] Could not find local directory to store file")
            return
        }
        
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("[Remove Content] File does not exist")
            }
            
        }
        catch let error as NSError {
            print("[Remove Content] An error took place: \(error)")
        }
    }
    
//    func checkAvailableOtherWorkout(itemToCheck: VideoExercise, indexWorkOutVideo: Int) -> Bool {
//        
//        var numberCheck = 0
//        
//        for videoExercise in global.workOutVideos[indexWorkOutVideo] {
//            for (belongToWorkout, check) in videoExercise.containIn {
//                if check { numberCheck += 1}        // count number of workouts the exercise belongs to
//                if numberCheck > 1 {             // if more than one, not safe to delete
//                    
//                    videoExercise.containIn[belongToWorkout] = false       // should not belong to this exercise but still available offline for video playing until deleted
//                    return true
//                }
//            }
//        }
//        
//        return false
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("[Table Editing] Edit content")
            
        }
        edit.backgroundColor = .lightGray
        
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            print("[Table Editing] Remove button")
            
            if global.workOutVideos[indexPath.row].isDefault == false {
                
                print("[Table Editing]" + global.workOutVideos[indexPath.row].name + " deleted")
                
                global.workOutVideos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else {
                
                self.alertOnDefaultWorkouts()
            }

        }
        remove.backgroundColor = .red
        
//        let removeDownload = UITableViewRowAction(style: .normal, title: "Remove Local") { action, index in
//
//            print("[Table Editing] Remove Download button")
//
//            //Check if file name available in other workouts
//
//            for (item, hasDownloaded) in global.workOutVideos[indexPath.row].contain {
//
////                if self.checkAvailableOtherWorkout(itemToCheck: item, indexWorkOutVideo: indexPath.row) == false && hasDownloaded { // if not available and already downloaded in other workouts -> Safe to delete
//
//                    guard let nameFileToDelete = item.name else {return}
//                    self.deleteContentFromLocal(fileNameToDelete: nameFileToDelete)
////                }
//            }
//        }
        
        return [remove, edit]
    }
    
    func exitEditModeIfTrue() {
        
        if self.isEditing {
            self.setEditing(false, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addWorkout" {
            
            exitEditModeIfTrue()
            
            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("[Screen Rotation] Change to Portrait")
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
            
            print("[Video Playing] \(global.workOutVideos[myIndex].containSubworkout)")
            
            workoutCode = workoutLabel
            workoutCode = "Abs_Loop_Demo_" //TODO: Change back to Abs when finish testing
            print(workoutCode)
            
            destVC?.workoutCode = self.workoutCode
            destVC?.myIndex = self.myIndex

        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            
            if global.workOutVideos[indexPath.row].isDefault == false {
                
                print("[Table Editing]" + global.workOutVideos[indexPath.row].name + " deleted")
                
                global.workOutVideos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else {
                
                self.alertOnDefaultWorkouts()
            }
        }
        if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        print(listWorkOut)
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let videoWorkout = global.workOutVideos[fromIndexPath.row]
        let listLabel = listWorkOut[fromIndexPath.row]
        
        global.workOutVideos.remove(at: fromIndexPath.row)
        listWorkOut.remove(at: fromIndexPath.row)
        
        global.workOutVideos.insert(videoWorkout, at: to.row)
        listWorkOut.insert(listLabel, at: to.row)
        
        print(listWorkOut)
        
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    //MARK: Private Methods
    
    func userDidEnterData(nameWorkout: String, lengthWorkout: String, workoutLabel: String, isDefault: Bool, containSubworkout: Array<SubWorkoutList>) {    //delegate function for add custom workout
        
        if nameWorkout.isEmpty == false && lengthWorkout != "" && workoutLabel.isEmpty == false {
            
            let newIndex = IndexPath(row: global.workOutVideos.count, section: 0)
            
            guard let newWorkout = WorkOutVideo(name: nameWorkout, length: lengthWorkout, workoutLabel: workoutLabel, isDefault: isDefault, containSubworkout: containSubworkout)
                else {
                    print("[Add Workout] Error in adding workout in AddWorkoutController")
                    return
            }
            global.workOutVideos.append(newWorkout)
            listWorkOut.append(nameWorkout)
            tableView.insertRows(at: [newIndex], with: .bottom)
            print(listWorkOut)
        }
    }

    
    //MARK: Load workout sessions
    private func loadDefaultWOV() {
        
//        let userDefaults = UserDefaults.standard
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = path.strings(byAppendingPaths: ["userListOfWorkoutsData"])

        if let userListOfWorkouts = NSKeyedUnarchiver.unarchiveObject(withFile: filePath[0]) as? [WorkOutVideo] {
//        if userDefaults.object(forKey: "UserWorkoutList") != nil {  // check if already saved in userDefault
//
//            let userListOfWorkoutsData = userDefaults.object(forKey: "UserWorkoutList") as? Data
//
//            guard let userListOfWorkouts = NSKeyedUnarchiver.unarchiveObject(with: userListOfWorkoutsData!) as? [WorkOutVideo] else {return}
//
            global.workOutVideos = userListOfWorkouts
            for workoutVideos in global.workOutVideos {
                print("[Saving UserDefaults] \(workoutVideos.length)")
                print("[Saving UserDefaults] \(workoutVideos.containSubworkout.count)")
            }

        } else {
            
            guard let wov1 = WorkOutVideo(name: "FULL BODY Upper",
                                          length: "TO THE LIMIT",
                                          workoutLabel: "FullBodyUpper",
                                          isDefault: true,
                                          containSubworkout: [global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["Shoulders"]!,
                                                              global.subWorkoutList["Arms"]!,
                                                              global.subWorkoutList["GlutesCompound"]!,
                                                              global.subWorkoutList["AbsFinisher"]!
                ]) else {
                    fatalError("Error")
            }
            
            guard let wov2 = WorkOutVideo(name: "FULL BODY Glutes",
                                          length: "TO THE LIMIT",
                                          workoutLabel: "FullBodyGlutes",
                                          isDefault: true,
                                          containSubworkout: [global.subWorkoutList["GlutesCompound"]!,
                                                              global.subWorkoutList["Glutes"]!,
                                                              global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["Shoulders"]!,
                                                              global.subWorkoutList["AbsFinisher"]!
                ]) else {
                    fatalError("Error")
            }
            guard let wov3 = WorkOutVideo(name: "UPPER BODY",
                                          length: "TO THE LIMIT",
                                          workoutLabel: "UpperBody",
                                          isDefault: true,
                                          containSubworkout: [global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["ChestBack"]!,
                                                              global.subWorkoutList["Shoulders"]!,
                                                              global.subWorkoutList["Arms"]!,
                                                              global.subWorkoutList["Abs"]!
                ]) else {
                    fatalError("Error")
            }
            guard let wov4 = WorkOutVideo(name: "LOWER BODY",
                                          length: "TO THE LIMIT",
                                          workoutLabel: "LowerBody",
                                          isDefault: true,
                                          containSubworkout: [global.subWorkoutList["GlutesCompound"]!,
                                                              global.subWorkoutList["GlutesCompound"]!,
                                                              global.subWorkoutList["GlutesCompound"]!,
                                                              global.subWorkoutList["GlutesIsolation"]!,
                                                              global.subWorkoutList["GlutesIsolation"]!,
                                                              global.subWorkoutList["Abs"]!
                ]) else {
                    fatalError("Error")
            }
            guard let wov5 = WorkOutVideo(name: "ABS Advance",
                                          length: "TO THE LIMIT",
                                          workoutLabel: "Abs",
                                          isDefault: true,
                                          containSubworkout: [global.subWorkoutList["Abs"]!,
                                                              global.subWorkoutList["Abs"]!,
                                                              global.subWorkoutList["Abs"]!,
                                                              global.subWorkoutList["Abs"]!,
                                                              global.subWorkoutList["Abs"]!,
                                                              global.subWorkoutList["Abs"]!
                ]) else {
                    fatalError("Error")
            }
            guard let wov6 = WorkOutVideo(name: "ABS Intermediate",
                                          length: "TO THE LIMIT",
                                          workoutLabel: "AbsIntermediate",
                                          isDefault: true,
                                          containSubworkout: [  global.subWorkoutList["AbsIntermediate"]!,
                                                                global.subWorkoutList["AbsIntermediate"]!,
                                                                global.subWorkoutList["AbsIntermediate"]!,
                                                                global.subWorkoutList["AbsIntermediate"]!,
                                                                global.subWorkoutList["AbsIntermediate"]!,
                                                                global.subWorkoutList["AbsIntermediate"]!
                ]) else {
                    fatalError("Error")
            }
            
            global.workOutVideos = [wov1, wov2, wov3, wov4, wov5, wov6]

            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let filePath = path.strings(byAppendingPaths: ["userListOfWorkoutsData"])
            NSKeyedArchiver.archiveRootObject(global.workOutVideos, toFile: filePath[0])
            
//            let userListOfWorkoutsData = NSKeyedArchiver.archivedData(withRootObject: global.workOutVideos)
//            for workoutVideo in global.workOutVideos {
//                print("[Saving UserDefaults Return Nil] \(workoutVideo.length)")
//                print("[Saving UserDefaults Return Nil] \(workoutVideo.containSubworkout.count)")
//            }
//
//            userDefaults.set(userListOfWorkoutsData, forKey: "UserWorkoutList")
        }
        
        
        
        
    }

    //MARK: Setup background interface
    func setupBackground() {
        

        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 6.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        
        self.tableView.backgroundColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.barTintColor = UIColor.backgroundColor // color top bar black
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
        self.tabBarController?.tabBar.layer.shadowRadius = 6.0
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.3
        
        self.tabBarController?.tabBar.barTintColor = UIColor.backgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
}



