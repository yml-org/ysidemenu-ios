//
//  SideMenuControllerTests.swift
//  YSideMenu
//
//  Created by Caio Coan on 14/04/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YSideMenu

final class SideMenuControllerTests: XCTestCase {
    func test_init_createsChildController() throws {
        let viewController = UIViewController()
        let sut = makeSUT(rootViewController: viewController)
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.children.contains(viewController))
        XCTAssertEqual(viewController.parent, sut)
        XCTAssertTrue(sut.contentView.subviews.contains(viewController.view))
    }

    func test_dimmerTap_dismissesSideMenu() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.onDimmerTapped)
        XCTAssertFalse(sut.isDismissed)

        sut.simulateOnDimmerTap()

        XCTAssertTrue(sut.onDimmerTapped)
        XCTAssertTrue(sut.isDismissed)
    }

    func test_swipeMenu_dismissesSideMenu() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.onMenuSwiped)
        XCTAssertFalse(sut.isDismissed)

        sut.simulateSwipeToDismiss()

        XCTAssertTrue(sut.onMenuSwiped)
        XCTAssertTrue(sut.isDismissed)
    }

    func test_performEscape_dismissesSideMenu() {
        let sut = makeSpy(rootViewController: UIViewController())

        XCTAssertFalse(sut.isDismissed)

        _ = sut.accessibilityPerformEscape()

        XCTAssertTrue(sut.isDismissed)
    }
    
    func test_default_appearance() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.loadViewIfNeeded()

        let defaultAppearance = SideMenuController.Appearance.default

        XCTAssertEqual(sut.dimmerView.backgroundColor, defaultAppearance.dimmerColor)
        XCTAssertLessThanOrEqual(sut.contentView.bounds.width, defaultAppearance.maximumWidth)
    }

    func test_change_appearance() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.loadViewIfNeeded()

        let customAppearance = SideMenuController.Appearance(dimmerColor: .green, maximumWidth: 200)
        sut.appearance = customAppearance

        XCTAssertEqual(sut.dimmerView.backgroundColor, customAppearance.dimmerColor)
        XCTAssertLessThanOrEqual(sut.contentView.bounds.width, customAppearance.maximumWidth)
    }

    func test_presentAnimator_returnsTheCorrectAnimator() throws {
        let sut = makeSpy(rootViewController: UIViewController())
        let parent = UIViewController()
        let animator = try XCTUnwrap(sut.animationController(forPresented: sut, presenting: parent, source: parent))
        XCTAssertTrue(animator.isKind(of: SideMenuPresentAnimator.self))
    }

    func test_dismissAnimator_returnsTheCorrectAnimator() throws {
        let sut = makeSpy(rootViewController: UIViewController())
        let animator = try XCTUnwrap(sut.animationController(forDismissed: sut))
        XCTAssertTrue(animator.isKind(of: SideMenuDismissAnimator.self))
    }

    func test_onDimmer() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.onDimmerTapped)
        XCTAssertFalse(sut.isDismissed)
        XCTAssertTrue(sut.dimmerTapView.isAccessibilityElement)

        sut.simulateOnDimmerTap()

        XCTAssertTrue(sut.onDimmerTapped)
        XCTAssertTrue(sut.isDismissed)
        XCTAssertFalse(sut.dimmerTapView.isAccessibilityElement)
    }

    func test_onSwipeLeft() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.onMenuSwiped)
        XCTAssertFalse(sut.isDismissed)

        sut.simulateSwipeToDismiss()

        XCTAssertTrue(sut.onMenuSwiped)
        XCTAssertTrue(sut.isDismissed)
    }

    func test_forbidDismiss() {
        let sut = makeSpy(rootViewController: UIViewController())
        sut.appearance.isDismissAllowed = false
        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.dimmerTapView.isAccessibilityElement)
        XCTAssertFalse(sut.onMenuSwiped)
        XCTAssertFalse(sut.onDimmerTapped)
        XCTAssertFalse(sut.isDismissed)

        sut.simulateOnDimmerTap()
        sut.simulateSwipeToDismiss()
        _ = sut.accessibilityPerformEscape()

        XCTAssertFalse(sut.onMenuSwiped)
        XCTAssertFalse(sut.onDimmerTapped)
    }

    func test_accessibility() {
        let sut = makeSUT(rootViewController: UIViewController())
        sut.loadViewIfNeeded()

        XCTAssertTrue(sut.dimmerTapView.isAccessibilityElement)
        XCTAssertEqual(sut.dimmerTapView.accessibilityIdentifier, SideMenuController.AccessibilityIdentifiers.dimmerId)
        XCTAssertEqual(sut.dimmerTapView.accessibilityTraits, .button)
    }
}

private extension SideMenuControllerTests {
    func makeSUT(
        rootViewController: UIViewController,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SideMenuController {
        let sut = SideMenuController(rootViewController: rootViewController)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }

    func makeSpy(
        rootViewController: UIViewController,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SpySideMenuController {
        let sut = SpySideMenuController(rootViewController: rootViewController)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}

final class SpySideMenuController: SideMenuController {
    var isDismissed = false
    var onDimmerTapped = false
    var onMenuSwiped = false

    override func didDismiss() {
        super.didDismiss()
        isDismissed = true
    }

    override func simulateOnDimmerTap() {
        super.simulateOnDimmerTap()
        if appearance.isDismissAllowed {
            onDimmerTapped = true
        }
    }

    override func simulateSwipeToDismiss() {
        super.simulateSwipeToDismiss()
        if appearance.isDismissAllowed {
            onMenuSwiped = true
        }
    }
}
