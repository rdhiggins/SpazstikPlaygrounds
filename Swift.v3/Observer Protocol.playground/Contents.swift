// MIT License
//
// Copyright (c) 2016 Spazstik Software, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/// Protocol used as the base protocol type for a observer class
@objc protocol ObservableProtocol: class {}

protocol Observable {
    /// Observer is a generic type used for classes used as observers
    associatedtype Observer: ObservableProtocol

    /// observers is the array of references for the the registered observers
    /// to the class
    var observers: [Observer] { get set }

    /// Call this function to register the observer object.
    ///
    /// - parameter observer: A reference to a object that will get notifications
    mutating func add(observer: Observer)

    /// Call this function to de-register the observer object.
    ///
    /// - parameter observer: A reference to the object to de-register
    mutating func remove(observer: Observer)

    /// This method is call by the Observed object to call the passed block
    /// for each registered observer
    ///
    /// - parameter block: A block that is called for each registered observer
    func forEachObserver(_ block: (Observer) -> Void)
}

extension Observable {
    /// Call this function to register the observer object.
    ///
    /// - parameter observer: A reference to a object that will get notifications
    mutating func add(observer: Observer) {
        self.observers.append(observer)
    }


    /// Call this function to de-register the observer object.
    ///
    /// - parameter observer: A reference to the object to de-register
    mutating func remove(observer: Observer) {
        for (index, entry) in observers.enumerated() {
            if entry === observer {
                observers.remove(at: index)
                return
            }
        }
    }


    /// This method is call by the Observed object to call the passed block
    /// for each registered observer
    ///
    /// - parameter block: A block that is called for each registered observer
    func forEachObserver(_ block: (Observer) -> Void) {
        observers.forEach { (observer) in
            block(observer)
        }
    }
}



// Forces restriction on protocol so that it is limited to AnyObject
@objc protocol MyProtocol: ObservableProtocol {
    func didSayHello() -> String
}


class MyMainClass: Observable {
    var observers: [MyProtocol] = []

    init() {
        // Do initialization stuff
    }

    func thinking() {
        forEachObserver() { observer in
            print(observer.didSayHello())
        }
    }
}
var c = MyMainClass()





class MySpyClass: MyProtocol {

    init() {
        c.add(observer: self)
    }

    deinit {
        c.remove(observer: self)
    }

    func didSayHello() -> String {
        return "Hello"
    }

    func hello() {

    }
}
let s = MySpyClass()




class MySpyClass2: MyProtocol {

    init() {
        c.add(observer: self)
    }

    deinit {
        c.remove(observer: self)
    }

    func didSayHello() -> String {
        return "What's up"
    }

    func hello() {

    }
}
let s2 = MySpyClass2()


c.thinking()


