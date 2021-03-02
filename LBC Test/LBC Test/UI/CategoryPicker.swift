//
//  CategoryPicker.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

import UIKit

class CategoryPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var results: FetchResults?
    weak var selectedDelegate: SelectedRow?
    
    internal var picker = UIPickerView(frame: .zero)
    internal var clearButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Toutes categories", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return btn
    }()

    internal var confirmButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(validateCurrentCategory), for: .touchUpInside)
        return btn
    }()
    
    override func loadView() {
        view = UIView(frame: .zero)
        
        let underview = UIView(frame: .zero)
        underview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        underview.layer.cornerRadius = 5.0
        view.addSubview(underview)
        underview.setBasicConstraints(top: nil, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        
        underview.addSubview(picker)
        underview.addSubview(clearButton)
        underview.addSubview(confirmButton)
        picker.setBasicConstraints(top: underview.topAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        clearButton.setBasicConstraints(top: picker.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        confirmButton.setBasicConstraints(top: clearButton.bottomAnchor, bottom: underview.bottomAnchor, left: underview.leadingAnchor, right: underview.trailingAnchor)
    }
    
    @objc
    func showAllCategories() {
        guard let delegate = selectedDelegate else {
            return
        }
        delegate.selected(nil)
    }
    
    @objc
    func validateCurrentCategory() {
        let selected = picker.selectedRow(inComponent: 0)
        guard let delegate = selectedDelegate else {
            return
        }
        delegate.selected(selected)
    }
    
    // pickerview detail
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let res = results else {
            print("No result")
            return nil
        }
        guard let category = res.category(at: row) else {
            print("No categories")
            return nil
        }
        return category.name
    }
    
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let res = results else {
            return 0
        }
        return res.numberOfCategories
    }
}
