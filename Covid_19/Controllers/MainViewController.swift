//
//  MainViewController.swift
//  Covid_19
//
//  Created by 최제환 on 2021/09/16.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var vaccinationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vaccinationBtn.layer.cornerRadius = 14.0
    }
    
    @IBAction func goToVaccinationCenterVC(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "VaccinationCenterViewController") as? VaccinationCenterViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
