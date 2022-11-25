//
//  UserInformation.swift
//  SignUp
//
//  Created by 박다연 on 2022/11/24.
//

import Foundation

class UserInformation {
// MARK: - SingleTon Pattern
    static let shared: UserInformation = UserInformation()
    
    var id: String?
    var password: String?
    var introduce: String?
    var phoneNumber: String?
    var birth: String?
}
