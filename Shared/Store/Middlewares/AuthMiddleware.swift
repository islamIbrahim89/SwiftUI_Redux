//
//  AuthenticationMiddleware.swift
//  SwiftUI_Redux
//
//  Created by Islam Moussa on 10/11/20.
//

import Foundation
import Combine

// MARK: - Middleware
class AuthenticationMiddleware {
    private let authService: AuthenticationService
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
    }
    
    func handleMiddleware(state: AppState, action: Action, dispatch: @escaping Dispatcher) {
        switch action {
        case let action as SendOTPAction:
            authService.sendOTP(action.sendOTP)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        dispatch(OTPSentFailureAction(error: error.localizedDescription))
                    }
                }, receiveValue: { data in
                    if data.code == 20 {
                        dispatch(OTPSentSuccessAction())
                        return
                    }
                    dispatch(OTPSentFailureAction(error: data.msg ?? ""))
                })
                .store(in: &cancellables)
            
        case let action as VerifyOTPAction:
            authService.verifyOTP(action.verifyOTP)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        dispatch(VerificationFailureAction(error: error.localizedDescription))
                    }
                }, receiveValue: { data in
                    if data.code == 20 {
                        dispatch(VerificationSuccessAction())
                        return
                    }
                    dispatch(VerificationFailureAction(error: data.msg ?? ""))
                })
                .store(in: &cancellables)
            
        default:
            break
        }
    }
}
