//
//  LoginViewController.swift
//  SignUp
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpBasicViewController") as? SignUpBasicViewController else { return }
        
        secondViewController.modalTransitionStyle = .coverVertical
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController, animated: true, completion: nil)
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if UserInformation.shared.id != self.idTextField.text
            && self.idTextField.text?.isEmpty == false
            && self.passwordTextField.text?.isEmpty == false {
            let alert = UIAlertController(title: "로그인 실패", message: "등록되지 않은 ID 입니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else if UserInformation.shared.id == self.idTextField.text
                    && UserInformation.shared.password != self.passwordTextField.text
                    && self.passwordTextField.text?.isEmpty == false {
            let alert = UIAlertController(title: "로그인 실패", message: "비밀번호가 일치하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else if UserInformation.shared.id == self.idTextField.text
                    && UserInformation.shared.password == self.passwordTextField.text {
            let alert = UIAlertController(title: "로그인 성공", message: nil, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else if self.idTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "로그인 실패", message: "ID를 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else if self.passwordTextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "로그인 실패", message: "비밀번호를 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - tapGesture
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - 키보드 사용시 뷰 올리기
        // 옵저버 등록, 옵저버 대상 (self), 옵저버 감지시 실행 함수, 옵저버가 감지할 것
        override func viewWillAppear(_ animated: Bool) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        // 뷰가 사라질 때 옵저버 해제
        override func viewWillDisappear(_ animated: Bool) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        // 뷰를 얼마나 올려야 하는지 알기 위해 키보드 사이즈 구하기
        // CGAffineTransform 로 키보드 높이 만큼 뷰 올리기
        @objc func keyboardUp(notification: NSNotification) {
            if let keyboardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                UIView.animate(
                    withDuration: 0.3
                    , animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: -80)
                        // y: -keyboardRectangle.height
                    })
            }
        }
     
        @objc func keyboardDown() {
            // 키보드가 원위치로 돌아오게 하기
            self.view.transform = .identity
        }
    // MARK: - 가입 완료 시 아이디 자동 입력 함수
    func userIDSetting() {
        if UserInformation.shared.id != nil {
            idTextField.text = UserInformation.shared.id
        } else {
            idTextField.text = nil
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 가입 완료 시 아이디 자동 입력 함수 호출
        userIDSetting()
    }
}

