//
//  ViewController.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

import UIKit

class PrimaryViewController: UITableViewController, PrimaryCVController {
    var results: FetchResults? { didSet {
        results?.delegate = self
    }}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(MainCellView.self, forCellReuseIdentifier: ClassifiedReuseIdentifier)
    }

    // MARK: Collection View

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let res = results else { return 0 }
        return res.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassifiedReuseIdentifier, for: indexPath) as! MainCellView
        cell.ad = results!.object(at: indexPath)

        return cell
    }

    // MARK: Updates from the Data stack

    func beginUpdate() {
        tableView.beginUpdates()
    }

    func change(change c: FetchChange, wasAt oldIndex: IndexPath?, nowAt newIndex: IndexPath?) {
        switch c {
        case .delete:
            tableView.deleteRows(at: [oldIndex!], with: .right)
        case .insert:
            tableView.insertRows(at: [newIndex!], with: .left)
        case .move:
            tableView.moveRow(at: oldIndex!, to: newIndex!)
        }
    }

    func endUpdate() {
        tableView.endUpdates()
    }
}
