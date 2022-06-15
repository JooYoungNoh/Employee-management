//
//  CalculatorVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/16.
//

import UIKit

class CalculatorVM {
    
    var weekValue: Int = 0
    
    //주휴수당 유무
    func changeWeekValue(sender: UISegmentedControl){
        let value = sender.selectedSegmentIndex     //0이면 유, 1이면 무
        self.weekValue = value
        print(self.weekValue)
    }
    
    func showInfo(sender: UIButton, monthButton: UIButton, sevenInfoLabel: UILabel, yearButton: UIButton, yearInfoLabel: UILabel){
        switch sender{
        case monthButton:
            if monthButton.titleLabel?.text == "?" {
                sevenInfoLabel.isHidden = false
                monthButton.setTitle("!", for: .normal)
            } else {
                sevenInfoLabel.isHidden = true
                monthButton.setTitle("?", for: .normal)
            }
        case yearButton:
            if yearButton.titleLabel?.text == "?" {
                yearInfoLabel.isHidden = false
                yearButton.setTitle("!", for: .normal)
            } else {
                yearInfoLabel.isHidden = true
                yearButton.setTitle("?", for: .normal)
            }
        default:
            break
        }
    }
}
