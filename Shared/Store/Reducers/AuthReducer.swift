//
//  AuthReducer.swift
//  SwiftUI_Redux
//
//  Created by Islam Moussa on 10/11/20.
//

import Foundation

struct AuthState: ReduxState {
    var isLoading: Bool = false
    var otpSent: Bool = false
    var isAuthenticated: Bool = false
    var errorMessage: String?
    var phoneNumber: String?
}

struct SendOTPAction: Action {
    let sendOTP: SendOTP
}

struct OTPSentSuccessAction: Action { }

struct OTPSentFailureAction: Action {
    let error: String
}

struct VerifyOTPAction: Action {
    let verifyOTP: VerifyOTP
}

struct VerificationSuccessAction: Action { }

struct VerificationFailureAction: Action {
    let error: String
}

// MARK: - Reducer
let authReducer: Reducer<AuthState> = { state, action in
    var newState = state

    switch action {
    case let action as SendOTPAction:
        newState.isLoading = true
        newState.errorMessage = nil
        newState.otpSent = false
        newState.phoneNumber = action.sendOTP.phoneNumber
    
    case is OTPSentSuccessAction:
        newState.isLoading = false
        newState.otpSent = true
    
    case let action as OTPSentFailureAction:
        newState.isLoading = false
        newState.errorMessage = action.error
    
    case is VerifyOTPAction:
        newState.isLoading = true
        newState.errorMessage = nil
        newState.isAuthenticated = false
    
    case is VerificationSuccessAction:
        newState.isLoading = false
        newState.isAuthenticated = true
    
    case let action as VerificationFailureAction:
        newState.isLoading = false
        newState.errorMessage = action.error
    
    default:
        break
    }
    
    return newState
}
