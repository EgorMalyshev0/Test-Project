//
//  Debouncer.swift
//  TestProject
//
//  Created by Egor Malyshev on 13.12.2020.
//

import Foundation

class Debouncer {
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    
    var handler: (() -> Void)?
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        })
    }
    
    @objc private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else { return }
        handler?()
        handler = nil
    }
    
}
