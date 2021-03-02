//
//  CategoryPicker.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

import UIKit

class CategoryPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var results: FetchResults?
    
    internal var picker = UIPickerView(frame: .zero)
    internal var button : UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Toutes categories", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        return btn
    }()
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        view.addSubview(picker)
        view.addSubview(button)
        
        picker.bottomAnchor.constraint(equalTo: button.topAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        results?.setCategoryFilter(categoryID: results?.category(at: row)?.id)
    }
}
