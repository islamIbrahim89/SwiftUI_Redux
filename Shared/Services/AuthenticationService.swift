//
//  AuthenticationService.swift
//  SwiftUI_Redux
//
//  Created by Islam Moussa on 10/10/20.
//

import Foundation
import Combine

protocol AuthenticationServiceProtocol {
    func sendOTP(_ model: SendOTP) -> AnyPublisher<GenerateOtpResponse, Error>
    func verifyOTP(_ model: VerifyOTP) -> AnyPublisher<VerifyOtpResponse, Error>
}

class AuthenticationService: AuthenticationServiceProtocol {
    let session: URLSession
    let baseURL = URL(string: "https://....")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func sendOTP(_ model: SendOTP) -> AnyPublisher<GenerateOtpResponse, Error> {
        let url = baseURL.appendingPathComponent("send-otp")
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let data = try! JSONEncoder().encode(model)
        request.httpMethod = "POST"
        request.httpBody = data
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: GenerateOtpResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func verifyOTP(_ model: VerifyOTP) -> AnyPublisher<VerifyOtpResponse, Error> {
        let url = baseURL.appendingPathComponent("verify-otp")
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let data = try! JSONEncoder().encode(model)
        request.httpMethod = "POST"
        request.httpBody = data
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: VerifyOtpResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
