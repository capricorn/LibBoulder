//
//  UserDefaultsExtensions.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI
import KeychainAccess

struct LibCatAPIEnvironmentKey: EnvironmentKey {
    static let defaultValue: LibCatAPIRepresentable = LibCatAPI()
}

typealias LogoutController = () -> Void
struct LogoutControllerEnvironmentKey: EnvironmentKey {
    static let defaultValue: LogoutController = {}
}

struct KeychainEnvironmentKey: EnvironmentKey {
    static let defaultValue: Keychain = Keychain(service: "com.goatfish.LibBoulder")
}

extension EnvironmentValues {
    var libCatAPI: LibCatAPIRepresentable {
        get {
            self[LibCatAPIEnvironmentKey.self]
        }
        set {
            self[LibCatAPIEnvironmentKey.self] = newValue
        }
    }
    
    var logoutController: LogoutController {
        get {
            self[LogoutControllerEnvironmentKey.self]
        }
        set {
            self[LogoutControllerEnvironmentKey.self] = newValue
        }
    }
    
    var keychain: Keychain {
        get {
            self[KeychainEnvironmentKey.self]
        }
        set {
            self[KeychainEnvironmentKey.self] = newValue
        }
    }
}
