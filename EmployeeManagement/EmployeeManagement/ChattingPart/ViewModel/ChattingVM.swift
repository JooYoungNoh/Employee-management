//
//  ChattingVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/08/18.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ChattingVM {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: 액션 메소드
    func addChatting(uv: UIViewController){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "CreateChatVC") as? CreateChatVC else { return }
        nv.modalPresentationStyle = .fullScreen
        
        uv.present(nv, animated: true)
    }
}
