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
    
    var videoExercises = [VideoExercise]()
    
    var subWorkoutList = [
        
        "FullBodyUpperIntroduction": SubWorkoutList(name: ["FullBodyIntroduction"], contain: [VideoExercise(name:"Full Body Introduction")]),
        "FullBodyGlutesIntroduction": SubWorkoutList(name: ["FullBodyIntroduction"], contain: [VideoExercise(name:"Full Body Introduction")]),
        "UpperBodyIntroduction": SubWorkoutList(name: ["UpperBodyIntroduction"], contain: [VideoExercise(name:"Upper Body Introduction")]),
        "LowerBodyIntroduction": SubWorkoutList(name: ["LowerBodyIntroduction"], contain: [VideoExercise(name:"Lower Body Introduction")]),
        "AbsIntroduction": SubWorkoutList(name: ["AbsIntroduction"], contain: [VideoExercise(name:"Abs Introduction")]),
        "AbsIntermediateIntroduction": SubWorkoutList(name: ["AbsIntermediateIntroduction"], contain: [VideoExercise(name:"Abs Intermediate Introduction")]),
        
        "FullBodyUpperEnding": SubWorkoutList(name: ["FullBodyEnding"], contain: [VideoExercise(name:"Full Body Ending")]),
        "FullBodyGlutesEnding": SubWorkoutList(name: ["FullBodyEnding"], contain: [VideoExercise(name:"Full Body Ending")]),
        "UpperBodyEnding": SubWorkoutList(name: ["UpperBodyEnding"], contain: [VideoExercise(name:"Upper Body Ending")]),
        "LowerBodyEnding": SubWorkoutList(name: ["LowerBodyEnding"], contain: [VideoExercise(name:"Lower Body Ending")]),
        "AbsEnding": SubWorkoutList(name: ["AbsEnding"], contain: [VideoExercise(name:"Abs Ending")]),
        "AbsIntermediateEnding": SubWorkoutList(name: ["AbsIntermediateEnding"], contain: [VideoExercise(name:"Abs Intermediate Ending")]),
        
        "ChestBack": SubWorkoutList(name: ["ChestBack"],
                                    contain: [VideoExercise(name:"Pullup Flat Bench Press"),
                                        VideoExercise(name: "Incline Bench Press Barbell Bent Over Row"),
                                        VideoExercise(name: "Pushup Row")
            
            ]),
        
        "Shoulders": SubWorkoutList(name: ["Shoulders"],
                                    contain: [ VideoExercise(name: "Standing Shoulder Press")
            ]),
        
        "Arms": SubWorkoutList(name: ["Arms"],
                               contain: [ VideoExercise(name: "Tricep Bicep RopeX2"),
                                          VideoExercise(name: "Tricep Bicep RopeX4")
        ]),
//        "Compound": SubWorkoutList(name: ["Compound"]),
        "GlutesCompound": SubWorkoutList(name: ["GlutesCompound"],
                                         contain: [ VideoExercise(name: "Squat"),
                                                    VideoExercise(name: "Romanian Deadlift"),
                                                    VideoExercise(name: "Sumo Deadlift")
            ]),
        "GlutesIsolation": SubWorkoutList(name: ["GlutesIsolation"],
                                          contain: [ VideoExercise(name: "Hip Thrust"),
                                                    VideoExercise(name: "Calf Raise Leg Booty Press")
                                            
            ]),
//        "Isolation": SubWorkoutList(name: ["Isolation"]),
        "Glutes": SubWorkoutList(name: ["Glutes"], contain: [ VideoExercise(name: "Squat"),                                     // Compound Glutes
                                                              VideoExercise(name: "Romanian Deadlift"),
                                                              VideoExercise(name: "Sumo Deadlift"),
                                                              
                                                              VideoExercise(name: "Hip Thrust"),                                 // Isolation Glutes
                                                              VideoExercise(name: "Calf Raise Leg Booty Press")
            ]),
        "Abs": SubWorkoutList(name: ["Abs"], contain: [
                                                        VideoExercise(name: "Jackknife"),
                                                        VideoExercise(name: "Jackknife Crossover"),
                                                        VideoExercise(name: "Situp Crossover"),
                                                        VideoExercise(name: "VSit"),
                                                        VideoExercise(name: "Bicycle"),
                                                        VideoExercise(name: "Corkscrew"),
                                                        VideoExercise(name: "Reverse Crunch Advanced"),
                                                        VideoExercise(name: "Flutter Kicks Advanced"),
                                                        VideoExercise(name: "Russian Twist Advanced"),
                                                        VideoExercise(name: "CrissCross Advanced")
                                                                          
            ]),
        "AbsIntermediate": SubWorkoutList(name: ["AbsIntermediate"],
                                              contain: [
                                                         VideoExercise(name: "Reverse Crunch Intermediate"),
                                                         VideoExercise(name: "Heels Touch"),
                                                         VideoExercise(name: "Arms Up Crunch"),
                                                         VideoExercise(name: "Knees Up Crunch"),
                                                         VideoExercise(name: "Legs Lower"),
                                                         VideoExercise(name: "Flutter Kicks Intermediate"),
                                                         VideoExercise(name: "Russian Twist Intermediate"),
                                                         VideoExercise(name: "CrissCross Intermediate"),
                                                         VideoExercise(name: "Crunch")
                                                         
            ]),
        "AbsFinisher": SubWorkoutList(name: ["Abs", "Finisher"],
                                              contain: [ VideoExercise(name: "Jackknife"),                           // Abs Advanced
                                                         VideoExercise(name: "Jackknife Crossover"),
                                                         VideoExercise(name: "Situp Crossover"),
                                                         VideoExercise(name: "VSit"),
                                                         VideoExercise(name: "Bicycle"),
                                                         VideoExercise(name: "Corkscrew"),
                                                         VideoExercise(name: "Reverse Crunch Advanced"),
                                                         VideoExercise(name: "Flutter Kicks Advanced"),
                                                         VideoExercise(name: "Russian Twist Advanced"),
                                                         VideoExercise(name: "CrissCross Advanced"),
                                                
                                                         VideoExercise(name: "Reverse Crunch Intermediate"),               // Abs Intermediate
                                                         VideoExercise(name: "Heels Touch"),
                                                         VideoExercise(name: "Arms Up Crunch"),
                                                         VideoExercise(name: "Knees Up Crunch"),
                                                         VideoExercise(name: "Legs Lower"),
                                                         VideoExercise(name: "Flutter Kicks Intermediate"),
                                                         VideoExercise(name: "Russian Twist Intermediate"),
                                                         VideoExercise(name: "CrissCross Intermediate"),
                                                         VideoExercise(name: "Crunch"),
                                                
                                                         VideoExercise(name: "erictm HIIT5"),                            // Finisher
                                                         VideoExercise(name: "Hanging Leg Raise")
            ]),
        "Finisher": SubWorkoutList(name: ["Finisher"],
                                   contain: [ VideoExercise(name: "erictm HIIT5"),
                                              VideoExercise(name: "Hanging Leg Raise")
            ]),
        
        "AllVideos": SubWorkoutList(name: ["AllVideos"],
                                    contain: [
                                        VideoExercise(name:"Full Body Introduction"),
                                        VideoExercise(name:"Upper Body Introduction"),
                                        VideoExercise(name:"Lower Body Introduction"),
                                        VideoExercise(name:"Abs Introduction"),
                                        VideoExercise(name:"AbsIntermediate Introduction"),
                                        
                                        VideoExercise(name:"Full Body Ending"),
                                        VideoExercise(name:"Upper Body Ending"),
                                        VideoExercise(name:"Lower Body Ending"),
                                        VideoExercise(name:"Abs Ending"),
                                        VideoExercise(name:"AbsIntermediate Ending"),
                                        
                                        VideoExercise(name:"Pullup Flat Bench Press"),
                                        VideoExercise(name: "Incline Bench Press Barbell Bent Over Row"),
                                        VideoExercise(name: "Pushup Row"),
                                        
                                        VideoExercise(name: "Standing Shoulder Press"),
                                        
                                        VideoExercise(name: "Tricep Bicep RopeX2"),
                                        VideoExercise(name: "Tricep Bicep RopeX4"),
                                        
                                        VideoExercise(name: "Squat"),
                                        VideoExercise(name: "Romanian Deadlift"),
                                        VideoExercise(name: "Sumo Deadlift"),
                                        
                                        VideoExercise(name: "Hip Thrust"),
                                        VideoExercise(name: "CalfRaise Leg Booty Press"),
                                        
                                        VideoExercise(name: "Jackknife"),
                                        VideoExercise(name: "Jackknife Crossover"),
                                        VideoExercise(name: "Situp Crossover"),
                                        VideoExercise(name: "VSit"),
                                        VideoExercise(name: "Bicycle"),
                                        VideoExercise(name: "Corkscrew"),
                                        VideoExercise(name: "Reverse Crunch Advanced"),
                                        VideoExercise(name: "Flutter Kicks Advanced"),
                                        VideoExercise(name: "Russian Twist Advanced"),
                                        VideoExercise(name: "CrissCross Advanced"),
                                        
                                        VideoExercise(name: "Reverse Crunch Intermediate"),
                                        VideoExercise(name: "Heels Touch"),
                                        VideoExercise(name: "Arms Up Crunch"),
                                        VideoExercise(name: "Knees Up Crunch"),
                                        VideoExercise(name: "Legs Lower"),
                                        VideoExercise(name: "Flutter Kicks Intermediate"),
                                        VideoExercise(name: "Russian Twist Intermediate"),
                                        VideoExercise(name: "CrissCross Intermediate"),
                                        VideoExercise(name: "Crunch"),
                                        
                                        VideoExercise(name: "erictm HIIT5"),
                                        VideoExercise(name: "Hanging Leg Raise")
            ])
    ]
}

let global = Global()
