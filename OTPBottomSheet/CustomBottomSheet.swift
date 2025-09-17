//
//  CustomBottomSheet.swift
//  OTPBottomSheet
//
//  Created by Manu on 2025-09-17.
//

import UIKit
import SwiftUI
import FloatingPanel

// RENAMED TO - OTPBOTTOMSHEET
/*
config: OTPConfig
RestAPIService

 */
public protocol BottomSheetDelegate: AnyObject {
    func bottomSheetDidChangePosition(_ position: BottomSheetPosition)
}

public class CustomBottomSheet {
    private var floatingPanelController: FloatingPanelController?
    private weak var parentViewController: UIViewController?
    private var currentConfiguration: BottomSheetConfiguration?
    public weak var delegate: BottomSheetDelegate?

    public init() {}

    public func present<Content: View>(
        content: Content,
        on viewController: UIViewController,
        configuration: BottomSheetConfiguration = BottomSheetConfiguration()
    ) {
        self.parentViewController = viewController
        self.currentConfiguration = configuration

        // Create the FloatingPanel controller
        floatingPanelController = FloatingPanelController()

        // Configure the panel
        let layout = CustomBottomSheetLayout(configuration: configuration)
        floatingPanelController?.layout = layout
        floatingPanelController?.delegate = self
        floatingPanelController?.isRemovalInteractionEnabled = configuration.isDismissible
        floatingPanelController?.backdropView.dismissalTapGestureRecognizer.isEnabled = configuration.isDismissOnBackdrop

        // Create SwiftUI hosting controller
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear

        // Set the content view controller
        floatingPanelController?.set(contentViewController: hostingController)

        // Present the panel
        viewController.present(floatingPanelController!, animated: true)
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        floatingPanelController?.dismiss(animated: animated, completion: completion)
    }

    // MARK: - State Control Methods

    public func moveToPosition(_ position: BottomSheetPosition, animated: Bool = true) {
        guard let floatingPanel = floatingPanelController else { return }

        let targetState: FloatingPanelState
        switch position {
        case .tip:
            targetState = .tip
        case .half:
            targetState = .half
        case .full:
            targetState = .full
        }

        floatingPanel.move(to: targetState, animated: animated)
    }

    public func getCurrentPosition() -> BottomSheetPosition {
        guard let floatingPanel = floatingPanelController else { return .half }

        switch floatingPanel.state {
        case .tip:
            return .tip
        case .half:
            return .half
        case .full:
            return .full
        default:
            return .half
        }
    }

    public func updateContent<Content: View>(_ content: Content, animated: Bool = true) {
        guard let floatingPanel = floatingPanelController else { return }

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear

        if animated {
            UIView.transition(with: floatingPanel.surfaceView, duration: 0.3, options: .transitionCrossDissolve) {
                floatingPanel.set(contentViewController: hostingController)
            }
        } else {
            floatingPanel.set(contentViewController: hostingController)
        }
    }
}

public struct BottomSheetConfiguration {
    public let cornerRadius: CGFloat
    public let isDismissible: Bool
    public let isDismissOnBackdrop: Bool
    public let initialPosition: BottomSheetPosition
    public let supportedPositions: [BottomSheetPosition]
    public let showGrabber: Bool

    public init(
        cornerRadius: CGFloat = 12.0,
        isDismissible: Bool = true,
        isDismissOnBackdrop: Bool = true,
        initialPosition: BottomSheetPosition = .half,
        supportedPositions: [BottomSheetPosition] = [.tip, .half, .full],
        showGrabber: Bool = true
    ) {
        self.cornerRadius = cornerRadius
        self.isDismissible = isDismissible
        self.isDismissOnBackdrop = isDismissOnBackdrop
        self.initialPosition = initialPosition
        self.supportedPositions = supportedPositions
        self.showGrabber = showGrabber
    }
}

public enum BottomSheetPosition {
    case tip
    case half
    case full
}

private class CustomBottomSheetLayout: FloatingPanelLayout {
    private let configuration: BottomSheetConfiguration

    init(configuration: BottomSheetConfiguration) {
        self.configuration = configuration
    }

    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 140.0, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea)
        ]
    }
}

// MARK: - FloatingPanelControllerDelegate
extension CustomBottomSheet: FloatingPanelControllerDelegate {
    public func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        let position = getCurrentPosition()
        delegate?.bottomSheetDidChangePosition(position)
    }
}
