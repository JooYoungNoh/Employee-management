//
//  SelectVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/11.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class SelectVM{
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storage = Storage.storage()
    
    //레시피
    var recipeList: [SelectModel] = []
    var realRecipeList: [SelectModel] = []
    var searchRecipeList: [SelectModel] = []
    
    //인수인계
    var transitionList: [SelectModel] = []
    var realTransitionList: [SelectModel] = []
    var searchTransitionList: [SelectModel] = []
    
    //중복여부 체크 리스트 (메모 작성때 쓸)
    var checkList: [String] = []
    
    //회사 삭제시 작성 금지 (회사 삭제 했는데 다른 사람이 작성 화면에 있을 경우 작성 금지을 위한 객체)
    var companyDelete: String = ""
    
    //MARK: 레시피 부분 메소드
    func findRecipe(naviTitle: String, completion: @escaping([SelectModel]) -> ()){
        self.recipeList.removeAll()
        self.realRecipeList.removeAll()
        self.searchRecipeList.removeAll()
        self.db.collection("shop").document("\(naviTitle)").collection("recipe").getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.recipeList.append(SelectModel.init(text: doc.data()["text"] as! String, date: doc.data()["date"] as! TimeInterval, count: doc.data()["count"] as! String, title: doc.data()["title"] as! String, imageList: doc.data()["imageList"] as! [String]))
                }
                self.realRecipeList = self.recipeList.sorted(by: {$0.date > $1.date})
                completion(self.realRecipeList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //MARK: 인수인계 부분 메소드
    func findTransition(naviTitle: String, completion: @escaping([SelectModel]) -> ()){
        self.transitionList.removeAll()
        self.realTransitionList.removeAll()
        self.searchTransitionList.removeAll()
        self.db.collection("shop").document("\(naviTitle)").collection("transition").getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.transitionList.append(SelectModel.init(text: doc.data()["text"] as! String, date: doc.data()["date"] as! TimeInterval, count: doc.data()["count"] as! String, title: doc.data()["title"] as! String, imageList: doc.data()["imageList"] as! [String]))
                }
                self.realTransitionList = self.transitionList.sorted(by: {$0.date > $1.date})
                completion(self.realTransitionList)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    //MARK: 검색기능
    func searchBarfilter(searchController: UISearchController, tableView: UITableView){
        guard let text = searchController.searchBar.text else { return }

        self.searchRecipeList = self.realRecipeList.filter( { (list: SelectModel) -> Bool in
            return list.title.lowercased().contains(text.lowercased())
        })
        
        self.searchTransitionList = self.realTransitionList.filter( { (list: SelectModel) -> Bool in
            return list.title.lowercased().contains(text.lowercased())
        })
        
        tableView.reloadData()
    }
    
    //MARK: 삭제 기능
    func deleteMemo(uv: UIViewController,tableView: UITableView, forRowAt indexPath: IndexPath, naviTitle: String, isFiltering: Bool) {
       // let cell  = tableView.cellForRow(at: indexPath) as! SelectCell
        
        if self.appDelegate.jobInfo == "2"{
            let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            uv.present(alert, animated: true)
        } else {
            if isFiltering == false {
                if indexPath.section == 0{
                    self.db.collection("shop").document("\(naviTitle)").collection("recipe").document("\(realRecipeList[indexPath.row].title)").delete()
                    
                    self.deleteImage(titleOnTable: self.realRecipeList[indexPath.row].title, companyName: naviTitle, imageListOnTable: self.realRecipeList[indexPath.row].imageList)
                    
                    self.realRecipeList.remove(at: indexPath.row)
                    if self.realRecipeList.isEmpty == true {
                        let cell = tableView.cellForRow(at: indexPath) as! SelectCell
                        cell.accessoryType = .none
                        cell.titleLabel.text = "레시피가 없습니다"
                        cell.titleLabel.textColor = .red
                        cell.dateLabel.text = ""
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    self.db.collection("shop").document("\(naviTitle)").collection("transition").document("\(realTransitionList[indexPath.row].title)").delete()
                    
                    self.deleteImage(titleOnTable: self.realTransitionList[indexPath.row].title, companyName: naviTitle, imageListOnTable: self.realTransitionList[indexPath.row].imageList)
                    
                    self.realTransitionList.remove(at: indexPath.row)
                    if self.realTransitionList.isEmpty == true {
                        let cell = tableView.cellForRow(at: indexPath) as! SelectCell
                        cell.accessoryType = .none
                        cell.titleLabel.text = "인수인계가 없습니다"
                        cell.titleLabel.textColor = .red
                        cell.dateLabel.text = ""
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }
            } else {
                if indexPath.section == 0{
                    self.db.collection("shop").document("\(naviTitle)").collection("recipe").document("\(searchRecipeList[indexPath.row].title)").delete()
                    
                    self.deleteImage(titleOnTable: self.searchRecipeList[indexPath.row].title, companyName: naviTitle, imageListOnTable: self.searchRecipeList[indexPath.row].imageList)
                    
                    self.realRecipeList.remove(at: self.realRecipeList.firstIndex(where: { list in
                        return list.title.contains(self.searchRecipeList[indexPath.row].title)
                    })!)
                    self.searchRecipeList.remove(at: indexPath.row)
                    if self.searchRecipeList.isEmpty == true {
                        let cell = tableView.cellForRow(at: indexPath) as! SelectCell
                        cell.accessoryType = .none
                        cell.titleLabel.text = "검색 결과가 없습니다"
                        cell.titleLabel.textColor = .red
                        cell.dateLabel.text = ""
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                } else {
                    self.db.collection("shop").document("\(naviTitle)").collection("transition").document("\(searchTransitionList[indexPath.row].title)").delete()
                    
                    self.deleteImage(titleOnTable: self.searchTransitionList[indexPath.row].title, companyName: naviTitle, imageListOnTable: self.searchTransitionList[indexPath.row].imageList)
                    
                    self.realTransitionList.remove(at: self.realTransitionList.firstIndex(where: { list in
                        return list.title.contains(self.searchTransitionList[indexPath.row].title)
                    })!)
                   
                    self.searchTransitionList.remove(at: indexPath.row)
                    if self.searchTransitionList.isEmpty == true {
                        let cell = tableView.cellForRow(at: indexPath) as! SelectCell
                        cell.accessoryType = .none
                        cell.titleLabel.text = "검색 결과가 없습니다"
                        cell.titleLabel.textColor = .red
                        cell.dateLabel.text = ""
                    } else {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }
            }
        }
    }
    
    //MARK: 액션 메소드
    //레시피 및 인수인계 추가
    func doAdd(uv: UIViewController, companyName: String) {
        self.companyDelete = ""
        self.db.collection("shop").whereField("company", isEqualTo: "\(companyName)").getDocuments { snapShot, error in
            for doc in snapShot!.documents{
                self.companyDelete = doc.documentID
            }
            print(self.companyDelete)
            if self.companyDelete == "" {
                let alert = UIAlertController(title: "회사가 존재하지않습니다.", message: "확인해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
                    uv.navigationController?.popViewController(animated: true)
                })
                uv.present(alert, animated: true)
            } else {
                if self.appDelegate.jobInfo == "2" {
                    let alert = UIAlertController(title: nil, message: "직원 이상의 직책만 사용가능합니다", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    uv.present(alert, animated: true)
                    
                } else {
                    self.checkList.removeAll()
                    for i in 0..<self.realRecipeList.count{
                        self.checkList.append(self.realRecipeList[i].title)
                    }
                    
                    for i in 0..<self.realTransitionList.count{
                        self.checkList.append(self.realTransitionList[i].title)
                    }
                    
                    let alert = UIAlertController(title: "선택해주세요", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "레시피 작성", style: .default) { (_) in
                        let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TransitionWriteVC") as! TransitionWriteVC
                        nv.modalPresentationStyle = .fullScreen
                        nv.naviTitle = "레시피 작성"
                        nv.companyName = companyName
                        nv.checkTitle = self.checkList
                        uv.present(nv, animated: true)
                    })
                    alert.addAction(UIAlertAction(title: "인수인계 작성", style: .default){ (_) in
                        let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TransitionWriteVC") as! TransitionWriteVC
                        nv.modalPresentationStyle = .fullScreen
                        nv.naviTitle = "인수인계 작성"
                        nv.companyName = companyName
                        nv.checkTitle = self.checkList
                        uv.present(nv, animated: true)
                    })
                    alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                    
                    uv.present(alert, animated: true)
                }
            }
        }
        
    }

    //이미지 삭제
    func deleteImage(titleOnTable: String, companyName: String, imageListOnTable: [String]) {
        for i in imageListOnTable {
            storage.reference(forURL: "gs://employeemanagement-9d6eb.appspot.com/\(companyName)/\(titleOnTable)/\(i)").delete { (error) in
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    print("이미지 삭제 성공")
                }
            }
        }
    }
    
    
    //MARK: 테이블 뷰 셀 정보
    func tableCellInfo(indexPath: IndexPath, tableView: UITableView, isFiltering: Bool) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectCell.identifier, for: indexPath) as? SelectCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0{
            if isFiltering == false {           //검색 X
                if self.realRecipeList.isEmpty == true {
                    cell.accessoryType = .none
                    cell.titleLabel.text = "레시피가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = ""
                } else {
                    let date = Date(timeIntervalSince1970: self.realRecipeList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                    
                    cell.titleLabel.text = self.realRecipeList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                    cell.accessoryType = .disclosureIndicator
                }
            } else {                            //검색 O
                if self.searchRecipeList.isEmpty == true {
                    cell.accessoryType = .none
                    cell.titleLabel.text = "검색 결과가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = ""
                } else {
                    let date = Date(timeIntervalSince1970: self.searchRecipeList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                    
                    cell.titleLabel.text = self.searchRecipeList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                    cell.accessoryType = .disclosureIndicator
                }
            }
        } else {
            if isFiltering == false {
                if self.realTransitionList.isEmpty == true {
                    cell.accessoryType = .none
                    cell.titleLabel.text = "인수인계가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = ""
                } else {
                    let date = Date(timeIntervalSince1970: self.realTransitionList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                        
                    cell.titleLabel.text = self.realTransitionList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                    cell.accessoryType = .disclosureIndicator
                }
            } else {
                if self.searchTransitionList.isEmpty == true {
                    cell.accessoryType = .none
                    cell.titleLabel.text = "검색 결과가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = ""
                } else {
                    let date = Date(timeIntervalSince1970: self.searchTransitionList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                    
                    cell.titleLabel.text = self.searchTransitionList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                    cell.accessoryType = .disclosureIndicator
                }
            }
        }
        return cell
    }
    
    //MARK: 테이블 뷰 섹션에 나타낼 로우 갯수
    func numberOfRowsInSection(section: Int, isFiltering: Bool) -> Int {
        if section == 0{
            if isFiltering == true {
                return self.searchRecipeList.isEmpty ? 1 : self.searchRecipeList.count
            } else {
                return self.realRecipeList.isEmpty ? 1 : self.realRecipeList.count
            }
        } else {
            if isFiltering == true {
                return self.searchTransitionList.isEmpty ? 1 : self.searchTransitionList.count
            } else {
                return self.realTransitionList.isEmpty ? 1 : self.realTransitionList.count
            }
        }
    }
    
    func selectCell(uv: UIViewController, isFiltering: Bool, indexPath: IndexPath, companyName: String){
        guard let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TransitionInfoVC") as? TransitionInfoVC else { return }

        if isFiltering == false {
            if indexPath.section == 0 {
                if self.realRecipeList.isEmpty == false {
                    nv.titleOnTable = self.realRecipeList[indexPath.row].title
                    nv.textOnTable = self.realRecipeList[indexPath.row].text
                    nv.countOnTable = self.realRecipeList[indexPath.row].count
                    nv.naviTitle = "레시피 정보"
                    nv.companyName = companyName
                    nv.checkTitle = self.checkList
                    nv.imageListOnTable = self.realRecipeList[indexPath.row].imageList
                    uv.navigationController?.pushViewController(nv, animated: true)
                }
            } else {
                if self.realTransitionList.isEmpty == false {
                    nv.titleOnTable = self.realTransitionList[indexPath.row].title
                    nv.textOnTable = self.realTransitionList[indexPath.row].text
                    nv.countOnTable = self.realTransitionList[indexPath.row].count
                    nv.naviTitle = "인수인계 정보"
                    nv.companyName = companyName
                    nv.checkTitle = self.checkList
                    nv.imageListOnTable = self.realTransitionList[indexPath.row].imageList
                    uv.navigationController?.pushViewController(nv, animated: true)
                }
            }
        } else {
            if indexPath.section == 0 {
                if self.searchRecipeList.isEmpty == false {
                    nv.titleOnTable = self.searchRecipeList[indexPath.row].title
                    nv.textOnTable = self.searchRecipeList[indexPath.row].text
                    nv.countOnTable = self.searchRecipeList[indexPath.row].count
                    nv.naviTitle = "레시피 정보"
                    nv.companyName = companyName
                    nv.checkTitle = self.checkList
                    nv.imageListOnTable = self.searchRecipeList[indexPath.row].imageList
                    uv.navigationController?.pushViewController(nv, animated: true)
                }
            } else {
                if self.searchTransitionList.isEmpty == false {
                    nv.titleOnTable = self.searchTransitionList[indexPath.row].title
                    nv.textOnTable = self.searchTransitionList[indexPath.row].text
                    nv.countOnTable = self.searchTransitionList[indexPath.row].count
                    nv.naviTitle = "인수인계 정보"
                    nv.companyName = companyName
                    nv.checkTitle = self.checkList
                    nv.imageListOnTable = self.searchTransitionList[indexPath.row].imageList
                    uv.navigationController?.pushViewController(nv, animated: true)
                }
            }
        }
    }
}

