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
    @IBOutlet weak var disValue: UISlider!
    @IBOutlet weak var radValue: UISlider!
    
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
    @IBOutlet weak var disText: UILabel!
    @IBOutlet weak var radText: UILabel!
    
    var periode = 1.0
    var amplitude = 1.0
    var distance = 0.3
    var radius = 0.001
    
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
    
    @IBAction func onDisChange(_ sender: Any) {
        if disValue.value != 0 {
            disText.text = String(disValue.value)
        }else{
            disText.text = "0.0"
        }
    }
    
    @IBAction func onRadChange(_ sender: Any) {
        if radValue.value != 0 {
            radText.text = String(radValue.value)
        }else{
            radText.text = "0.000"
        }
    }
    
    
    @IBOutlet weak var Picker: UIPickerView!
//    var selected = 1;
    
    
    // 0 - 3D Wave
    // 1 - 2D Standing wave
    
    @IBAction func startARButton(_ sender: Any) {
        self.periode = Double(perValue.value)
        self.amplitude = Double(ampValue.value)
        self.distance = Double(disValue.value)
        self.radius = Double(radValue.value)
        
        let selected = Picker.selectedRow(inComponent: 0)
        if (selected == 0){
            performSegue(withIdentifier: "3dvariables", sender: sender)
        }else if (selected == 1){
            performSegue(withIdentifier: "2dStandingWaveVariables", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = Picker.selectedRow(inComponent: 0)
        if selected == 0 {
            let vc = segue.destination as! ThreeDARViewController
            vc.amplitudevalue = amplitude / 10
            vc.periodeValue = periode / 10
        }else if selected == 1 {
            let vc = segue.destination as! _DStandingWaveViewController
            vc.amplitudevalue = amplitude * 1.0
            print(String(amplitude) + " " + String(amplitude * 1.0 / 100))
            vc.periodeValue = periode * 1.0 / 10
            vc.distance = distance
            vc.radius = radius
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
