//
//  ViewController.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

import UIKit

import CoreData

class MainViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    weak var model: Model!
    weak var resultController: NSFetchedResultsController<Classified>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {}

    // MARK: Collection View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = resultController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassifiedReuseIdentifier, for: indexPath) as! MainCellView
        return cell
    }

    // MARK: FetchedResultControllerDelegation

    var objectChange: [NSFetchedResultsChangeType: Any]!

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            print("Unsupported")
        @unknown default:
            print("Unsupported")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
