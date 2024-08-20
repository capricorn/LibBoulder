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

extension EnvironmentValues {
    var libCatAPI: LibCatAPIRepresentable {
        get {
            self[LibCatAPIEnvironmentKey.self]
        }
        set {
            self[LibCatAPIEnvironmentKey.self] = newValue
        }
    }
}
