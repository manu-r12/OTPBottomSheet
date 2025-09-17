//
//  MainViewController.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    private let bottomSheet = CustomBottomSheet()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Create and configure the main content
        let titleLabel = UILabel()
        titleLabel.text = "Custom Bottom Sheet Demo"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Tap the button below to show a todo app in a bottom sheet"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Show Todo App Button
        let showTodoButton = UIButton(type: .system)
        showTodoButton.setTitle("Show Todo App", for: .normal)
        showTodoButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        showTodoButton.backgroundColor = .systemBlue
        showTodoButton.setTitleColor(.white, for: .normal)
        showTodoButton.layer.cornerRadius = 12
        showTodoButton.translatesAutoresizingMaskIntoConstraints = false
        showTodoButton.addTarget(self, action: #selector(showTodoBottomSheet), for: .touchUpInside)

        // Custom Configuration Button
        let customConfigButton = UIButton(type: .system)
        customConfigButton.setTitle("Show with Custom Config", for: .normal)
        customConfigButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        customConfigButton.backgroundColor = .systemGreen
        customConfigButton.setTitleColor(.white, for: .normal)
        customConfigButton.layer.cornerRadius = 12
        customConfigButton.translatesAutoresizingMaskIntoConstraints = false
        customConfigButton.addTarget(self, action: #selector(showCustomConfigBottomSheet), for: .touchUpInside)

        // Simple Content Button
        let simpleContentButton = UIButton(type: .system)
        simpleContentButton.setTitle("Show Simple Content", for: .normal)
        simpleContentButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        simpleContentButton.backgroundColor = .systemOrange
        simpleContentButton.setTitleColor(.white, for: .normal)
        simpleContentButton.layer.cornerRadius = 12
        simpleContentButton.translatesAutoresizingMaskIntoConstraints = false
        simpleContentButton.addTarget(self, action: #selector(showSimpleContentBottomSheet), for: .touchUpInside)

        // Add views to the main view
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(showTodoButton)
        view.addSubview(customConfigButton)
        view.addSubview(simpleContentButton)

        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            showTodoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showTodoButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            showTodoButton.widthAnchor.constraint(equalToConstant: 200),
            showTodoButton.heightAnchor.constraint(equalToConstant: 50),

            customConfigButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customConfigButton.topAnchor.constraint(equalTo: showTodoButton.bottomAnchor, constant: 20),
            customConfigButton.widthAnchor.constraint(equalToConstant: 250),
            customConfigButton.heightAnchor.constraint(equalToConstant: 50),

            simpleContentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simpleContentButton.topAnchor.constraint(equalTo: customConfigButton.bottomAnchor, constant: 20),
            simpleContentButton.widthAnchor.constraint(equalToConstant: 200),
            simpleContentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func showTodoBottomSheet() {
        let todoAppView = TodoAppView()
        bottomSheet.present(content: todoAppView, on: self)
    }

    @objc private func showCustomConfigBottomSheet() {
        let config = BottomSheetConfiguration(
            cornerRadius: 20.0,
            isDismissible: true,
            isDismissOnBackdrop: false,
            initialPosition: .full,
            supportedPositions: [.half, .full],
            showGrabber: true
        )

        let todoAppView = TodoAppView()
        bottomSheet.present(content: todoAppView, on: self, configuration: config)
    }

    @objc private func showSimpleContentBottomSheet() {
        let simpleView = VStack(spacing: 20) {
            Text("Simple Bottom Sheet")
                .font(.title2)
                .fontWeight(.bold)

            Text("This is a simple example of how easy it is to integrate any SwiftUI view into our custom bottom sheet.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Close") {
                // In a real implementation, you'd pass a closure to handle dismiss
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()

        bottomSheet.present(content: simpleView, on: self)
    }
}