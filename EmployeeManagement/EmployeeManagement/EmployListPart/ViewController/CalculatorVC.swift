//
//  CalculatorVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/16.
//

import UIKit
import SnapKit

class CalculatorVC: UIViewController {
    
    var viewModel = CalculatorVM()
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    
    //시급 레이블
    let moneyLabel: UILabel = {
        let label = UILabel()
        label.text = "시급"
        label.textColor = .systemBlue
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    //시급 텍스트 필드
    let moneyTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "1시간동안 받는 돈"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        text.keyboardType = .numberPad
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    //시급 단위 레이블
    let wonLabel: UILabel = {
        let label = UILabel()
        label.text = "원"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    //시간 레이블
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = .systemBrown
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    //시간 텍스트 필드
    let timeTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "1주동안 일한 시간"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        //text.keyboardType = .phonePad
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    //시간 단위 레이블
    let siganLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    //세금 레이블
    let taxLabel: UILabel = {
        let label = UILabel()
        label.text = "세금"
        label.textColor = .systemRed
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    //세금 텍스트 필드
    let taxTF: UITextField = {
        let text = UITextField()
        text.backgroundColor = .systemGray6
        text.placeholder = "세금 퍼센트"
        text.textColor = .black
        text.textAlignment = .center
        text.font = UIFont(name: "CookieRun", size: 18)
        //text.keyboardType = .phonePad
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.layer.borderWidth = 0
        return text
    }()
    //세금 단위 레이블
    let persentLabel: UILabel = {
        let label = UILabel()
        label.text = "%"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .left
        label.backgroundColor = .white
        return label
    }()
    
    //주휴수당 레이블
    let weekLabel: UILabel = {
        let label = UILabel()
        label.text = "주휴수당 유무"
        label.textColor = .systemTeal
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    //주휴수당 세그먼트 컨트롤
    let weekControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["O","X"])
        control.selectedSegmentIndex = 1
        return control
    }()
    
    //계산 버튼
    let calButton: UIButton = {
        let button = UIButton()
        button.setTitle("계산", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "CookieRun", size: 18)
        button.alpha = 0.7
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    //경계선 뷰
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    
    //월급 레이블
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "월급"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    //월급 돈 레이블
    let monthMoney: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 0
        return label
    }()
    //월급 설명 레이블
    let monthInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "주당 같은 시간을 했을 때"
        label.textColor = .systemRed
        label.font = UIFont(name: "CookieRun", size: 11)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    //월급 설명 버튼
    let monthButton: UIButton = {
        let button = UIButton()
        button.setTitle("?", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "CookieRun", size: 18)
        button.alpha = 0.7
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    //경계선 뷰
    let leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    //주급 레이블
    let sevenLabel: UILabel = {
        let label = UILabel()
        label.text = "주급"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    //주급 돈 레이블
    let sevenMoney: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //연봉 레이블
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "연봉"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 25)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    //연봉 돈 레이블
    let yearMoney: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 0
        return label
    }()
    //연봉 설명 레이블
    let yearInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "월당 같은 시간을 했을 때"
        label.textColor = .systemRed
        label.font = UIFont(name: "CookieRun", size: 11)
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    //연봉 설명 버튼
    let yearButton: UIButton = {
        let button = UIButton()
        button.setTitle("?", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "CookieRun", size: 18)
        button.alpha = 0.7
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        uiCreate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @objc func changWeek(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            if self.timeTF.text!.isEmpty == false && Double(self.timeTF.text!)! >= 15{
                self.viewModel.changeWeekValue(sender: sender)
            } else {
                let alert = UIAlertController(title: nil, message: "시간이 입력되지 않았거나 기준에 맞지 않습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                    sender.selectedSegmentIndex = 1
                })
                self.present(alert, animated: true)
            }
        } else {
            self.viewModel.changeWeekValue(sender: sender)
        }
    }
    
    @objc func doCal(_ sender: UIButton){
        
    }
    
    @objc func doQusetion(_ sender: UIButton){
        self.viewModel.showInfo(sender: sender, monthButton: self.monthButton, sevenInfoLabel: self.monthInfoLabel, yearButton: self.yearButton, yearInfoLabel: self.yearInfoLabel)
    }
    
    //MARK: uiCreate
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //시급 부분 UI
        self.view.addSubview(moneyLabel)
        
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.closeButton.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        self.view.addSubview(moneyTF)
        
        moneyTF.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.moneyLabel.snp.bottom).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        self.view.addSubview(wonLabel)
        
        wonLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.moneyTF.snp.trailing).offset(5)
            make.top.equalTo(self.moneyTF.snp.top)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        //시간 부분 UI
        self.view.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.moneyTF.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        self.view.addSubview(timeTF)
        
        timeTF.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        self.view.addSubview(siganLabel)
        
        siganLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.timeTF.snp.trailing).offset(5)
            make.top.equalTo(self.timeTF.snp.top)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        //세금 부분 UI
        self.view.addSubview(taxLabel)
        
        taxLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.timeTF.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        self.view.addSubview(taxTF)
        
        taxTF.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.taxLabel.snp.bottom).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        self.view.addSubview(persentLabel)
        
        persentLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.taxTF.snp.trailing).offset(5)
            make.top.equalTo(self.taxTF.snp.top)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        //주휴수당 부분 UI
        self.view.addSubview(weekLabel)
        
        weekLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.taxTF.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        self.weekControl.addTarget(self, action: #selector(changWeek(_:)), for: .valueChanged)
        self.view.addSubview(weekControl)
        
        weekControl.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.weekLabel.snp.bottom).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        //계산 버튼 UI
        self.calButton.addTarget(self, action: #selector(doCal(_:)), for: .touchUpInside)
        self.view.addSubview(calButton)
        
        calButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.weekControl.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        //경계선 뷰 UI
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.calButton.snp.bottom).offset(30)
            make.height.equalTo(3)
        }
        
        //월급 UI
        self.view.addSubview(monthInfoLabel)
        monthInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.lineView.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        self.view.addSubview(monthLabel)
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.monthInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        self.view.addSubview(monthMoney)
        
        monthMoney.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.monthLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        self.monthButton.addTarget(self, action: #selector(doQusetion(_:)), for: .touchUpInside)
        self.view.addSubview(monthButton)
        monthButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.monthMoney.snp.bottom).offset(20)
            make.width.height.equalTo(30)
        }
        
        //경계선 UI
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
        leftView.snp.makeConstraints { make in
            make.trailing.equalTo(self.monthMoney.snp.leading).offset(-15)
            make.top.equalTo(self.lineView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(3)
        }
        rightView.snp.makeConstraints { make in
            make.leading.equalTo(self.monthMoney.snp.trailing).offset(15)
            make.top.equalTo(self.lineView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(3)
        }
        
        //주급 UI
        self.view.addSubview(sevenLabel)
        sevenLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.leftView.snp.leading).offset(-15)
            make.top.equalTo(self.lineView.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(sevenMoney)
        sevenMoney.snp.makeConstraints { make in
            make.trailing.equalTo(self.leftView.snp.leading).offset(-15)
            make.top.equalTo(self.sevenLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        //연봉 UI
        self.view.addSubview(yearInfoLabel)
        yearInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.rightView.snp.trailing).offset(15)
            make.top.equalTo(self.lineView.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.rightView.snp.trailing).offset(15)
            make.top.equalTo(self.yearInfoLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(yearMoney)
        yearMoney.snp.makeConstraints { make in
            make.leading.equalTo(self.rightView.snp.trailing).offset(15)
            make.top.equalTo(self.yearLabel.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        self.yearButton.addTarget(self, action: #selector(doQusetion(_:)), for: .touchUpInside)
        self.view.addSubview(yearButton)
        yearButton.snp.makeConstraints { make in
            make.top.equalTo(self.yearMoney.snp.bottom).offset(20)
            make.leading.equalTo(self.rightView.snp.trailing).offset(50)
            make.width.height.equalTo(30)
        }
        
    }

    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
