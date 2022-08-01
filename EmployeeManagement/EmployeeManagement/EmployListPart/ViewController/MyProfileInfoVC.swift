//
//  MyProfileInfoVC.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/06/09.
//

import UIKit
import SnapKit

class MyProfileInfoVC: UIViewController, UITextViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var nameOnTable: String = ""        //전 화면 셀에 있는 이름
    var commentOnTable: String = ""     //전 회면 셀에 있는 코멘트
    var imageOnTable: UIImage!          //전 화면 셀에 있는 사진
    
    
    var viewModel = MyProfileVM()
    
    //닫기 버튼
    let closeButton: UIButton = {
        let close = UIButton()
        close.setTitle("Close", for: .normal)
        close.setTitleColor(UIColor.black, for: .normal)
        close.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        return close
    }()
    //저장 버튼
    let saveButton: UIButton = {
        let save = UIButton()
        save.setTitle("Save", for: .normal)
        save.setTitleColor(UIColor.black, for: .normal)
        save.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        save.isHidden = true
        return save
    }()
    //취소 버튼
    let cancelButton: UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(UIColor.black, for: .normal)
        cancel.titleLabel?.font = UIFont.init(name: "CookieRun", size: 20)
        cancel.isHidden = true
        return cancel
    }()
    
    //프로필 이미지
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    //이름
    let nameLabel: UILabel = {
       let name = UILabel()
        name.textColor = UIColor.black
        name.font = UIFont(name: "CookieRun", size: 30)
        name.textAlignment = .center
        name.backgroundColor = .systemGray6
        return name
    }()
    //코멘트
    let commentLabel: UILabel = {
        let comment = UILabel()
        comment.textColor = UIColor.black
        comment.alpha = 0.5
        comment.font = UIFont(name: "CookieRun", size: 18)
        comment.textAlignment = .center
        comment.backgroundColor = .systemGray6
        comment.numberOfLines = 0
        return comment
    }()
    
    //코멘트 변경 텍스트 뷰
    let commentTF: UITextView = {
        let text = UITextView()
        text.isHidden = true
        text.textColor = UIColor.black
        text.alpha = 0.5
        text.font = UIFont(name: "CookieRun", size: 18)
        text.textAlignment = .center
        text.backgroundColor = .white
        return text
    }()
    
    //코멘트 숫자 변경 레이블
    let countLabel: UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.backgroundColor = .systemGray6
        label.alpha = 0.5
        label.font = UIFont(name: "CookieRun", size: 15)
        label.textAlignment = .center
        return label
    }()
    
    //컬렉션 뷰 위쪽 선 표시
    let commentUnderView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //나랑 같은 회사 레이블
    let myCompany: UILabel = {
        let label = UILabel()
        label.text = "내가 다니는 회사 ↓"
        label.textColor = UIColor.blue
        label.font = UIFont(name: "CookieRun", size: 18)
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        return label
    }()
    
    //버튼들 위쪽 선 표시
    let buttonUpView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    //내 메모
    let myMemoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "note"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let myMemoLabel: UILabel = {
        let label = UILabel()
        label.text = "내 메모"
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.font = UIFont(name: "CookieRun", size: 15)
        return label
    }()
    //프로필 편집
    let penButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pen"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let penLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 변경"
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.font = UIFont(name: "CookieRun", size: 15)
        return label
    }()
    //급여 계산
    let calculatorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calculator"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let calculatorLabel: UILabel = {
        let label = UILabel()
        label.text = "급여 계산"
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemGray6
        label.font = UIFont(name: "CookieRun", size: 15)
        return label
    }()
    //컬렉션 뷰
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 120)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray6
        return collection
    }()

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentTF.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ProfileInfoCVCell.self, forCellWithReuseIdentifier: ProfileInfoCVCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiCreate()
        self.view.backgroundColor = .systemGray6
        self.viewModel.findMyCompany{ completion in
            self.collectionView.reloadData()
        }

    }
    
    //MARK: 화면 UI 메소드
    func uiCreate(){
        //닫기 버튼 UI
        closeButton.addTarget(self, action: #selector(doclose(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        //저장 버튼 UI
        saveButton.addTarget(self, action: #selector(dosave(_:)), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(75)
            make.height.equalTo(40)
        }
        
        //취소 버튼 UI
        cancelButton.addTarget(self, action: #selector(docancel(_:)), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.saveButton.snp.leading)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.width.equalTo(75)
            make.height.equalTo(40)
        }
        
        //MARK: 정보 부분
        //프로필 이미지 UI
        self.profileImage.image = self.imageOnTable
        self.view.addSubview(profileImage)
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.height.equalTo(200)
        }
        //이름 UI
        self.nameLabel.text = self.nameOnTable
        self.view.addSubview(self.nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImage.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        //코멘트 UI
        self.commentLabel.text = self.commentOnTable
        self.view.addSubview(self.commentLabel)
        
        commentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.lessThanOrEqualTo(60)
        }
        //코멘트 변경 텍스트뷰 UI
        self.commentTF.text = self.commentLabel.text
        self.view.addSubview(self.commentTF)
        
        commentTF.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.lessThanOrEqualTo(60)
        }
        
        //코멘트 숫자 레이블 UI
        self.countLabel.text = "\(self.commentTF.text.count)/20"
        self.view.addSubview(self.countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.commentTF.snp.trailing)
            make.bottom.equalTo(self.commentTF.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }

        
        //MARK: 버튼 선택 부분
        //메모 UI
        self.view.addSubview(myMemoLabel)
        myMemoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        self.myMemoButton.addTarget(self, action: #selector(doMemo(_:)), for: .touchUpInside)
        self.view.addSubview(myMemoButton)
        myMemoButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.myMemoLabel.snp.centerX)
            make.bottom.equalTo(self.myMemoLabel.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        //프로필 관리 UI
        self.view.addSubview(penLabel)
        penLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        penButton.addTarget(self, action: #selector(doProfile(_:)), for: .touchUpInside)
        self.view.addSubview(penButton)
        penButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.penLabel.snp.centerX)
            make.bottom.equalTo(self.penLabel.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        //급여 계산 UI
        self.view.addSubview(calculatorLabel)
        calculatorLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-35)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        calculatorButton.addTarget(self, action: #selector(doCalculator(_:)), for: .touchUpInside)
        self.view.addSubview(calculatorButton)
        calculatorButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.calculatorLabel.snp.centerX)
            make.bottom.equalTo(self.calculatorLabel.snp.top).offset(-5)
            make.width.height.equalTo(30)
        }
        
        //버튼 위쪽 선 UI
        self.view.addSubview(self.buttonUpView)
        buttonUpView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(self.myMemoButton.snp.top).offset(-15)
        }
        
        //MARK: 컬렉션 뷰
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.buttonUpView.snp.top).offset(-20)
            make.height.equalTo(150)
        }
        
        //컬렉션 뷰 위 선 UI
        self.view.addSubview(self.commentUnderView)
        commentUnderView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(self.collectionView.snp.top).offset(-20)
        }
        
        //내가 다니는 회사 레이블 UI
        self.view.addSubview(self.myCompany)
        myCompany.snp.makeConstraints { make in
            make.width.equalTo(165)
            make.height.equalTo(30)
            make.bottom.equalTo(self.commentUnderView.snp.top).offset(-5)
            make.leading.equalTo(self.closeButton.snp.leading)
        }
    }
    
    //MARK: 엑션 메소드
    @objc func doclose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func docancel(_ sender: UIButton){
        self.viewModel.cancelMessage(commentTF: self.commentTF, countLabel: self.countLabel, commentLabel: self.commentLabel, saveButton: self.saveButton, cancelButton: self.cancelButton)
    }
    
    @objc func dosave(_ sender: UIButton){
        if self.commentTF.text.count > 20 {
            let alert2 = UIAlertController(title: "최대 20자까지입니다", message: "다시 입력해주세요", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert2, animated: true)
        } else {
            let alert = UIAlertController(title: "변경 사항이 저장됩니다.", message: "진행하시겠습니까?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                //상태메시지 변경
                self.viewModel.changeCommentSave(commentTF: self.commentTF, commentLabel: self.commentLabel)
                //이미지 변경
                self.viewModel.changeValueSave(imgView: self.profileImage, tableImg: self.imageOnTable!)
                self.cancelButton.isHidden = true
                self.saveButton.isHidden = true
                self.commentTF.isHidden = true
                self.countLabel.isHidden = true
                self.commentLabel.isHidden = false
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func doMemo(_ sender: UIButton){
        let naviCon = self.storyboard?.instantiateViewController(withIdentifier: "NaviCon")
        naviCon?.modalPresentationStyle = .fullScreen
        
        self.present(naviCon!, animated: true)
    }
    
    @objc func doProfile(_ sender: UIButton){
        let alert = UIAlertController(title: "선택해주세요", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "프로필 이미지 변경", style: .default) { (_) in
            let alert2 = UIAlertController(title: "선택해주세요", message: nil, preferredStyle: .actionSheet)
            self.profileImageChange(alert2: alert2)
            
            self.present(alert2, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "상태메시지 변경", style: .default) { (_) in
            self.commentTF.isHidden = false
            self.countLabel.isHidden = false
            self.commentLabel.isHidden = true
           
        })
        
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func doCalculator(_ sender: UIButton){
        let nv = self.storyboard?.instantiateViewController(withIdentifier: "CalculatorVC") as! CalculatorVC
        nv.modalPresentationStyle = .fullScreen
        self.present(nv, animated: true)
    }
    
    //MARK: 텍스트 뷰 메소드
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.changeMessage(textView: textView, countLabel: self.countLabel, commentLabel: self.commentLabel, saveButton: self.saveButton, cancelButton: self.cancelButton)
    }
    
    //MARK: tap 제스쳐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.cancelButton.isHidden = true
        self.commentTF.isHidden = true
        self.countLabel.isHidden = true
        self.commentLabel.isHidden = false
        self.commentTF.text = self.commentLabel.text
        self.countLabel.text = "\(self.commentLabel.text!.count)/20"
        if self.imageOnTable != self.profileImage.image {
            self.saveButton.isHidden = false
        } else {
            self.saveButton.isHidden = true
        }
    }
}

//MARK: collectionView 메소드
extension MyProfileInfoVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInfoCVCell.identifier, for: indexPath) as? ProfileInfoCVCell else { return UICollectionViewCell() }
    
        
        cell.titleLabel.text = self.viewModel.dbmyCompany[indexPath.row]
        self.viewModel.companyDownloadimage(imgView: cell.imageView, company: cell.titleLabel.text!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dbmyCompany.count
    }
}

//MARK: ImagePicker 메소드
extension MyProfileInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        self.profileImage.image = img
        self.saveButton.isHidden = false
        //이미지 피커 컨트롤창 닫기
        picker.dismiss(animated: true)
    }
    
    func profileImageChange(alert2: UIAlertController){
        //카메라를 사용할 수 있으면 (시뮬레이터 불가)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert2.addAction(UIAlertAction(title: "카메라", style: .default){(_) in
                self.imgPicker(.camera)
            })
        }
        //저장된 앨범을 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert2.addAction(UIAlertAction(title: "앨범", style: .default){(_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        //포토 라이브러리를 사용할 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert2.addAction(UIAlertAction(title: "포토 라이브러리", style: .default){(_) in
                self.imgPicker(.photoLibrary)
            })
        }
        //이미지 삭제
        alert2.addAction(UIAlertAction(title: "프로필 이미지 삭제", style: .default) { (_) in
            self.present(self.viewModel.imageDelete(imgView: self.profileImage, savebutton: self.saveButton), animated: true)
        })
        //취소 버튼 추가
        alert2.addAction(UIAlertAction(title: "취소", style: .cancel))
    }
}

