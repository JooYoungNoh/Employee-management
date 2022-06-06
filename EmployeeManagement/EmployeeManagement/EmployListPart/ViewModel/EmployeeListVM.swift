//
//  EmployeeListVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/03.
//

import UIKit
import FirebaseFirestore
import SystemConfiguration

class EmployeeListVM {
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myCompany: [String] = []
    var employeeList: [EmployeeModel] = []
    var employeeResult: [EmployeeModel] = []
    var employeePhoneList: [String] = []
    var employeePhoneResult: [String] = []
    
    //내가 속한 회사 정보 불러오기
    func findCompany(completion: @escaping([String]) ->() ){
        self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("myCompany").getDocuments { (snapshot, error) in
            //회사 이름 배열 초기화
            self.myCompany.removeAll()
            //DB에서 정보 가져오기
            for doc in snapshot!.documents{
                self.myCompany.append(doc.documentID)
            }
            completion(self.myCompany)  // == return
        }
    }
    
    //내가 속한 회사 직원 리스트 불러오기
    func findEmployList(completion2: @escaping([EmployeeModel]) -> () ){
        self.findCompany{ completion in
            for i in completion {
                self.db.collection("shop").document("\(i)").collection("employeeControl").getDocuments{ snapshot2, error in
                    //구조체 배열들 초기화
                    self.employeeList.removeAll()
                    self.employeeResult.removeAll()
                    //"phone" 배열들 초기화
                    self.employeePhoneList.removeAll()
                    self.employeePhoneResult.removeAll()
                    
                    //DB에서 정보 가져오기
                    for doc2 in snapshot2!.documents{
                        self.employeeList.append( EmployeeModel.init(name: doc2.data()["name"] as! String, phone: doc2.data()["phone"] as! String, comment: doc2.data()["comment"] as! String))
                        self.employeePhoneList.append(doc2.data()["phone"] as! String)
                    }
                    //MARK: 중복 제거
                    //DB에서 받아온 "phone" 배열 Set로 중복 값 제거
                    let setArray = Set(self.employeePhoneList)
                    //중복 값 제거한 Set를 다시 배열로
                    self.employeePhoneResult = Array(setArray)
                    //배열 정렬(전화번호로 해서 이름순으로 안됨)(이름순으로 하고 싶지만 동명이인 삭제됨)
                    self.employeePhoneResult.sort()
                    
                    //배열 순회
                    for del in self.employeePhoneResult{
                        //employeeList(이름,전화번호,코멘트로 이루어진 구조체 배열) 에서 del의 번호를 가진 배열의 인덱스 추출
                        guard let index = self.employeeList.firstIndex(where: {$0.phone == del}) else { return }
                        
                        //같은 구조체 타입의 새로운 배열에 인덱스 값 넣기
                        self.employeeResult.append(self.employeeList[index])
                    }
                    //내 정보 지우기(직원리스트)
                    self.employeeResult.removeAll(where: {$0.phone == "\(self.appDelegate.phoneInfo!)"})
    
                    completion2(self.employeeResult)    // == return
                }
            }
        }
    }
    
    //테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection(section: Int) -> Int {
        return self.employeeResult.count
    }
    
}
