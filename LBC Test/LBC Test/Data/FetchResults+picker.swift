//
//  FetchResults+picker.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

import UIKit

extension FetchResults: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return numberOfCategories
    }
}
