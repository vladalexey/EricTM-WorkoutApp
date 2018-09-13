//
//  AddCustomizeWorkoutTableViewController.swift
//  EricTM
//
//  Created by Phan Quân on 9/6/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(newWorkout: WorkOutVideo)
}

class AddCustomizeWorkoutTableViewController: UITableViewController {
    
    var workoutTableViewController: WorkOutTableViewController?
    
    var videoToGet = VideoExercise(name: "")
    var checkSelected: Bool = false
    var listSelected = [SubWorkoutList]()
    
    lazy var sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(AddCustomizeWorkoutTableViewController.sortVideoExercise(_:)))
    lazy var editButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(AddCustomizeWorkoutTableViewController.editButtonPressed(_:)))
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        var items = [UIBarButtonItem]()
        
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        items.append(
            UIBarButtonItem(title: "CREATE", style: .plain, target: self, action: #selector(saveNewWorkout(_ :)))
        )
        
        items.append(flexibleSpace1)
        
        items.append(
            UIBarButtonItem(title: "DOWNLOAD", style: .plain, target: self, action: #selector(downloadVideo(_ :)))
        )
        
        items.append(flexibleSpace2)
        
        items.append(
            UIBarButtonItem(title: "REMOVE", style: .plain, target: self, action: #selector(removeVideo(_ :)))
        )
        
        if editing {
            tableView.setEditing(true, animated: true)
            
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.setToolbarHidden(false, animated: true)
        
            
            self.navigationController?.toolbar.items = items
            self.navigationController?.toolbar.barTintColor = UIColor.backgroundColor
        
            self.editButton.title = "Done"
            checkSelected = false
            listSelected = []
            
        } else {
            tableView.setEditing(false, animated: true)
            self.editButton.title = "Select"
            
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.setToolbarHidden(true, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var items = [UIBarButtonItem]()
        
        let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        items.append(
            UIBarButtonItem(title: "CREATE", style: .plain, target: self, action: #selector(saveNewWorkout(_ :)))
        )
        
        items.append(flexibleSpace1)
        
        items.append(
            UIBarButtonItem(title: "DOWNLOAD", style: .plain, target: self, action: #selector(downloadVideo(_ :)))
        )
        
        items.append(flexibleSpace2)
        
        items.append(
            UIBarButtonItem(title: "REMOVE", style: .plain, target: self, action: #selector(removeVideo(_ :)))
        )
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        
        self.navigationController?.toolbar.items = items
        self.navigationController?.toolbar.barTintColor = UIColor.backgroundColor
        
        let checkPortraitWorkoutTable = DispatchQueue(label: "checkPortraitWorkoutTable")
        checkPortraitWorkoutTable.sync {
            
            setupBackground()
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let filePath = path.strings(byAppendingPaths: ["userListOfVideoExerciseData"])
            
            if let userListOfVideoExercises = NSKeyedUnarchiver.unarchiveObject(withFile: filePath[0]) as? [VideoExercise] {
                if userListOfVideoExercises.count > 0 {
                    global.videoExercises = userListOfVideoExercises
                }
            } else {
                global.videoExercises = (global.subWorkoutList["AllVideos"]?.contain)!
                
                NSKeyedArchiver.archiveRootObject(global.videoExercises, toFile: filePath[0])
            }
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("[Video Exercises] \(global.videoExercises)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEditing(true, animated: true)
        
        
        
        sortButton.tintColor = UIColor.lightGray
        editButton.tintColor = UIColor.lightGray
        self.navigationItem.leftBarButtonItem = sortButton
        self.navigationItem.rightBarButtonItem = editButton
        
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
        
        setupBackground()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        self.navigationItem.rightBarButtonItem = self.editButtonItem
//        self.editButtonItem.title = "Select"
//        self.editButtonItem.tintColor = UIColor.lightGray
    
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        videoToGet = global.videoExercises[indexPath.row]
        
        if tableView.isEditing == false {
            print("[Video Exercise] \(videoToGet.name)")
            performSegue(withIdentifier: "PlayerVideoExercise", sender: self)
            
        } else {
            print("[Selecting] True")
            checkSelected = true
            let newSubWorkoutList = SubWorkoutList(name: ["UserCustom"], contain: [videoToGet])
            self.listSelected.append(newSubWorkoutList)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (global.videoExercises.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AddCustomizeWorkoutTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddCustomizeWorkoutTableViewCell else {
            fatalError("[Loading Cell] The dequeued cell is not an instance of AddCustomizeWorkoutTableViewCell.")
        }
        
        let videoExercise = global.videoExercises[indexPath.row]
        var videoNameFile = videoExercise.name
        videoNameFile = videoNameFile.replacingOccurrences(of: " ", with: "")
        videoNameFile.append(".mp4")
        
//        TODO: add UI elements in storyboard and add init cell accordingly
        
        cell.nameVideoExercise.text = videoExercise.name
        
        let imageThumbnail = UIImage(named: "Thumbnail")
        
        
        if checkFileAvailableLocal(nameFileToCheck: videoNameFile) {
            cell.downloadCheck.image = UIImage(named: "Download")
            cell.smallThumbnail.image = imageThumbnail
        } else {
            cell.downloadCheck.image = nil
            cell.smallThumbnail.image = imageThumbnail?.noir
        }
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.backgroundColorCell
        cell.selectedBackgroundView = colorView
        
        //        cell.smallThumbnail.image = UIImage(named: (videoExercise?.name)!) //TODO: Create and name smallthumbnail images with exercise

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.backgroundColor
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let videoExercise = global.videoExercises[fromIndexPath.row]
        
        global.videoExercises.remove(at: fromIndexPath.row)
        global.videoExercises.insert(videoExercise, at: to.row)
        
        print("[Video Exercises] \(global.videoExercises[fromIndexPath.row].name, global.videoExercises[to.row].name)")
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
    

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { action, index in

            print("[Table Editing]" + global.videoExercises[indexPath.row].name + " deleted")
            
            var nameFileToDelete = global.videoExercises[indexPath.row].name
            nameFileToDelete = nameFileToDelete.replacingOccurrences(of: " ", with: "")
            nameFileToDelete.append(".mp4")
            
            self.deleteContentFromLocal(fileNameToDelete: nameFileToDelete )
        }
        remove.backgroundColor = .red
        
        return [remove]
    }
    
    func exitEditModeIfTrue() {
        
        if self.isEditing {
            self.setEditing(false, animated: true)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PlayerVideoExercise" {
            
            exitEditModeIfTrue()
            
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
            
            let destVC = segue.destination as? PlayerViewExercise
            
            print("[Video Playing Exercise] Begin video exercise")
            
            destVC?.videoToGet = videoToGet
            
        }
    }
    
    @objc func downloadVideo(_ sender:UIBarButtonItem) {
        print("[Video Editing] Download ")
    }
    
    @objc func removeVideo(_ sender:UIBarButtonItem) {
        print("[Video Editing] Remove ")
    }
    
    @objc func saveNewWorkout(_ sender: UIBarButtonItem) {
        
        let saveSelectedWorkout = DispatchWorkItem {
            
            if self.checkSelected {
                
                let saveNewWorkout = UIAlertController(title: "Create New Workout", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
                saveNewWorkout.addTextField(configurationHandler: {textField in
                    textField.placeholder = "Workout Name"
                })
                
                saveNewWorkout.addTextField(configurationHandler: {textField in
                    textField.placeholder = "Subtitle"
                })
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    
                    saveNewWorkout.dismiss(animated: true, completion: nil)
                    
                    //TODO: Clear check selected
                    
                    print("[Table Create] Cancel")
                }
                
                saveNewWorkout.addAction(cancelAction)
                
                let saveAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    
                    print("[Table Create] Create")
                    
                    print("[Save New Workout] Custom workout non nil")
                    if let name = saveNewWorkout.textFields?.first?.text {
                        
                        guard let newWorkout = WorkOutVideo(name: name, length: "45'", workoutLabel: "UserCustom", isDefault: false, containSubworkout: self.listSelected) else {
                            print("[Add Workout] Error in adding workout in AddWorkoutController")
                            return
                        }
                        
                        global.workOutVideos.append(newWorkout)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil) // to notify tableview to reload when done adding workout

                        
                        saveNewWorkout.dismiss(animated: true, completion: nil)
                        
                    } else {
                        print("[Save New Workout] Error Name Input" )
                    }
                }
                
                saveNewWorkout.addAction(saveAction)
                
                self.present(saveNewWorkout, animated: true, completion: self.exitEditModeIfTrue)
                
            }
        }
        
        DispatchQueue.main.async(execute: saveSelectedWorkout)
//
//        saveSelectedWorkout.notify(queue: DispatchQueue.main) {
//            self.exitEditModeIfTrue()
//        }
    }
    
    @objc func sortVideoExercise(_ sender:UIBarButtonItem) {
        //TODO: Sort videos alphabetically/workout
        print("[Sorting] Pressed")
        
        let saveNewWorkout = UIAlertController(title: "Sorting Exercises", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let alphabetAction = UIAlertAction(title: "Alphabetically", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            global.videoExercises.sort { $0.name < $1.name}
            self.tableView.reloadData()
            
            saveNewWorkout.dismiss(animated: true, completion: nil)
            
            print("[Table Sort] Alphabetically")
        }
        
        saveNewWorkout.addAction(alphabetAction)
        
        let workoutAction = UIAlertAction(title: "Workout", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            saveNewWorkout.dismiss(animated: true, completion: nil)
            
            print("[Table Sort] Workout")
        }
        
        saveNewWorkout.addAction(workoutAction)
        
        self.present(saveNewWorkout, animated: true, completion: nil)
    }
    
    @objc func editButtonPressed(_ sender:UIBarButtonItem) {
        
        if self.isEditing == false {
            self.setEditing(true, animated: true)
            print("[Editing] Edit")
            
        } else {
            print("[Editing] Done")
            self.setEditing(false, animated: true)
        }
    }
    
    //MARK: Private Methods
    


    func setupBackground() {
    
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 6.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        
        self.tableView.backgroundColor = UIColor.backgroundColor
        self.navigationController?.navigationBar.barTintColor = UIColor.backgroundColor // color top bar black
        self.navigationController?.navigationBar.isTranslucent = false
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
}
