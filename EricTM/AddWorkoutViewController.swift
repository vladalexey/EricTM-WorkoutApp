//
//  AddWorkoutViewController.swift
//  EricTM
//
//  Created by Phan Quân on 7/4/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(nameWorkout: String, lengthWorkout: String)
}

class AddWorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    
    var delegate: DataSentDelegate? = nil
    
    @IBOutlet weak var nameWorkoutInput: UITextField!
    @IBOutlet weak var lengthWorkoutPicker: UIPickerView!
    
    
    var pickerData: [String] = [ "45 minutes", "60 minutes", "75 minutes", "90 minutes" ]
    
    
    let backgroundColor = UIColor(
        red: 0.20,
        green: 0.20,
        blue: 0.20,
        alpha: 1.0
    )
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lengthWorkoutPicker.delegate = self
        self.lengthWorkoutPicker.dataSource = self
        
        setupBackground()
        
        setCancelButton()
        saveWorkout()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
        
        //MARK: Setting logo on NavBar
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
    
    func saveWorkout() {
        
        let saveButton: UIBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector((saveWorkoutDone)))
        saveButton.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveWorkoutDone() {
        
        if delegate != nil {
            print("non nil")
            if nameWorkoutInput != nil && lengthWorkoutPicker != nil {
                print("name not nil")
                delegate?.userDidEnterData(nameWorkout: nameWorkoutInput.text!, lengthWorkout: pickerData[lengthWorkoutPicker.selectedRow(inComponent: 0)])
                print(lengthWorkoutPicker.selectedRow(inComponent: 0))
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func setCancelButton() {
        
        let cancel: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector((AddWorkoutViewController.cancel)))
        cancel.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = cancel
    }
    
    @objc func cancel() {
        print("cancel add workout")
        dismiss(animated: true, completion: nil)
    }
}
