//
//  AppReducer.swift
//  CombiningReducers
//
//  Created by Islam Moussa on 9/15/20.
//

import Foundation

let appReducer: Reducer<AppState> = { state, action in
    var newState = state
    newState.authState = authReducer(state.authState, action)
    return newState
}

