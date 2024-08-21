//
//  UserDefaultsExtensions.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI

struct LibCatAPIEnvironmentKey: EnvironmentKey {
    static let defaultValue: LibCatAPIRepresentable = LibCatAPI()
}

typealias LogoutController = () -> Void
struct LogoutControllerEnvironmentKey: EnvironmentKey {
    static let defaultValue: LogoutController = {}
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
}
