//
//  AddWorkoutViewController.swift
//  EricTM
//
//  Created by Phan Quân on 7/4/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit

class AddWorkoutViewController: UIViewController {
    
    let backgroundColor = UIColor(
        red: 0.25,
        green: 0.25,
        blue: 0.25,
        alpha: 1.0
    )
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupBackground()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancel: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector((AddWorkoutViewController.cancel)))
        
        self.navigationItem.leftBarButtonItem = cancel

        // Do any additional setup after loading the view.
    }
    
    @objc func cancel() {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
