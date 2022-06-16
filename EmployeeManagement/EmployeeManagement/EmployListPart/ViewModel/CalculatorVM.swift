//
//  CalculatorVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/16.
//

import UIKit

class CalculatorVM {
    
    var weekValue: Int = 0
    
    //문자 조건
    let charSet: CharacterSet = {
        var cs = CharacterSet()
        cs.insert(charactersIn: "0123456789")
        cs.insert(charactersIn: ".")
        return cs.inverted
    }()
    
    //MARK: 세그먼트컨트롤 메소드
    //주휴수당 유무
    func changeWeekValue(sender: UISegmentedControl){
        let value = sender.selectedSegmentIndex     //0이면 유, 1이면 무
        self.weekValue = value
        print(self.weekValue)
    }
    
    //MARK: 버튼 메소드
    //물음표 버튼
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
    
    //계산 버튼
    func showMeTheMoney(moneyTF: UITextField, timeTF: UITextField, taxTF: UITextField, sevenMoney: UILabel, monthMoney: UILabel, yearMoney: UILabel, nv: UIViewController){
        if moneyTF.text?.isEmpty == false && timeTF.text?.isEmpty == false && taxTF.text?.isEmpty == false{
            //주휴 수당 O
            if self.weekValue == 0 {
                let doubleMoney = Double(moneyTF.text!)!
                let doubleTime = Double(timeTF.text!)!
                let doubleTax = Double(taxTF.text!)!
                let doubleSum = (doubleTime + (doubleTime / 5)) * doubleMoney
                let resultSum = doubleSum * (100.0 - doubleTax) / 100
                let changeInt = Int(resultSum)
                
                sevenMoney.text = "\(String(describing: changeInt))원"
                monthMoney.text = "\(String(describing: (changeInt * 4)))원"
                yearMoney.text = "\(String(describing: (changeInt * 48)))원"
            } else {        //X
                let doubleMoney = Double(moneyTF.text!)!
                let doubleTime = Double(timeTF.text!)!
                let doubleTax = Double(taxTF.text!)!
                let doubleSum = doubleTime * doubleMoney
                let resultSum = doubleSum * (100.0 - doubleTax) / 100
                let changeInt = Int(resultSum)
                
                sevenMoney.text = "\(String(describing: changeInt))원"
                monthMoney.text = "\(String(describing: (changeInt * 4)))원"
                yearMoney.text = "\(String(describing: (changeInt * 48)))원"
            }
        } else {
            let alert = UIAlertController(title: "정보를 다 입력해주세요", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                sevenMoney.text = "0원"
                monthMoney.text = "0원"
                yearMoney.text = "0원"
            })
            nv.present(alert, animated: true)
        }
    }
    
    //MARK: 텍스트 필드 메소드
    //텍스트필드 didEndEditing
    func textChange(textField: UITextField, moneyTF: UITextField, timeTF: UITextField, taxTF: UITextField, weekControl: UISegmentedControl, vc: UIViewController){
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
                if Double(timeTF.text!)! < 15 {
                    weekControl.selectedSegmentIndex = 1
                    self.weekValue = 1
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
    
    //텍스트필드에 쓸 수 있는 문자
    func textWritingCase(string: String) -> Bool{
        if string.count > 0{
            guard string.rangeOfCharacter(from: self.charSet) == nil else{
                return false
            }
        }
        return true
    }
}
