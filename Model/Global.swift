//
//  Global.swift
//  EricTM
//
//  Created by Phan Quân on 8/29/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class Global {
    
    var workOutVideos = [WorkOutVideo]()
    
    var subWorkoutList = [
        
        "FullBodyUpperIntroduction": SubWorkoutList(name: ["FullBodyIntroduction"], contain: [VideoExercise(name:"FullBodyIntroduction.mp4")]),
        "FullBodyGlutesIntroduction": SubWorkoutList(name: ["FullBodyIntroduction"], contain: [VideoExercise(name:"FullBodyIntroduction.mp4")]),
        "UpperBodyIntroduction": SubWorkoutList(name: ["UpperBodyIntroduction"], contain: [VideoExercise(name:"UpperBodyIntroduction.mp4")]),
        "LowerBodyIntroduction": SubWorkoutList(name: ["LowerBodyIntroduction"], contain: [VideoExercise(name:"LowerBodyIntroduction.mp4")]),
        "AbsIntroduction": SubWorkoutList(name: ["AbsIntroduction"], contain: [VideoExercise(name:"AbsIntroduction.mp4")]),
        "AbsIntermediateIntroduction": SubWorkoutList(name: ["AbsIntermediateIntroduction"], contain: [VideoExercise(name:"AbsIntermediateIntroduction.mp4")]),
        
        "FullBodyUpperEnding": SubWorkoutList(name: ["FullBodyEnding"], contain: [VideoExercise(name:"FullBodyEnding.mp4")]),
        "FullBodyGlutesEnding": SubWorkoutList(name: ["FullBodyEnding"], contain: [VideoExercise(name:"FullBodyEnding.mp4")]),
        "UpperBodyEnding": SubWorkoutList(name: ["UpperBodyEnding"], contain: [VideoExercise(name:"UpperBodyEnding.mp4")]),
        "LowerBodyEnding": SubWorkoutList(name: ["LowerBodyEnding"], contain: [VideoExercise(name:"LowerBodyEnding.mp4")]),
        "AbsEnding": SubWorkoutList(name: ["AbsEnding"], contain: [VideoExercise(name:"AbsEnding.mp4")]),
        "AbsIntermediateEnding": SubWorkoutList(name: ["AbsIntermediateEnding"], contain: [VideoExercise(name:"AbsIntermediateEnding.mp4")]),
        
        "ChestBack": SubWorkoutList(name: ["ChestBack"],
                                    contain: [VideoExercise(name:"PullupFlatBenchPress.mp4"),
                                        VideoExercise(name: "InclineBenchPressBarbellBentOverRow.mp4"),
                                        VideoExercise(name: "PushupRow.mp4")
            
            ]),
        
        "Shoulders": SubWorkoutList(name: ["Shoulders"],
                                    contain: [ VideoExercise(name: "StandingShoulderPress.mp4")
            ]),
        
        "Arms": SubWorkoutList(name: ["Arms"],
                               contain: [ VideoExercise(name: "TricepBicepRopeX2.mp4"),
                                          VideoExercise(name: "TricepBicepRopeX4.mp4")
        ]),
//        "Compound": SubWorkoutList(name: ["Compound"]),
        "GlutesCompound": SubWorkoutList(name: ["GlutesCompound"],
                                         contain: [ VideoExercise(name: "Squat.mp4"),
                                                    VideoExercise(name: "RomanianDeadlift.mp4"),
                                                    VideoExercise(name: "SumoDeadlift.mp4")
            ]),
        "GlutesIsolation": SubWorkoutList(name: ["GlutesIsolation"],
                                          contain: [ VideoExercise(name: "HipThrust.mp4"),
                                                    VideoExercise(name: "CalfRaiseLegBootyPress.mp4")
                                            
            ]),
//        "Isolation": SubWorkoutList(name: ["Isolation"]),
        "Glutes": SubWorkoutList(name: ["Glutes"], contain: [ VideoExercise(name: "Squat.mp4"),                                     // Compound Glutes
                                                              VideoExercise(name: "RomanianDeadlift.mp4"),
                                                              VideoExercise(name: "SumoDeadlift.mp4"),
                                                              
                                                              VideoExercise(name: "HipThrust.mp4"),                                 // Isolation Glutes
                                                              VideoExercise(name: "CalfRaiseLegBootyPress.mp4")
            ]),
        "Abs": SubWorkoutList(name: ["Abs"], contain: [
                                                        VideoExercise(name: "Jackknife.mp4"),
                                                        VideoExercise(name: "JackknifeCrossover.mp4"),
                                                        VideoExercise(name: "SitupCrossover.mp4"),
                                                        VideoExercise(name: "VSit.mp4"),
                                                        VideoExercise(name: "Bicycle.mp4"),
                                                        VideoExercise(name: "Corkscrew.mp4"),
                                                        VideoExercise(name: "ReverseCrunchAdvanced.mp4"),
                                                        VideoExercise(name: "FlutterKicksAdvanced.mp4"),
                                                        VideoExercise(name: "RussianTwistAdvanced.mp4"),
                                                        VideoExercise(name: "CrissCrossAdvanced.mp4")
                                                                          
            ]),
        "AbsIntermediate": SubWorkoutList(name: ["AbsIntermediate"],
                                              contain: [
                                                         VideoExercise(name: "ReverseCrunchIntermediate.mp4"),
                                                         VideoExercise(name: "HeelsTouch.mp4"),
                                                         VideoExercise(name: "ArmsUpCrunch.mp4"),
                                                         VideoExercise(name: "KneesUpCrunch.mp4"),
                                                         VideoExercise(name: "LegsLower.mp4"),
                                                         VideoExercise(name: "FlutterKicksIntermediate.mp4"),
                                                         VideoExercise(name: "RussianTwistIntermediate.mp4"),
                                                         VideoExercise(name: "CrissCrossIntermediate.mp4"),
                                                         VideoExercise(name: "Crunch.mp4")
                                                         
            ]),
        "AbsFinisher": SubWorkoutList(name: ["Abs", "Finisher"],
                                              contain: [ VideoExercise(name: "Jackknife.mp4"),                           // Abs Advanced
                                                         VideoExercise(name: "JackknifeCrossover.mp4"),
                                                         VideoExercise(name: "SitupCrossover.mp4"),
                                                         VideoExercise(name: "VSit.mp4"),
                                                         VideoExercise(name: "Bicycle.mp4"),
                                                         VideoExercise(name: "Corkscrew.mp4"),
                                                         VideoExercise(name: "ReverseCrunchAdvanced.mp4"),
                                                         VideoExercise(name: "FlutterKicksAdvanced.mp4"),
                                                         VideoExercise(name: "RussianTwistAdvanced.mp4"),
                                                         VideoExercise(name: "CrissCrossAdvanced.mp4"),
                                                
                                                         VideoExercise(name: "ReverseCrunchIntermediate.mp4"),               // Abs Intermediate
                                                         VideoExercise(name: "HeelsTouch.mp4"),
                                                         VideoExercise(name: "ArmsUpCrunch.mp4"),
                                                         VideoExercise(name: "KneesUpCrunch.mp4"),
                                                         VideoExercise(name: "LegsLower.mp4"),
                                                         VideoExercise(name: "FlutterKicksIntermediate.mp4"),
                                                         VideoExercise(name: "RussianTwistIntermediate.mp4"),
                                                         VideoExercise(name: "CrissCrossIntermediate.mp4"),
                                                         VideoExercise(name: "Crunch.mp4"),
                                                
                                                         VideoExercise(name: "erictmHIIT5.mp4"),                            // Finisher
                                                         VideoExercise(name: "HangingLegRaise.mp4")
            ]),
        "Finisher": SubWorkoutList(name: ["Finisher"],
                                   contain: [ VideoExercise(name: "erictmHIIT5.mp4"),
                                              VideoExercise(name: "HangingLegRaise.mp4")
            ])
    ]
}

let global = Global()
