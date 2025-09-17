//
//  OTPBottomSheetApp.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import SwiftUI
import UIKit

@main
struct OTPBottomSheetApp: App {
    var body: some Scene {
        WindowGroup {
            UIKitWrapper()
                .ignoresSafeArea(.all)
        }
    }
}

struct UIKitWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let mapViewController = MapViewController()
        let navigationController = UINavigationController(rootViewController: mapViewController)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {

    }
}
