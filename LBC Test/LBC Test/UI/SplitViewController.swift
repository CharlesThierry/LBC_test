//
//  SplitViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class SplitViewController: UISplitViewController {
    var model: Model!
    weak var primary: PrimaryViewController!
    weak var secondary: SecondaryViewController!

    func initSubControllers() {
        let tPrimary = PrimaryViewController()
        primary = tPrimary
        let tSecondary = SecondaryViewController()
        secondary = tSecondary
        viewControllers = [UINavigationController(rootViewController: tPrimary),
                           UINavigationController(rootViewController: tSecondary)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model = Model(primary: primary!,
                      secondary: secondary!)
        // Do any additional setup after loading the view.

        model.initModelData {}
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
