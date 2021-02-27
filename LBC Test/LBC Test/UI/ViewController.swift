//
//  ViewController.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

// TODO: Look at NSFetchedResultsController for list control

import CoreData
import UIKit

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    weak var model: Model!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.initModelData()
    }
}
