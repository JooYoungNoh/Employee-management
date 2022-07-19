//
//  SelectVM.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/11.
//

import Foundation
import FirebaseFirestore

class SelectVM{
    
    let db = Firestore.firestore()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //레시피
    var recipeList: [SelectModel] = []
    var realRecipeList: [SelectModel] = []
    var searchRecipeList: [SelectModel] = []
    
    //인수인계
    var transitionList: [SelectModel] = []
    var realTransitionList: [SelectModel] = []
    var searchTransitionList: [SelectModel] = []
    
    //MARK: 레시피 부분 메소드
    func findRecipe(naviTitle: String, completion: @escaping([SelectModel]) -> ()){
        self.recipeList.removeAll()
        self.realRecipeList.removeAll()
        self.searchRecipeList.removeAll()
        self.db.collection("shop").document("\(naviTitle)").collection("recipe").getDocuments { snapShot, error in
            if error == nil {
                for doc in snapShot!.documents{
                    self.recipeList.append(SelectModel.init(text: doc.data()["text"] as! String, date: doc.data()["date"] as! TimeInterval, count: doc.data()["count"] as! String, title: doc.data()["title"] as! String, imageCount: doc.data()["imageCount"] as! String))
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
                    self.transitionList.append(SelectModel.init(text: doc.data()["text"] as! String, date: doc.data()["date"] as! TimeInterval, count: doc.data()["count"] as! String, title: doc.data()["title"] as! String, imageCount: doc.data()["imageCount"] as! String))
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
    
    //MARK: 테이블 뷰 셀 정보
    func tableCellInfo(indexPath: IndexPath, tableView: UITableView, isFiltering: Bool) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectCell.identifier, for: indexPath) as? SelectCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 0{
            if isFiltering == false {           //검색 X
                if self.realRecipeList.isEmpty == true {
                    cell.titleLabel.text = "정보가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = " "
                } else {
                    let date = Date(timeIntervalSince1970: self.realRecipeList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                        
                    cell.titleLabel.text = self.realRecipeList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                }
            } else {                            //검색 O
                if self.searchRecipeList.isEmpty == true {
                    cell.titleLabel.text = "정보가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = " "
                } else {
                    let date = Date(timeIntervalSince1970: self.searchRecipeList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                    
                    cell.titleLabel.text = self.searchRecipeList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                }
            }
        } else {
            if isFiltering == false {
                if self.realTransitionList.isEmpty == true {
                    cell.titleLabel.text = "정보가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = " "
                } else {
                    let date = Date(timeIntervalSince1970: self.realTransitionList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                        
                    cell.titleLabel.text = self.realTransitionList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
                }
            } else {
                if self.searchTransitionList.isEmpty == true {
                    cell.titleLabel.text = "정보가 없습니다"
                    cell.titleLabel.textColor = .red
                    cell.dateLabel.text = " "
                } else {
                    let date = Date(timeIntervalSince1970: self.searchTransitionList[indexPath.row].date)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let fixDate = "\(formatter.string(from: date))"
                    
                    cell.titleLabel.text = self.searchTransitionList[indexPath.row].title
                    cell.titleLabel.textColor = .black
                    cell.dateLabel.text = fixDate
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
    
    //MARK: 액션 메소드 (레시피 및 인수인계 추가)
    func doAdd(uv: UIViewController) {
        let alert = UIAlertController(title: "선택해주세요", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "레시피 작성", style: .default) { (_) in
            let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TransitionWriteVC") as! TransitionWriteVC
            nv.modalPresentationStyle = .fullScreen
            nv.naviTitle = "레시피 작성"
            uv.present(nv, animated: true)
        })
        alert.addAction(UIAlertAction(title: "인수인계 작성", style: .default){ (_) in
            let nv = uv.storyboard?.instantiateViewController(withIdentifier: "TransitionWriteVC") as! TransitionWriteVC
            nv.modalPresentationStyle = .fullScreen
            nv.naviTitle = "인수인계 작성"
            uv.present(nv, animated: true)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        uv.present(alert, animated: true)
    }
}

