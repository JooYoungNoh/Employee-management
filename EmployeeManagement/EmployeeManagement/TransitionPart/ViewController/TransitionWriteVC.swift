//
//  TransitionWriteVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/07/13.
//

import UIKit
import SnapKit

class TransitionWriteVC: UIViewController {
    
    var naviTitle: String = ""         //전 화면에서 받아올 타이틀
    var companyName: String = ""       //전 화면에서 받아올 회사이름
    var checkTitle: [String] = []      //전 화면에서 받아올 타이틀 (중복여부 체크)
    var viewModel = TwriteVM()
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 20)
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        button.isHidden = true
        return button
    }()
    
    //MARK: 메모 부분
    let memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0"
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .right
        return label
    }()
    
    let writeTV: UITextView = {
       let write = UITextView()
        write.textColor = UIColor.systemGray
        write.text = "첫줄은 제목입니다."
        write.font = UIFont(name: "CookieRun", size: 18)
        write.textAlignment = .left
        write.backgroundColor = .systemGray6
        return write
    }()
    
    //MARK: 컬렉션 뷰 부분
    let pictureLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "CookieRun", size: 18)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 18)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "CookieRun", size: 18)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(TransitionWriteCell.self, forCellWithReuseIdentifier: TransitionWriteCell.identifier)
        self.writeTV.delegate = self
        print(self.checkTitle)
        self.uiCreate()
    }
    
    //MARK: 액션 메소드
    @objc func doclose(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    //사진 추가
    @objc func addPicture(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "선택해주세요", preferredStyle: .actionSheet)
        //카메라를 사용할 수 있으면 (시뮬레이터 불가)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default){(_) in
                self.imgPicker(.camera)
            })
        }
        //저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "앨범", style: .default){(_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        //포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default){(_) in
                self.imgPicker(.photoLibrary)
            })
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    //사진 삭제
    @objc func deletePicture(_ sender: UIButton){
        self.viewModel.deletePicture(view: self, collectionView: collectionView)
    }
    
    //메모 저장
    @objc func saveMemo(_ sender: UIButton){
        self.viewModel.saveMemoFB(uv: self, checkTitle: self.checkTitle, companyName: self.companyName, naviTitle: self.naviTitle, writeTV: self.writeTV, countLabel: self.countLabel)
    }

    //MARK: 화면 메소드
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //타이틀 레이블 UI
        self.titleLabel.text = self.naviTitle
        self.view.addSubview(self.titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        //저장 버튼 UI
        self.saveButton.addTarget(self, action: #selector(saveMemo(_:)), for: .touchUpInside)
        self.view.addSubview(self.saveButton)
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        //메모레이블 UI
        self.view.addSubview(self.memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.closeButton.snp.bottom).offset(15)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        //글자 수 레이블 UI
        self.view.addSubview(self.countLabel)
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.closeButton.snp.bottom).offset(15)
            make.width.equalTo(50)
            make.height.equalTo(30)

        }
        
        //메모 텍스트 뷰 UI
        self.view.addSubview(self.writeTV)
        writeTV.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(self.memoLabel.snp.bottom).offset(10)
            make.height.equalTo(390)
        }
        
        //사진레이블 UI
        self.view.addSubview(self.pictureLabel)
        pictureLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.writeTV.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        //삭제버튼 UI
        self.deleteButton.addTarget(self, action: #selector(deletePicture(_:)), for: .touchUpInside)
        self.view.addSubview(self.deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(self.writeTV.snp.bottom).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        //추가버튼 UI
        self.addButton.addTarget(self, action: #selector(addPicture(_:)), for: .touchUpInside)
        self.view.addSubview(self.addButton)
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.deleteButton.snp.leading)
            make.top.equalTo(self.writeTV.snp.bottom).offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        //컬렉션 뷰 UI
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.pictureLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
    
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

//MARK: 컬렉션 뷰 메소드
extension TransitionWriteVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pictureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.viewModel.cellInfo(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectCell(collectionView: collectionView, indexPath: indexPath)
    }
}

//MARK: 이미지 피커 메소드
extension TransitionWriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // 이미지를 가져올 장소(?) 카메라 앨범 등 선택 메소드
    func imgPicker(_ source: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
        
    }
    //이미지 선택하면 호출될 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        self.viewModel.pictureList.append(img!)
        //이미지 피커 컨트롤창 닫기
        picker.dismiss(animated: true){ () in
            self.collectionView.reloadData()
            self.viewModel.pictureDeleteNumberList.removeAll()
        }
    }
}

//MARK: 텍스트 뷰 메소드
extension TransitionWriteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.changeMemo(textView: textView, countLabel: self.countLabel, saveButton: self.saveButton)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.viewModel.endMemo(textView: textView, countLabel: self.countLabel, saveButton: self.saveButton)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.viewModel.startMemo(textView: textView, countLabel: self.countLabel)
    }
}

