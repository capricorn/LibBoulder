//
//  PreviewAssets.swift
//  LibBoulder
//
//  Created by Collin Palmer on 8/20/24.
//

import SwiftUI

private enum PreviewAssetName: String {
    case jsonCheckedOut = "checked-out"
}

private extension NSDataAsset {
    convenience init?(previewName: PreviewAssetName) {
        self.init(name: previewName.rawValue)
    }
}

struct PreviewAssets {
    static var jsonCheckedOut: CheckedOutBooksModel {
        let asset = NSDataAsset(previewName: .jsonCheckedOut)!
        print("obtained asset")
        return try! JSONDecoder().decode(CheckedOutBooksModel.self, from: asset.data)
    }
}
