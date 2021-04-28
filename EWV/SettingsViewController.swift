//
//  SettingsViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 26.04.21.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var ampText: UITextField!
    @IBOutlet weak var perText: UITextField!
    @IBOutlet weak var disText: UITextField!
    @IBOutlet weak var radText: UITextField!
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
        periode = 10.0
        amplitude = 10.0
        distance = 0.3
        radius = 1.0
        speed = 100
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
    @IBOutlet weak var anchorSwitch: UISwitch!
    
    var periode = 10.0
    var amplitude = 10.0
    var distance = 0.3
    var radius = 1.0
    var speed = 100.0
    
    @IBOutlet weak var Picker: UIPickerView!
//    var selected = 1;
    
    
    // 0 - 3D Wave
    // 1 - 2D Standing wave
    
    @IBAction func startARButton(_ sender: Any) {
        if let per = Double(perText.text!) {
            self.periode = per
        }
        if let amp = Double(ampText.text!) {
            self.amplitude = amp
        }
        if let dis = Double(disText.text!) {
            self.distance = dis
        }
        if let rad = Double(radText.text!) {
            self.radius = rad
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
            vc.amplitudevalue = amplitude / 10
            vc.periodeValue = periode / 10
        }else if selected == 1 {
            let vc = segue.destination as! _2DStandingWaveViewController
            vc.amplitudevalue = amplitude / 10
            vc.periodeValue = periode / 50
            vc.distance = distance
            vc.radius = radius / 1000
            vc.showAnchor = anchorSwitch.isOn
            vc.timing = speed / 100
            print("Timing: " + String(vc.timing))
//            vc.timer.invalidate()
        }else if selected == 2 {
            let vc = segue.destination as! _3DStandinWaveViewController
            vc.amplitudevalue = amplitude / 10
            vc.periodeValue = periode / 50
            vc.distance = distance
            vc.radius = radius / 1000
            vc.showAnchor = anchorSwitch.isOn
            vc.timing = speed * 1.0 / 100
            print("Timing: " + String(vc.timing))
            vc.timer.invalidate()
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
