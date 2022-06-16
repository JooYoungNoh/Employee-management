//
//  CalculatorVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/16.
//

import UIKit

class CalculatorVM {
    
    var weekValue: Int = 0
    
    let charSet: CharacterSet = {
        var cs = CharacterSet()
        cs.insert(charactersIn: "0123456789")
        cs.insert(charactersIn: ".")
        return cs.inverted
    }()
    
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
    
    func textChange(textField: UITextField, moneyTF: UITextField, timeTF: UITextField, taxTF: UITextField, vc: UIViewController){
        switch textField{
        case moneyTF:
            if moneyTF.text?.isEmpty == false {
                if Int(moneyTF.text!)! < 9160 {
                    let alert = UIAlertController(title: "최저시급에 충족하지 않습니다", message: "다시 입력해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        moneyTF.text = nil
                    })
                    vc.present(alert, animated: true)
                }
            }
        case timeTF:
            if timeTF.text?.isEmpty == false {
                if Double(timeTF.text!)! > 40.0 {
                    let alert = UIAlertController(title: "근로기준법에 기준된 시간을 초과하였습니다", message: "다시 입력해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        timeTF.text = nil
                    })
                    vc.present(alert, animated: true)
                }
                if timeTF.text!.count > 4 {
                    let alert = UIAlertController(title: "소수점 최대 한자리까지입니다.", message: "다시 입력해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        timeTF.text = nil
                    })
                    vc.present(alert, animated: true)
                }
            }
        case taxTF:
            if taxTF.text?.isEmpty == false{
                if Double(taxTF.text!)! > 100.0 {
                    let alert = UIAlertController(title: "최대 허용범위를 넘었습니다.", message: "다시 입력해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        taxTF.text = nil
                    })
                    vc.present(alert, animated: true)
                }
                if taxTF.text!.count > 5 {
                    let alert = UIAlertController(title: "소수점 최대 두자리까지입니다.", message: "다시 입력해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                        taxTF.text = nil
                    })
                    vc.present(alert, animated: true)
                }
            }
        default:
            break
        }
    }
    
    func textWritingCase(string: String) -> Bool{
        if string.count > 0{
            guard string.rangeOfCharacter(from: self.charSet) == nil else{
                return false
            }
        }
        return true
    }
}
