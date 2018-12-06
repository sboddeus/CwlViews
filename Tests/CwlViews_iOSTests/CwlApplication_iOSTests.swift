//
//  CwlApplication_iOSTests.swift
//  CwlViews_iOSTests
//
//  Created by Matt Gallagher on 3/11/18.
//  Copyright © 2018 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import XCTest
@testable import CwlViews

func appConstructor(_ binding: Application.Binding) -> Application.Instance {
	let storedConstruction = Application.Storage.storedBinderConstruction { Application(binding) }
	let storage = Application.Storage()
	withExtendedLifetime(storage) {
		UIApplication.shared.delegate = storage
		Application.Storage.applyStoredBinderConstructionToGlobalDelegate(storedConstruction)
	}
	return UIApplication.shared
}

class CwlApplicationTests: XCTestCase {
	
	// MARK: - 0. Static bindings
	
	// MARK: - 1. Value bindings
	
	func testAdditionalWindows() {
		testValueBinding(
			name: .additionalWindows,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ([Window()], 1),
			second: ([], 0),
			getter: { $0.windows.count }
		)
	}
	func testIconBadgeNumber() {
		testValueBinding(
			name: .iconBadgeNumber,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: (1, 1),
			second: (0, 0),
			getter: { $0.applicationIconBadgeNumber }
		)
	}
	func testIsIdleTimerDisabled() {
		testValueBinding(
			name: .isIdleTimerDisabled,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isIdleTimerDisabled }
		)
	}
	func testIsNetworkActivityIndicatorVisible() {
		testValueBinding(
			name: .isNetworkActivityIndicatorVisible,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isNetworkActivityIndicatorVisible }
		)
	}
	func testShortcutItems() {
		UIApplication.shared.shortcutItems = []
		testValueBinding(
			name: .shortcutItems,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: 0,
			first: ([UIApplicationShortcutItem(type: "a", localizedTitle: "b")], 1),
			second: ([], 0),
			getter: { $0.shortcutItems?.count ?? 0 }
		)
	}
	func testSupportShakeToEdit() {
		testValueBinding(
			name: .supportShakeToEdit,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: true,
			first: (false, false),
			second: (true, true),
			getter: { $0.applicationSupportsShakeToEdit }
		)
	}
	func testWindow() {
		testValueBinding(
			name: .window,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: nil,
			first: (Window(.tag -- 1234), 1234),
			second: (nil, nil),
			getter: { ($0.delegate as? Application.Storage)?.window?.tag }
		)
	}
	
	// MARK: - 2. Signal bindings
	
	func testIgnoreInteractionEvents() {
		testSignalBinding(
			name: .ignoreInteractionEvents,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isIgnoringInteractionEvents }
		)
	}
	func testRegisterForRemoteNotifications() {
		testSignalBinding(
			name: .registerForRemoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			initial: false,
			first: (true, true),
			second: (false, false),
			getter: { $0.isRegisteredForRemoteNotifications }
		)
	}

	// MARK: - 3. Action bindings
	func testDidBecomeActive() {
		testActionBinding(
			name: .didBecomeActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationDidBecomeActive?($0) },
			validate: { _ in true }
		)
	}
	func testDidEnterBackground() {
		testActionBinding(
			name: .didEnterBackground,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationDidEnterBackground?($0) },
			validate: { _ in true }
		)
	}
	func testDidFailToContinueUserActivity() {
		testActionBinding(
			name: .didFailToContinueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didFailToContinueUserActivityWithType: "abcd", error: TestError("efgh")) },
			validate: { tuple in tuple.0 == "abcd" && (tuple.1 as? TestError) == TestError("efgh") }
		)
	}
	func testDidReceiveMemoryWarning() {
		testActionBinding(
			name: .didReceiveMemoryWarning,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationDidReceiveMemoryWarning?($0) },
			validate: { _ in true }
		)
	}
	func testDidReceiveRemoteNotification() {
		var result: UIBackgroundFetchResult? = nil
		let callback = { (r: UIBackgroundFetchResult) in
			result = r
		}
		testActionBinding(
			name: .didReceiveRemoteNotification,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didReceiveRemoteNotification: ["a": "b"], fetchCompletionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: UIBackgroundFetchResult.noData)
				return result == UIBackgroundFetchResult.noData && tuple.value as? [String: String] == ["a": "b"]
			}
		)
	}
	func testDidRegisterRemoteNotifications() {
		testActionBinding(
			name: .didRegisterRemoteNotifications,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, didRegisterForRemoteNotificationsWithDeviceToken: Data(base64Encoded: "1234")!) },
			validate: { token in token.value == Data(base64Encoded: "1234")! }
		)
	}
	func testHandleEventsForBackgroundURLSession() {
		var received = false
		let callback = { () -> Void in
			received = true
		}
		testActionBinding(
			name: .handleEventsForBackgroundURLSession,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, handleEventsForBackgroundURLSession: "abcd", completionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: ())
				return received == true && tuple.value == "abcd"
		}
		)
	}
	func testHandleWatchKitExtensionRequest() {
		var result: [AnyHashable: Any]? = nil
		let callback = { (r: [AnyHashable: Any]?) -> Void in
			result = r
		}
		testActionBinding(
			name: .handleWatchKitExtensionRequest,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, handleWatchKitExtensionRequest: ["b": "c"], reply: callback) },
			validate: { tuple in
				tuple.callback.send(value: ["d": "e"])
				return result as? [String: String] == ["d": "e"] && tuple.value as? [String: String] == ["b": "c"]
			}
		)
	}
	func testPerformAction() {
		var result: Bool? = nil
		let callback = { (r: Bool) -> Void in
			result = r
		}
		testActionBinding(
			name: .performAction,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, performActionFor: UIApplicationShortcutItem(type: "a", localizedTitle: "b"), completionHandler: callback) },
			validate: { tuple in
				tuple.callback.send(value: true)
				return result == true && tuple.value.localizedTitle == "b"
		}
		)
	}
	func testPerformFetch() {
		var result: UIBackgroundFetchResult? = nil
		let callback = { (r: UIBackgroundFetchResult) -> Void in
			result = r
		}
		testActionBinding(
			name: .performFetch,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.application?($0, performFetchWithCompletionHandler: callback) },
			validate: { input in
				input.send(value: UIBackgroundFetchResult.noData)
				return result == .noData
			}
		)
	}
	func testProtectedDataDidBecomeAvailable() {
		testActionBinding(
			name: .protectedDataDidBecomeAvailable,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationProtectedDataDidBecomeAvailable?($0) },
			validate: { _ in true }
		)
	}
	func testProtectedDataWillBecomeUnavailable() {
		testActionBinding(
			name: .protectedDataWillBecomeUnavailable,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationProtectedDataWillBecomeUnavailable?($0) },
			validate: { _ in true }
		)
	}
	func testSignificantTimeChange() {
		testActionBinding(
			name: .significantTimeChange,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { NotificationCenter.default.post(Notification(name: UIApplication.significantTimeChangeNotification, object: $0)) },
			validate: { _ in true }
		)
	}
	func testWillEnterForeground() {
		testActionBinding(
			name: .willEnterForeground,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationWillEnterForeground?($0) },
			validate: { _ in true }
		)
	}
	func testWillResignActive() {
		testActionBinding(
			name: .willResignActive,
			constructor: appConstructor,
			skipReleaseCheck: true,
			trigger: { $0.delegate?.applicationWillResignActive?($0) },
			validate: { _ in true }
		)
	}

	// MARK: - 4. Delegate bindings
	
	func testContinueUserActivity() {
		var callbackCalled: Bool = false
		let callbackHandler = { (a: [UIUserActivityRestoring]?) -> Void in
			callbackCalled = true
		}
		var received: Callback<NSUserActivity, [UIUserActivityRestoring]?>? = nil
		let handler = { (r: Callback<NSUserActivity, [UIUserActivityRestoring]?>) -> Bool in
			received = r
			return true
		}
		testDelegateBinding(
			name: .continueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, continue: NSUserActivity(activityType: "asdf"), restorationHandler: callbackHandler) },
			validate: {
				received?.callback.send(value: [])
				return callbackCalled
			}
		)
	}
	func testDidDecodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		try! archiver.encodeEncodable("asdf", forKey: "qwer")
		
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Void in
			received = r
		}
		testDelegateBinding(
			name: .didDecodeRestorableState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { try! $0.delegate?.application?($0, didDecodeRestorableStateWith: NSKeyedUnarchiver(forReadingFrom: archiver.encodedData)) },
			validate: { try! (received as? NSKeyedUnarchiver)?.decodeTopLevelDecodable(String.self, forKey: "qwer") == "asdf" }
		)
	}
	func testDidFinishLaunching() {
		var received: [UIApplication.LaunchOptionsKey: Any]? = nil
		let handler = { (r: [UIApplication.LaunchOptionsKey: Any]?) -> Bool in
			received = r
			return true
		}
		testDelegateBinding(
			name: .didFinishLaunching,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, didFinishLaunchingWithOptions: [.url: URL(fileURLWithPath: "qwer")]) },
			validate: { received?[.url] as? URL == URL(fileURLWithPath: "qwer") }
		)
	}
	func testDidUpdate() {
		var received: NSUserActivity? = nil
		let handler = { (r: NSUserActivity) -> Void in
			received = r
		}
		testDelegateBinding(
			name: .didUpdate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, didUpdate: NSUserActivity(activityType: "xcvb")) },
			validate: { received?.activityType == "xcvb" }
		)
	}
	func testOpen() {
		var url: URL? = nil
		var options: [UIApplication.OpenURLOptionsKey: Any]? = nil
		let handler = { (u: URL, o: [UIApplication.OpenURLOptionsKey: Any]) -> Bool in
			url = u
			options = o
			return true
		}
		testDelegateBinding(
			name: .open,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, open: URL(fileURLWithPath: "asdf"), options: [UIApplication.OpenURLOptionsKey.annotation: "qwer"]) },
			validate: { url == URL(fileURLWithPath: "asdf") && options?[.annotation] as? String == "qwer" }
		)
	}
	func testShouldAllowExtensionPointIdentifier() {
		var received: UIApplication.ExtensionPointIdentifier? = nil
		let handler = { (r: UIApplication.ExtensionPointIdentifier) -> Bool in
			received = r
			return true
		}
		testDelegateBinding(
			name: .shouldAllowExtensionPointIdentifier,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, shouldAllowExtensionPointIdentifier: .keyboard) },
			validate: { received == .keyboard }
		)
	}
	func testShouldRequestHealthAuthorization() {
		var received: Bool = false
		let handler = { () -> Void in
			received = true
		}
		testDelegateBinding(
			name: .shouldRequestHealthAuthorization,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.applicationShouldRequestHealthAuthorization?($0) },
			validate: { received }
		)
	}
	func testShouldRestoreApplicationState() {
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Bool in
			received = r
			return true
		}
		testDelegateBinding(
			name: .shouldRestoreApplicationState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, shouldRestoreApplicationState: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received != nil }
		)
	}
	func testShouldSaveApplicationState() {
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Bool in
			received = r
			return true
		}
		testDelegateBinding(
			name: .shouldSaveApplicationState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, shouldSaveApplicationState: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received != nil }
		)
	}
	func testViewControllerWithRestorationPath() {
		var received: [String] = []
		let handler = { (_ path: [String], _ coder: NSCoder) -> UIViewController in
			received = path
			return UIViewController(nibName: nil, bundle: nil)
		}
		testDelegateBinding(
			name: .viewControllerWithRestorationPath,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, viewControllerWithRestorationIdentifierPath: ["asdf"], coder: NSKeyedArchiver(forWritingWith: NSMutableData())) },
			validate: { received == ["asdf"] }
		)
	}
	func testWillContinueUserActivity() {
		var received: String? = nil
		let handler = { (r: String) -> Bool in
			received = r
			return true
		}
		testDelegateBinding(
			name: .willContinueUserActivity,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willContinueUserActivityWithType: "asdf") },
			validate: { received == "asdf" }
		)
	}
	func testWillEncodeRestorableState() {
		let archiver = NSKeyedArchiver(requiringSecureCoding: false)
		var received: NSCoder? = nil
		let handler = { (r: NSCoder) -> Void in
			received = r
		}
		testDelegateBinding(
			name: .willEncodeRestorableState,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.application?($0, willEncodeRestorableStateWith: archiver) },
			validate: { received != nil }
		)
	}
	func testWillFinishLaunching() {
		var received: URL? = nil
		let handler = { (r: [UIApplication.LaunchOptionsKey: Any]?) -> Bool in
			received = r?[.url] as? URL
			return true
		}
		testDelegateBinding(
			name: .willFinishLaunching,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { _ = $0.delegate?.application?($0, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey.url: URL(fileURLWithPath: "asdf")]) },
			validate: { received == URL(fileURLWithPath: "asdf") }
		)
	}
	func testWillTerminate() {
		var received: Bool = false
		let handler = { () -> Void in
			received = true
		}
		testDelegateBinding(
			name: .willTerminate,
			constructor: appConstructor,
			skipReleaseCheck: true,
			handler: handler,
			trigger: { $0.delegate?.applicationWillTerminate?($0) },
			validate: { received }
		)
	}
	
}