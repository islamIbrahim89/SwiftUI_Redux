//
//  LoginView.swift
//  Shared
//
//  Created by Islam Moussa on 9/14/20.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var store: AppStore
    @State private var phoneNumber = ""

    var body: some View {
        let props = map(state: store.state.authState)
        
        VStack {
            TextField("Enter Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send OTP") {
                props.sendOTP(phoneNumber)
            }
            .disabled(props.isLoading)

            if props.isLoading {
                ProgressView()
            }

            if let error = props.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .navigationTitle("Login")
        .background(
            NavigationLink(
                destination: OTPView(),
                isActive: .constant(props.otpSent),
                label: { EmptyView() }
            )
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        
        let store = AppStore(reducer: appReducer,
                             state: AppState(), middlewares: [AuthenticationMiddleware().handleMiddleware])
        return LoginView().environmentObject(store)
    }
}


extension LoginView {
    struct Props {
        let isLoading: Bool
        let errorMessage: String?
        let otpSent: Bool
        let sendOTP: (String) -> Void
    }
    
    private func map(state: AuthState) -> Props {
        return Props(
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            otpSent: state.otpSent,
            sendOTP: { phoneNumber in
                store.dispatch(action: SendOTPAction(sendOTP: SendOTP(phoneNumber: phoneNumber, countryCode: "+966")))
            }
        )
    }
}

