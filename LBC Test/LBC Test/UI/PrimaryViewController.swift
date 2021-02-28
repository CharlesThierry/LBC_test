//
//  ViewController.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

import UIKit

import CoreData

class PrimaryViewController: UITableViewController, NSFetchedResultsControllerDelegate, PrimaryCVController {
    var resultController: NSFetchedResultsController<Entry>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(MainCellView.self, forCellReuseIdentifier: ClassifiedReuseIdentifier)
    }

    // MARK: Collection View

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = resultController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassifiedReuseIdentifier, for: indexPath) as! MainCellView
        cell.ad = resultController.object(at: indexPath)
        return cell
    }

    // MARK: FetchedResultControllerDelegation

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .left)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .left)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            print("Unsupported")
        @unknown default:
            print("Unsupported")
        }
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
