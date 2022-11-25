//
//  SignUpBasicViewController.swift
//  SignUp
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class SignUpBasicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        UserInformation.shared.id = idTextField.text
        UserInformation.shared.password = passwordTextField.text
        UserInformation.shared.introduce = introduceTextView.text
        
        guard let thirdViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpDetailViewController") as? SignUpDetailViewController else { return }
        
        thirdViewController.modalTransitionStyle = .coverVertical
        thirdViewController.modalPresentationStyle = .fullScreen
        self.present(thirdViewController, animated: true, completion: nil)
    }
    
    // MARK: - textView (placeholder & 글자 수 제한)
    let placeholder = "introduce yourself"
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // placeholder
        if textView.text.isEmpty {
            textView.text = placeholder
        } else if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .black
        } else {
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .gray
            textCountLabel.text = "0/300"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if introduceTextView.text.count > 300 {
            // 글자 수 초과 시 입력 X
            introduceTextView.deleteBackward()
        }
        
        textCountLabel.text = "\(introduceTextView.text.count)/300"
        
        if introduceTextView.text.isEmpty == true ||
            introduceTextView.textColor == .gray {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // 글자 수 부분 색상 변경 (blue)
        let attributedString = NSMutableAttributedString(string: "\(introduceTextView.text.count)/300")
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: ("\(introduceTextView.text.count)/300" as NSString).range(of: "\(introduceTextView.text.count)"))
        
        // 글자 수가 300 이 되면 색상 변경 (red)
        if introduceTextView.text.count == 300 {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: ("\(introduceTextView.text.count)/300" as NSString).range(of: "\(introduceTextView.text.count)"))
        }
        
        textCountLabel.attributedText = attributedString
    }

    // MARK: - imagePickerController
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    // imageView 탭 시 imagePicker 실행
    // objective-C 코드와 호환하기 위해 @objc 사용
    @objc func touchUpImagePicker(_ sender: UITapGestureRecognizer) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // 받아온 이미지를 이미지 뷰에 세팅하기
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = originalImage
        }
    // 이미지 선택 시 화면 dismiss
        self.dismiss(animated: true, completion: nil)
    }
    // imagePicker에서 취소 선택 시 화면 dismiss
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - password와 checkPassword 일치하는지 확인하는 함수
    func checkSamePassword(_ first: UITextField,_ second: UITextField) -> Bool {
        if(first.text == second.text) {
            return true
        } else {
            return false
        }
    }
        
    // MARK: - 다음 버튼 활성화 여부 변경 함수
    @objc func textFieldDidChanged(_ sender: UITextField, _: UITextView) {
        if self.idTextField.text?.isEmpty == false
            && self.passwordTextField.text?.isEmpty == false
            && checkSamePassword(passwordTextField, passwordCheckTextField)
            && self.profileImageView.image != nil
        {
            nextButtonStatus(isOn: true)
        }
        else {
            nextButtonStatus(isOn: false)
        }
    }

    func nextButtonStatus(isOn: Bool) {
        if(isOn == true) {
            self.nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // MARK: - textView placeholer
            self.introduceTextView.text = placeholder
            self.introduceTextView.textColor = .gray
            self.textCountLabel.text = "0/300"
    // MARK: - 다음 버튼 활성화 여부
            // 버튼의 초기값은 false
            self.nextButtonStatus(isOn: false)
            // 위임자가 누군지 알려주기 (self = 현재 클래스 <SignUpViewController> )
            // 이벤트 발생 시 위임자가 프로토콜에 따라 응답을 줌
            self.idTextField.delegate = self
            self.passwordTextField.delegate = self
            self.passwordCheckTextField.delegate = self
            self.introduceTextView.delegate = self
            // addTarget
            self.idTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
            self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
            self.passwordCheckTextField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
    // MARK: - imagePicker
            // 제스처 인식기 생성
            let tapImageViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchUpImagePicker(_:)))
            // 이미지뷰가 상호작용할 수 있게 설정
            self.profileImageView.isUserInteractionEnabled = true
            // 이미지뷰에 제스처 인식기 연결
            self.profileImageView.addGestureRecognizer(tapImageViewRecognizer)
        }
}
