//
//  SwiftUI_Redux.swift
//  Shared
//
//  Created by Islam Moussa on 9/14/20.
//

import SwiftUI

@main
struct HelloReduxApp: App {
    let store = AppStore(reducer: appReducer, state: AppState(),
                         middlewares: [AuthenticationMiddleware().handleMiddleware])

       var body: some Scene {
           WindowGroup {
               NavigationView {
                   LoginView()
               }
               .environmentObject(store)
           }
       }
}
