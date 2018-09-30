//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 DeclarativeHub/Bond
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#if os(iOS) || os(tvOS)

import ReactiveKit
import UIKit

extension SignalProtocol {

    /// Fires an event on start and every `interval` seconds as long as the app is in foreground.
    /// Pauses when the app goes to background. Restarts when the app is back in foreground.
    public static func heartbeat(interval seconds: Double) -> Signal<Void, NoError> {
        #if swift(>=4.2)
        let willEnterForegroundName = UIApplication.willEnterForegroundNotification
        let didEnterBackgorundName = UIApplication.didEnterBackgroundNotification
        #else
        let willEnterForegroundName = NSNotification.Name.UIApplicationDidEnterBackground
        let didEnterBackgorundName = NSNotification.Name.UIApplicationDidEnterBackground
        #endif
        
        let willEnterForeground = NotificationCenter.default.reactive.notification(name: willEnterForegroundName)
        let didEnterBackgorund = NotificationCenter.default.reactive.notification(name: didEnterBackgorundName)
        return willEnterForeground.replace(with: ()).start(with: ()).flatMapLatest { () -> Signal<Void, NoError> in
            return Signal<Int, NoError>.interval(seconds, queue: .global()).replace(with: ()).start(with: ()).take(until: didEnterBackgorund)
        }
    }
}
#endif
