//
//  SettingsViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 26.04.21.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var frqText: UITextField!
    @IBOutlet weak var disText: UITextField!
    @IBOutlet weak var speText: UITextField!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Picker.delegate = self
        self.Picker.dataSource = self
        
        pickerData = ["3D Wave", "2D standing wave", "3D standing wave", "4"]
        
        //Looks for single or multiple taps.
             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
    @IBOutlet weak var anchorSwitch: UISwitch!
    
    var frequency = 10.0
    var distance = 0.3
    var speed = 100.0
    
    @IBOutlet weak var Picker: UIPickerView!
//    var selected = 1;
    
    
    // 0 - 3D Wave
    // 1 - 2D Standing wave
    
    @IBAction func startARButton(_ sender: Any) {
        if let frq = Double(frqText.text!) {
            self.frequency = frq
        }
        if let dis = Double(disText.text!) {
            self.distance = dis
        }
        if let spe = Double(speText.text!) {
            self.speed = spe
        }
        
        let selected = Picker.selectedRow(inComponent: 0)
        if (selected == 0){
            performSegue(withIdentifier: "3dvariables", sender: sender)
        }else if (selected == 1){
            performSegue(withIdentifier: "2dStandingWaveVariables", sender: sender)
        }else if (selected == 2){
            performSegue(withIdentifier: "3dStandingWaveVariables", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = Picker.selectedRow(inComponent: 0)
        if selected == 0 {
            let vc = segue.destination as! ThreeDARViewController
            vc.frequencyValue = frequency
        }else if selected == 1 {
            let vc = segue.destination as! _2DStandingWaveViewController
            vc.frequencyValue = frequency
            vc.distance = distance
            vc.showAnchor = anchorSwitch.isOn
            vc.timing = speed / 500
            print("Timing: " + String(vc.timing))
        }else if selected == 2 {
            let vc = segue.destination as! _3DStandinWaveViewController
            vc.frequencyValue = frequency
            vc.distance = distance
            vc.showAnchor = anchorSwitch.isOn
            vc.timing = speed * 1.0 / 100
        }
        
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
        
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->  String? {
        return pickerData[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
