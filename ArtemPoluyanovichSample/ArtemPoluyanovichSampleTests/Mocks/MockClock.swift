//
//  MockClock.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Clocks

final class MockClock: @unchecked Sendable {
    var sleepCallCount = 0
    var sleepDurations: [Duration] = []
    private let baseClock = ContinuousClock()
    
    func clock() -> any Clock<Duration> {
        ClockWrapper(mock: self, baseClock: baseClock)
    }
    
    private struct ClockWrapper: Clock {
        typealias Instant = ContinuousClock.Instant
        let mock: MockClock
        let baseClock: ContinuousClock
        var minimumResolution: ContinuousClock.Duration { baseClock.minimumResolution }
        
        var now: Instant { baseClock.now }
        
        func sleep(until deadline: Instant, tolerance: Instant.Duration?) async throws {
            let callTime = baseClock.now
            let duration = callTime.duration(to: deadline)
            mock.sleepCallCount += 1
            mock.sleepDurations.append(duration)
        }
    }
}
