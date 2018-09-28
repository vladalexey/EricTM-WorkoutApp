//
//  AppDelegate.swift
//  EricTM
//
//  Created by Phan Quân on 6/22/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import MediaPlayer


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    enum TypeInterfaceOrientationMask {
        case all
        case portrait
        case landscape
    }
    
    var restrictRotation:TypeInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        FirebaseApp.configure()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
            let _ = try AVAudioSession.sharedInstance().setActive(true)
            print("[Remote] Set audio session Playback + setActive")
        } catch let error as NSError {
            print("an error occurred when audio session category.\n \(error)")
        }
        
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
        
        

        let filePath2 = path.strings(byAppendingPaths: ["userListOfWorkoutsData"])
        
        if let userListOfWorkouts = NSKeyedUnarchiver.unarchiveObject(withFile: filePath2[0]) as? [WorkOutVideo] {
            
            global.workOutVideos = userListOfWorkouts
            for workoutVideos in global.workOutVideos {
                print("[Saving UserDefaults] \(workoutVideos.length)")
                print("[Saving UserDefaults] \(workoutVideos.containSubworkout.count)")
            }
            
        } else {
            
            guard let wov1 = WorkOutVideo(name: "FULL BODY Upper",
                                          length: "45",
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
                                          length: "45",
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
                                          length: "45",
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
                                          length: "45",
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
                                          length: "45",
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
                                          length: "45",
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
            let filePath2 = path.strings(byAppendingPaths: ["userListOfWorkoutsData"])
            NSKeyedArchiver.archiveRootObject(global.workOutVideos, toFile: filePath2[0])
        }
        
        
        return true
    }
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
//    {
//
//
//        switch self.restrictRotation {
//        case .all:
//            return UIInterfaceOrientationMask.all
//        case .portrait:
//            return UIInterfaceOrientationMask.portrait
//        case .landscape:
//            return UIInterfaceOrientationMask.landscape
//        }
//    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock

    }

    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Saving workoutList into UserDefault storage in phone
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePathWorkoutList = path.strings(byAppendingPaths: ["userListOfWorkoutsData"])
        NSKeyedArchiver.archiveRootObject(global.workOutVideos, toFile: filePathWorkoutList[0])
        
        let filePathVideoExerciseList = path.strings(byAppendingPaths: ["userListOfVideoExerciseData"])
        NSKeyedArchiver.archiveRootObject(global.videoExercises, toFile: filePathVideoExerciseList[0])

    }
    
    //MARK: Set locked portrait mode for all screen
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if window == self.window {
//            return .portrait
//        } else {
//            return .allButUpsideDown
//        }
//    }
    
    //MARK: Set locked portrait mode for one screen
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if self.window?.rootViewController?.presentedViewController is WorkOutTableViewController {
//            return UIInterfaceOrientationMask.portrait
//        } else {
//            return UIInterfaceOrientationMask.all
//        }
//    }
}

//extension UIImageView
//{
//    func addBlurEffect()
//    {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
//        self.sendSubview(toBack: blurEffectView)
//    }
//}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
