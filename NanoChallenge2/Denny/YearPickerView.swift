//
//  FilmViewController.swift
//  NanoChallenge2
//
//  Created by Denny Caruso on 10/03/2019.
//  Copyright © 2019 Denny Caruso. All rights reserved.
//

import UIKit

class YearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var years: [Int]!
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 0, animated: true)
        }
    }
    
    var onDateSelected: ((_ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in (1...100) {
                years.append(year)
                year -= 1
            }
        }
        self.years = years
        self.delegate = self
        self.dataSource = self
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let year = years[self.selectedRow(inComponent: 0)]
        if let block = onDateSelected {
            block(year)
        }
        self.year = year
    }
}
