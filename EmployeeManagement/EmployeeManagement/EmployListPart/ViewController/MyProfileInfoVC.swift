//
//  MyProfileInfoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/09.
//

import UIKit

class MyProfileInfoVC: UIViewController {
    
    var nameOnTable: String = ""        //전 화면 셀에 있는 이름
    var commentOnTable: String = ""     //전 회면 셀에 있는 코멘트
    var imageOnTable: UIImage!          //전 화면 셀에 있는 사진

    override func viewDidLoad() {
        super.viewDidLoad()

        print(nameOnTable)
        print(commentOnTable)
        print(imageOnTable!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
