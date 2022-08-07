//
//  NoticeListVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/07.
//

import FirebaseFirestore

class NoticeListVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func noAldaButton(uv: UIViewController){
        if self.appDelegate.jobInfo == "2"{
            let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            uv.present(alert, animated: true)
        }
    }
    
    //MARK: 테이블 뷰 메소드
    func cellInfo(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell", for: indexPath) as? NoticeListCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = "실험중"
        cell.dateLabel.text = "2020-08-08\n 03:30"
        return cell
    }
}
