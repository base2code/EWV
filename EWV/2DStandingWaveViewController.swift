//
//  2DStandingWaveViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 27.04.21.
//

import UIKit

class _DStandingWaveViewController: UIViewController {
    
//    let configuration = ARWorldTrackingConfiguration()
    
    var timer = Timer()
    
    var amplitudevalue = 1.0
    var periodeValue = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()

        print(String(amplitudevalue) + " " + String(periodeValue))
        // Do any additional setup after loading the view.
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
