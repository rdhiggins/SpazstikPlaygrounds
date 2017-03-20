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


fileprivate class WeakReference<T> {
    var reference: T?

    init(_ reference: T) {
        self.reference = reference
    }
}


class Observers<T> {
    fileprivate var observers: [WeakReference<T>] = []

    func add(observer: T) {
        let wo = WeakReference(observer)

        observers.append(wo)
    }


    func update(_ block: (T) -> Void) {
        let list = observers

        list.map { wo in
            guard let o = wo.reference else { return }

            block(o)
        }
    }
}


protocol MyProtocol {
    func didThink()
}


class MyObservedClass {

    let observers = Observers<MyProtocol>()


    func think() {
        observers.update { $0.didThink() }
    }
}


class Observer1: MyProtocol {

    init() {}


    func didThink() {
        print("Observer1 did think")
    }
}


class Observer2: MyProtocol {

    init() {}

    func didThink() {
        print("Observer2 did think")
    }
}



let observed = MyObservedClass()
let o1 = Observer1()
let o2 = Observer2()

observed.observers.add(observer: o1)
observed.observers.add(observer: o2)

observed.think()

