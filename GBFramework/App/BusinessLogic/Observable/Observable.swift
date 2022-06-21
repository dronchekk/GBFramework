//
//  Observable.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import Combine

class Observable<T> {

    fileprivate class Callback {

        fileprivate weak var observer: AnyObject?
        fileprivate let options: [ObservableOptions]
        fileprivate let closure: (T, ObservableOptions) -> Void

        fileprivate init(observer: AnyObject, options: [ObservableOptions], closure: @escaping (T, ObservableOptions) -> Void) {
            self.observer = observer
            self.options = options
            self.closure = closure
        }
    }

    // MARK: - Properties
    var value: T {
        didSet {
            removeNilObserverCallbacks()
            notifyCallbacks(value: oldValue, option: .old)
            notifyCallbacks(value: value, option: .new)
        }
    }

    // MARK: - Lifecycle
    init(_ value: T) {
        self.value = value
    }

    // MARK: - Observe
    private var callbacks = [Callback]()

    func addObserver(_ observer: AnyObject,
                     removeIfExists: Bool = true,
                     options: [ObservableOptions] = [.new],
                     closure: @escaping (T, ObservableOptions) -> Void) {
        if removeIfExists {
            removeObserver(observer)
        }
        let callback = Callback(observer: observer, options: options, closure: closure)
        callbacks.append(callback)
        if options.contains(.initial) {
            closure(value, .initial)
        }
    }

    func removeObserver(_ observer: AnyObject) {
        callbacks = callbacks.filter({ $0.observer !== observer })
    }

    // MARK: - Private
    private func removeNilObserverCallbacks() {
        callbacks = callbacks.filter({ $0.observer != nil })
    }

    private func notifyCallbacks(value: T, option: ObservableOptions) {
        let callbacksToNotify = callbacks.filter({ $0.options.contains(option) })
        callbacksToNotify.forEach({ $0.closure(value, option) })
    }
}
