//
//  AddCustomizeWorkoutTableViewController.swift
//  EricTM
//
//  Created by Phan Quân on 9/6/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit

class AddCustomizeWorkoutTableViewController: UITableViewController {
    
    var videoToGet = VideoExercise(name: "")
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.setEditing(true, animated: true)
            self.editButtonItem.title = "Done"
        } else {
            tableView.setEditing(false, animated: true)
            self.editButtonItem.title = "Select"
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
        
        let checkPortraitWorkoutTable = DispatchQueue(label: "checkPortraitWorkoutTable")
        checkPortraitWorkoutTable.sync {
            
            setupBackground()
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        setupBackground()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "Select"
        self.editButtonItem.tintColor = UIColor.lightGray
    
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
//
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .checkmark
//            print("Checkmark")
//        }
        
        if tableView.isEditing == false {
            
            videoToGet = (global.subWorkoutList["AllVideos"]?.contain[indexPath.row])!
            performSegue(withIdentifier: "PlayerVideoExercise", sender: self)
        }
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .none
//        }
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (global.subWorkoutList["AllVideos"]?.contain.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AddCustomizeWorkoutTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AddCustomizeWorkoutTableViewCell else {
            fatalError("[Loading Cell] The dequeued cell is not an instance of AddCustomizeWorkoutTableViewCell.")
        }
        
        let videoExercise = global.subWorkoutList["AllVideos"]?.contain[indexPath.row]
        
        
//        TODO: add UI elements in storyboard and add init cell accordingly
        
        cell.nameVideoExercise.text = videoExercise?.name
        
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

    }


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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


    func setupBackground() {
        
        self.tabBarController?.tabBar.isHidden = false
        
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
