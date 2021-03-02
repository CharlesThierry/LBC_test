//
//  FetchResults+picker.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

import UIKit

extension FetchResults: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numberOfCategories
    }
    
    
}
