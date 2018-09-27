//
//  AddCustomizeWorkoutTableViewController.swift
//  EricTM
//
//  Created by Phan Quân on 9/6/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVKit

protocol DataSentDelegate {
    func userDidEnterData(newWorkout: WorkOutVideo)
}

class AddCustomizeWorkoutTableViewController: UITableViewController {
    
    var workoutTableViewController: WorkOutTableViewController?
    
    var videoToGet = VideoExercise(name: "")
    var checkSelected: Bool = false
    var listSelected = [SubWorkoutList]()
    var listSelectedIndex = [Int]()
    var downloadTask1: StorageReference {
        return Storage.storage().reference()
    }
    
    lazy var sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(AddCustomizeWorkoutTableViewController.sortVideoExercise(_:)))
    
    lazy var saveButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(AddCustomizeWorkoutTableViewController.saveNewWorkout(_:)))
    
    lazy var editButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(AddCustomizeWorkoutTableViewController.editButtonPressed(_:)))
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.setEditing(true, animated: true)
            saveButton.tintColor = UIColor.lightGray
            self.navigationItem.leftBarButtonItem = saveButton
        
            self.editButton.title = "Done"
            checkSelected = false
            listSelected = []
            listSelectedIndex = []
            
        } else {
            tableView.setEditing(false, animated: true)
            self.editButton.title = "Select"
            
            sortButton.tintColor = UIColor.lightGray
            self.navigationItem.leftBarButtonItem = sortButton
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
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let checkPortraitWorkoutTable = DispatchQueue(label: "checkPortraitWorkoutTable")

        checkPortraitWorkoutTable.sync {
            
            setupBackground()
            
            print("[Screen Orientation] check Portrait in Table view")
            if UIApplication.shared.statusBarOrientation.isPortrait == false {
                print("[Screen Orientation] change to Portrait")
                AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        sortButton.tintColor = UIColor.lightGray
        editButton.tintColor = UIColor.lightGray
        self.navigationItem.leftBarButtonItem = sortButton
        self.navigationItem.rightBarButtonItem = editButton
        
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let setupBackgroundDispatch = DispatchWorkItem() {
            self.setupBackground()
            self.setEditing(false, animated: true)
        }
        
        DispatchQueue.global().async {
            self.loadDataFromLocal()
            DispatchQueue.main.async(execute: setupBackgroundDispatch)
        }
        
        setupBackgroundDispatch.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVideoDuration(videoURL: URL) -> String {
        
        let duration = AVURLAsset(url: videoURL).duration.seconds
        let time: String

        time = String(format:"%d:%d",
                          Int((duration/60).truncatingRemainder(dividingBy: 60)),
                          Int(duration.truncatingRemainder(dividingBy: 60)))
        return time
    }
    
    func checkFileAvailableLocal(nameFileToCheck: String) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(nameFileToCheck) {
            
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
//                print("FILE AVAILABLE")
                return true
                
            } else {
//                print("FILE NOT AVAILABLE")
                return false
            }
        } else {
//            print("FILE PATH NOT AVAILABLE")
            return false
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        videoToGet = global.videoExercises[indexPath.row]
        
        if tableView.isEditing == false {
            print("[Video Exercise] \(videoToGet.duration)")
            print("[Video Exercise] \(videoToGet.localURL)")
            performSegue(withIdentifier: "PlayerVideoExercise", sender: self)
            
        } else {
            print("[Selecting] True")
            checkSelected = true
            let newSubWorkoutList = SubWorkoutList(name: ["UserCustom"], contain: [videoToGet])
            self.listSelected.append(newSubWorkoutList)
            self.listSelectedIndex.append(indexPath.row)
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
        var videoNameFileThumbnail = videoNameFile
        videoNameFile.append(".mp4")
        videoNameFileThumbnail.append(".jpeg")
        
        cell.nameVideoExercise.text = videoExercise.name
        let imageThumbnail = UIImage(named: videoNameFileThumbnail)
        
        cell.progressVideoDownload.isHidden = true
        
//        if videoExercise.localURL == nil {
        
        if checkFileAvailableLocal(nameFileToCheck: videoNameFile) {
            
            cell.downloadVideoButton.imageView?.transform = CGAffineTransform(scaleX: 0, y: 0)
//            print("[Scale] 0")
            cell.Vignette.image = imageThumbnail

            // place local URL to file if already downloaded
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(videoNameFile) {
                videoExercise.setLocalURL(localURL: pathComponent)

            }

        } else {
            
            cell.downloadVideoButton.setImage(UIImage(named: "Download"), for: .normal)
//            cell.downloadVideoButton.imageView?.transform = CGAffineTransform.identity
//            print("[Scale] 1")
            cell.downloadVideoButton.adjustsImageWhenHighlighted = true
            cell.downloadVideoButton.addTarget(self, action: #selector(AddCustomizeWorkoutTableViewController.downloadVideoSingle(_:)), for: .touchUpInside)
            cell.downloadVideoButton.tag = indexPath.row // to get index of the cell
        }

        
        cell.videoDuration.text = videoExercise.duration
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.backgroundColorCell
        cell.selectedBackgroundView = colorView

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.backgroundColor
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
                tableView.reloadData()
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
            global.videoExercises[indexPath.row].localURL = nil
            global.videoExercises[indexPath.row].duration = ""
            
//            let doneRemoving = UIAlertController(title: "Remove Exercises Successfully", message: "", preferredStyle: UIAlertController.Style.alert)
//            doneRemoving.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(doneRemoving, animated: true, completion: self.exitEditModeIfTrue)
            
            tableView.reloadData()
            self.exitEditModeIfTrue
            
        }
        remove.backgroundColor = .red
        
        return [remove]
    }
    
    func exitEditModeIfTrue() {
        
        if self.isEditing {
            self.setEditing(false, animated: true)
            tableView.reloadData()
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
    
    //MARK: Exit video due to Error
    func exitVideoPlayerError() {
        
        print("[Error] Exit video player")
        
        let alertView = UIAlertController(title: "Error", message: "Cannot load videos", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Try again", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            print("[Error] OK")
            
            alertView.dismiss(animated: true, completion: nil)

        }
        
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func setDurationForDownloadedVideo(downloadedVideo: VideoExercise, URL: URL) {
        downloadedVideo.setLocalURL(localURL: URL)
        downloadedVideo.setDuration(videoDuration: self.getVideoDuration(videoURL: URL))
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = path.strings(byAppendingPaths: ["userListOfVideoExerciseData"])
        
        NSKeyedArchiver.archiveRootObject(global.videoExercises, toFile: filePath[0])
        
    }
    
    @objc func downloadVideoSingle(_ sender:UIButton) {
        
        let currentIndex = sender.tag
        var videoName = global.videoExercises[currentIndex].name
        videoName = videoName.replacingOccurrences(of: " ", with: "")
        videoName.append(".mp4")
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let localURL = documentsURL.appendingPathComponent(videoName)
        
        if checkFileAvailableLocal(nameFileToCheck: videoName) == false {
            
            let indexPath = IndexPath(row: currentIndex, section: 0)
            
            let cellDownloading = self.tableView.cellForRow(at: indexPath) as? AddCustomizeWorkoutTableViewCell
            cellDownloading?.downloadVideoButton.showLoading()
            cellDownloading?.progressVideoDownload.isHidden = false
            
            // Download to the local system
            let downloadVideo = downloadTask1.child(videoName).write(toFile: localURL) { url, error in
                if let error = error {
                    
                    print("[Download Video] Error when downloading to local \(error, videoName)" )
                    self.exitVideoPlayerError()
                    return
                    
                } else {
                    
                    print("[Download Video] sucessfully downloaded video \(videoName)")
                    
                    self.setDurationForDownloadedVideo(downloadedVideo: global.videoExercises[currentIndex], URL: url!)
                    
                    cellDownloading?.videoDuration.text = self.getVideoDuration(videoURL: url!)
                    cellDownloading?.videoDuration.isHidden = false
                    self.tableView.reloadData()
                }
            }
            
            downloadVideo.observe(.progress) { snapshot in
                // Download reported progress
                let percentComplete = Float(snapshot.progress!.completedUnitCount)
                    / Float(snapshot.progress!.totalUnitCount)
                
                cellDownloading?.progressVideoDownload.progress = percentComplete
            }
            
            downloadVideo.observe(.success) { snapshot in
                self.activityIndicatorView.stopAnimating()
                // Download completed successfully
                
                cellDownloading?.downloadVideoButton.hideLoading()
                cellDownloading?.progressVideoDownload.isHidden = true
                cellDownloading?.progressVideoDownload.progress = 0
                
                cellDownloading?.videoDuration.isHidden = false
                cellDownloading?.videoDuration.text = self.getVideoDuration(videoURL: localURL)
                
                self.setDurationForDownloadedVideo(downloadedVideo: global.videoExercises[currentIndex], URL: localURL)
                
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func downloadVideo(_ sender:UIBarButtonItem) {
        print("[Video Editing] Download ")
        
        if checkSelected {
            for index in 0...listSelected.count - 1 {
                
                let subworkout = listSelected[index]
                
                let videoName = subworkout.contain[0].name
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let localURL = documentsURL.appendingPathComponent(videoName)
                
                if checkFileAvailableLocal(nameFileToCheck: videoName) == false {
                    
                    let currentIndex = IndexPath(row: listSelectedIndex[index], section: 0)
                    let cellDownloading = self.tableView.cellForRow(at: currentIndex) as? AddCustomizeWorkoutTableViewCell
                    cellDownloading?.downloadVideoButton.showLoading()
                    
                    // Download to the local system
                    let downloadVideo = downloadTask1.child(videoName).write(toFile: localURL) { url, error in
                        if let error = error {
                            
                            print("[Download Video] Error when downloading to local \(error, videoName)" )
                            self.exitVideoPlayerError()
                            return
                            
                        } else {
                            
                            print("[Download Video] sucessfully downloaded video \(videoName)")
                            self.tableView.reloadData()
                            subworkout.contain[0].setLocalURL(localURL: url!)
                        }
                    }
                    
                    downloadVideo.observe(.success) { snapshot in
                        // Download completed successfully
                        cellDownloading?.downloadVideoButton.hideLoading()
                    }

                }
            }
        } else {
            let doneRemoving = UIAlertController(title: "Select exercise", message: "", preferredStyle: UIAlertController.Style.alert)
            doneRemoving.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(doneRemoving, animated: true, completion: nil)
        }
    }
    
    @objc func removeVideo(_ sender:UIBarButtonItem) {
        print("[Video Editing] Remove ")
        
        
        if checkSelected {
            
            for subworkout in listSelected {
                
                var nameFileToDelete = subworkout.contain[0].name
                
                nameFileToDelete = nameFileToDelete.replacingOccurrences(of: " ", with: "")
                nameFileToDelete.append(".mp4")
                
                self.deleteContentFromLocal(fileNameToDelete: nameFileToDelete )
                subworkout.contain[0].localURL = nil
                subworkout.contain[0].duration = ""
                
            }
            
            
            tableView.reloadData()
            self.exitEditModeIfTrue()
        } else {
            let doneRemoving = UIAlertController(title: "Select exercise", message: "", preferredStyle: UIAlertController.Style.alert)
            doneRemoving.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(doneRemoving, animated: true, completion: nil)
        }
    }
    
    @objc func saveNewWorkout(_ sender: UIBarButtonItem) {
        
        let saveSelectedWorkout = DispatchWorkItem {
            
            if self.checkSelected {
                
                let saveNewWorkout = UIAlertController(title: "Create New Workout", message: "", preferredStyle: UIAlertController.Style.alert)
            
                saveNewWorkout.addTextField(configurationHandler: {textField in
                    textField.placeholder = "Workout Name"
                })
                
                saveNewWorkout.addTextField(configurationHandler: {textField in
                    textField.placeholder = "Subtitle"
                })
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    
                    self.checkSelected = false
                    self.listSelected = []
                    saveNewWorkout.dismiss(animated: true, completion: nil)

                    
                    print("[Table Create] Cancel")
                }
                
                saveNewWorkout.addAction(cancelAction)
                
                let saveAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) {
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
                
            } else {
                let doneRemoving = UIAlertController(title: "Select exercise", message: "", preferredStyle: UIAlertController.Style.alert)
                doneRemoving.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(doneRemoving, animated: true, completion: nil)
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
        
        let sortWorkout = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let alphabetAction = UIAlertAction(title: "Name", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            global.videoExercises.sort { $0.name < $1.name}
            self.tableView.reloadData()
            
            sortWorkout.dismiss(animated: true, completion: nil)
            
            print("[Table Sort] Name")
        }
        
        sortWorkout.addAction(alphabetAction)
        
        let workoutAction = UIAlertAction(title: "Muscle Group", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
            sortWorkout.dismiss(animated: true, completion: nil)
            
            print("[Table Sort] Muscle Group")
        }
        
        sortWorkout.addAction(workoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            (result : UIAlertAction) -> Void in
            
            self.checkSelected = false
            self.listSelected = []
            sortWorkout.dismiss(animated: true, completion: nil)
            
            
            print("[Table Create] Cancel")
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        sortWorkout.addAction(cancelAction)
        
        self.present(sortWorkout, animated: true, completion: nil)
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]  // color top bar text white
        
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
        navigationItem.titleView?.sendSubviewToBack(logoContainer)
        
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.tabBarController?.tabBar.layer.shadowRadius = 6.0
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.3
        
        self.tabBarController?.tabBar.barTintColor = UIColor.backgroundColor
    }
    
    func loadDataFromLocal() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = path.strings(byAppendingPaths: ["userListOfVideoExerciseData"])
        
        if let userListOfVideoExercises = NSKeyedUnarchiver.unarchiveObject(withFile: filePath[0]) as? [VideoExercise] {
            if userListOfVideoExercises.count > 0 {
                global.videoExercises = userListOfVideoExercises
            } else {
                global.videoExercises = (global.subWorkoutList["AllVideos"]?.contain)!
                
                NSKeyedArchiver.archiveRootObject(global.videoExercises, toFile: filePath[0])
            }
        } else {
            global.videoExercises = (global.subWorkoutList["AllVideos"]?.contain)!
            
            NSKeyedArchiver.archiveRootObject(global.videoExercises, toFile: filePath[0])
        }
    }
}
