//
//  SplitViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class SplitViewController: UISplitViewController {
    var model: Model!

    override func viewDidLoad() {
        super.viewDidLoad()
        let primary = PrimaryViewController()
        let secondary = SecondaryViewController()
        viewControllers = [primary, secondary]
        model = Model(primary: primary, secondary: secondary)
        // Do any additional setup after loading the view.

        model.initModelData {
            DispatchQueue.main.async {
                primary.reloadData()
            }
        }
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
