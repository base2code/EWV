//
//  SettingsViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 26.04.21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var ampValue: UISlider!
    @IBOutlet weak var perValue: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func startARButton(_ sender: Any) {
        self.periode = Double(perValue.value)
        self.amplitude = Double(ampValue.value)
        performSegue(withIdentifier: "variables", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ARViewController
        vc.amplitudevalue = amplitude
        vc.periodeValue = periode
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
