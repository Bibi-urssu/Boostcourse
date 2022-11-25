//
//  SignUpDetailViewController.swift
//  SignUp
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class SignUpDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var signButton: UIButton!
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        UserInformation.shared.id = nil
        UserInformation.shared.password = nil
        UserInformation.shared.introduce = nil

        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        UserInformation.shared.phoneNumber = self.phoneNumberTextField.text
        UserInformation.shared.birth = self.dateLabel.text
        
        guard let firstViewContorller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        
        firstViewContorller.modalTransitionStyle = .coverVertical
        firstViewContorller.modalPresentationStyle = .fullScreen
        self.present(firstViewContorller, animated: true, completion: nil)
    }
    
// MARK: - datePicker 값 데이터 타입 변경 함수
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        // date의  스타일 지정
        // #월 ##, ####
        formatter.dateFormat = "MMMM dd, yyyy"
        // 포맷터 생성
        return formatter
    } ()
    
    // Target-Action 패턴을 스토리 보드로 구현
    @IBAction func didDatePickerValueChanged(_ sender: UIDatePicker) {
        let date: Date = self.datePicker.date
        // date String으로 변경
        let dateString: String = self.dateFormatter.string(from: date)
        // dateLabel에 설정
        self.dateLabel.text = dateString
        
        signButton.isEnabled = true
    }
// MARK: - currentDate Setting
    func currentDateSetting() {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        var currentDate = formatter.string(from: Date())
        
        self.dateLabel.text = currentDate
    }
    
// MARK: - 전화번호 입력 확인 함수
    @objc func textFieldDidChanged(_ sender: UITextField) {
        // phoneNumber 값이 비었는지 확인하여 값을 signButtonStatus 함수에 넘겨서 호출함
        if self.phoneNumberTextField.text?.isEmpty == false
            // 전화번호 자릿수 체크
            && self.phoneNumberTextField.text?.count == 11
        {
            signButton.isEnabled = true
        }
        else {
            signButton.isEnabled = false
        }
    }
    
// MARK: - 생년월일 입력 확인 함수
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        signButton.isEnabled = true
    }
// MARK: - tapGesture
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
// MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
// MARK: - currentDate Setting
        currentDateSetting()
// MARK: - 가입 버튼 활성화 여부
        // signButton의 초기값은 false
        self.signButton.isEnabled = false
        // 위임자 알려주기
        self.phoneNumberTextField.delegate = self
        // Target-Action 패턴
        // .editingChanged 발생시 textFieldDidChanged 함수 호출
        self.phoneNumberTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
        super.viewDidLoad()
        // Target-Action 패턴을 코드로 구현 (*@IBAction 대신 @objc 사용 시*)
        // .valueChanged 발생시 didDatePickerValueChanged 함수 호출
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
}
