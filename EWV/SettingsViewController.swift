//
//  SettingsViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 26.04.21.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var ampValue: UISlider!
    @IBOutlet weak var perValue: UISlider!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Picker.delegate = self
        self.Picker.dataSource = self
        
        pickerData = ["3D Wave", "2D standing wave", "3", "4"]

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var ampText: UILabel!
    @IBOutlet weak var perText: UILabel!
    
    var periode = 1.0
    var amplitude = 1.0
    
    @IBAction func onAmpChange(_ sender: Any) {
        if ampValue.value != 0 {
            ampText.text = String(ampValue.value.rounded())
        }else{
            ampText.text = "0.0"
        }
    }
    
    @IBAction func onPerChange(_ sender: Any) {
        if perValue.value != 0 {
            perText.text = String(perValue.value.rounded())
        }else{
            perText.text = "0.0"
        }
    }
    
    @IBOutlet weak var Picker: UIPickerView!
    var selected = 1;
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 1 - 3D Wave
        // 2 - 2D Standing wave
            selected = row
        }
    
    @IBAction func startARButton(_ sender: Any) {
        self.periode = Double(perValue.value)
        self.amplitude = Double(ampValue.value)
        if (selected == 1){
            print("1.1")
            performSegue(withIdentifier: "3dvariables", sender: sender)
        }else if (selected == 2){
            print("1.2")
            performSegue(withIdentifier: "2dStandingWaveVariables", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selected == 1 {
            print("1")
            let vc = segue.destination as! ThreeDARViewController
            vc.amplitudevalue = amplitude
            vc.periodeValue = periode
        }else if selected == 2 {
            print("2")
            let vc = segue.destination as! _DStandingWaveViewController
            vc.amplitudevalue = amplitude
            vc.periodeValue = periode
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
