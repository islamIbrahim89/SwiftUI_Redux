//
//  OTPView.swift
//  SwiftUI_Redux
//
//  Created by Islam Moussa on 10/11/20.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var store: AppStore
    @State private var otpCode = ""

    var body: some View {
        let props = map(state: store.state.authState)
        
        VStack {
            TextField("Enter OTP Code", text: $otpCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Verify OTP") {
                props.verifyOTP(otpCode)
            }
            .disabled(props.isLoading)
            
            if props.isLoading {
                ProgressView()
            }

            if let error = props.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .navigationTitle("OTP Verification")
        .background(
            NavigationLink(
                destination: HomeView(),
                isActive: .constant(props.isAuthenticated),
                label: { EmptyView() }
            )
        )
    }
}


struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        
        let store = AppStore(reducer: appReducer,
                             state: AppState(), middlewares: [AuthenticationMiddleware().handleMiddleware])
        return OTPView().environmentObject(store)
    }
}


extension OTPView {
    struct Props {
        let isLoading: Bool
        let errorMessage: String?
        let isAuthenticated: Bool
        let verifyOTP: (String) -> Void
    }
    
    private func map(state: AuthState) -> Props {
        return Props(
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            isAuthenticated: state.isAuthenticated,
            verifyOTP: { code in
                store.dispatch(action: VerifyOTPAction(verifyOTP: VerifyOTP(otp: code,
                                                                            phoneNumber: state.phoneNumber,
                                                                            countryCode: "+966")))
            }
        )
    }
}
