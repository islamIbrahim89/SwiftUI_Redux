//
//  AuthModels.swift
//  SwiftUI_Redux
//
//  Created by islam moussa on 31/01/2025.
//

import Foundation

typealias GenerateOtpResponse = ApiBaseModel<String>
typealias VerifyOtpResponse = ApiBaseModel<User>

struct SendOTP: Encodable {
    let phoneNumber: String?
    let countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "mobile",
             countryCode = "country_code_id"
    }
}

struct VerifyOTP: Encodable {
    let otp, phoneNumber: String?
    let countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case otp, phoneNumber = "mobile", countryCode = "country_code_id"
    }
}

struct User: Decodable {
    let id, firstName, lastName, mobile: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case id, firstName = "first_name", lastName = "last_name",
             token, mobile
    }
}



struct ApiBaseModel<T: Decodable>: Decodable {
    var code: Int?
    var msg: String?
    var message: String?
    var data: T?
}
