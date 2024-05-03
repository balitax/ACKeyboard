
//
//  ACKeyboard.swift
//  ACKeyboard
//
//  Created by Agus cahyono on 05/03/24.
//

import UIKit

/**
 Declare what should happen on what event and `start()` listening to keyboard events. Like so:
 
 ```
 let keyboard = ACKeyboard()
 
 func configureKeyboard() {
    keyboard
        .on(event: .didShow) { (options) in
            print("New Keyboard Frame is \(options.endFrame).")
        }
        .on(event: .didHide) { (options) in
            print("Keyboard frame is \(options.endFrame) when hide.")
        }
        .start()
}
```
 
 You _must_ call `start()` for callbacks to be triggered. Calling `stop()` on instance will stop callbacks from triggering, but callbacks themselves won't be dismissed, thus you can resume event callbacks by calling `start()` again.
 
 To remove all event callbacks, call `clear()`.
 */

public class ACKeyboard: NSObject {
    
    public struct ACKeyboardOptions {
        public let startKeyboardFrame: CGRect
        public let endKeyboardFrame: CGRect
    }
    
    public typealias ACKeyboardCallback = (ACKeyboardOptions) -> ()
    
    // Keyboard events that can happen. Translates directly to `UIKeyboard` notifications from UIKit.
    public enum ACKeyboardEvent {
        /// Event raised by UIKit's `.UIKeyboardWillShow`.
        case willShow
        
        /// Event raised by UIKit's `.UIKeyboardDidShow`.
        case didShow
        
        /// Event raised by UIKit's `.UIKeyboardWillShow`.
        case willHide
        
        /// Event raised by UIKit's `.UIKeyboardDidHide`.
        case didHide
    }
    
    internal var callbacks: [ACKeyboardEvent : ACKeyboardCallback] = [:]
    
    /// Declares ACKeyboard behavior. Pass a closure parameter and event to bind those two. Without calling `start()` none of the closures will be executed.
    ///
    /// - parameter event: Event on which callback should be executed.
    /// - parameter do: Closure of code which will be executed on keyboard `event`.
    /// - returns: `Self` for convenience so many `on` functions can be chained.
    @discardableResult
    public func on(event: ACKeyboardEvent, do callback: ACKeyboardCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    /// auto hide keyboard by tap superview in every UIViewController
    public func autoHideKeyboard(onTap view: UIView) -> Self {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        return self
    }
    
    /// Starts listening to events and calling corresponding events handlers.
    public func start() {
        let center = NotificationCenter.default
        
        for event in callbacks.keys {
            center.addObserver(self, selector: event.selector, name: event.notification, object: nil)
        }
    }
    
    /// Stops listening to keyboard events. Callback closures won't be cleared, thus calling `start()` again will resume calling previously set event handlers.
    public func stop() {
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    /// Clears all event handlers. Equivalent of setting `nil` for all events.
    public func clear() {
        callbacks.removeAll()
    }
    
    @objc func dismissKeyboard() {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        let topController = keyWindow?.rootViewController
        topController?.view.endEditing(true)
    }
    
    deinit {
        stop()
    }
}

// MARK: Keyboard Notification
extension ACKeyboard {
    
    internal func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable : Any]?) -> ACKeyboardOptions {
        var endKeyboardFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            endKeyboardFrame = value
        }
        
        var startKeyboardFrame = CGRect()
        if let value = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            startKeyboardFrame = value
        }
        return ACKeyboardOptions(startKeyboardFrame: startKeyboardFrame, endKeyboardFrame: endKeyboardFrame)
    }
    
    // MARK: - UIKit notification handling
    
    @objc internal func keyboardWillShow(note: Notification) {
        callbacks[.willShow]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    
    @objc internal func keyboardDidShow(note: Notification) {
        callbacks[.didShow]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    
    @objc internal func keyboardWillHide(note: Notification) {
        callbacks[.willHide]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
    
    @objc internal func keyboardDidHide(note: Notification) {
        callbacks[.didHide]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
    }
}

// MARK: ACKeyboardEvent
private extension ACKeyboard.ACKeyboardEvent {
    var notification: NSNotification.Name {
        get {
            switch self {
            case .willShow:
                return UIResponder.keyboardWillShowNotification
            case .didShow:
                return UIResponder.keyboardDidShowNotification
            case .willHide:
                return UIResponder.keyboardWillHideNotification
            case .didHide:
                return UIResponder.keyboardDidHideNotification
            }
        }
    }
    
    var selector: Selector {
        get {
            switch self {
            case .willShow:
                return #selector(ACKeyboard.keyboardWillShow(note:))
            case .didShow:
                return #selector(ACKeyboard.keyboardDidShow(note:))
            case .willHide:
                return #selector(ACKeyboard.keyboardWillHide(note:))
            case .didHide:
                return #selector(ACKeyboard.keyboardDidHide(note:))
            }
        }
    }
}

public extension CGFloat {
    var supportSafeArea: Self {
        if #available(iOS 11.0, *) {
            return UIDevice().hasNotch ? self - (UIApplication.shared.currentActiveWindow?.safeAreaInsets.bottom ?? 0.0) : self
        }
        
        return 0.0
    }
}

internal extension UIApplication {
    var currentActiveWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        }
        
        return UIApplication.shared.keyWindow
    }
}

internal extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.currentActiveWindow?.safeAreaInsets.bottom ?? 0 > 0
            return bottom
        }
        
        return false
    }
}
