//
//  MockClock.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 3/12/2025.
//

@testable import ArtemPoluyanovichSample
import Clocks

// MARK: - TestClock
/// Simple test clock that records sleep calls
/// Uses ImmediateClock as a base to avoid swift-dependencies issues
/// Note: @unchecked Sendable is safe as it is used only in tests
final class MockClock: @unchecked Sendable {
    var sleepCallCount = 0
    var sleepDurations: [Duration] = []
    private var currentInstant: UInt64 = 0
    
    func clock() -> any Clock<Duration> {
        ClockWrapper(mock: self)
    }
    
    /// Simple Clock wrapper that does not use ContinuousClock directly
    private struct ClockWrapper: Clock {
        typealias Duration = Swift.Duration
        
        struct Instant: InstantProtocol {
            var offset: Duration
            
            static var zero: Instant { Instant(offset: .zero) }
            
            func advanced(by duration: Duration) -> Instant {
                Instant(offset: offset + duration)
            }
            
            func duration(to other: Instant) -> Duration {
                other.offset - offset
            }
            
            static func < (lhs: Instant, rhs: Instant) -> Bool {
                lhs.offset < rhs.offset
            }
        }
        
        let mock: MockClock
        
        var minimumResolution: Duration { .zero }
        
        var now: Instant {
            Instant(offset: .nanoseconds(Int64(mock.currentInstant)))
        }
        
        func sleep(until deadline: Instant, tolerance: Duration?) async throws {
            let currentNow = now
            let duration = currentNow.duration(to: deadline)
            mock.sleepCallCount += 1
            mock.sleepDurations.append(duration)
            // Update time so that the next now is after sleep
            mock.currentInstant += UInt64(duration.components.seconds * 1_000_000_000)
            mock.currentInstant += UInt64(duration.components.attoseconds / 1_000_000_000)
            // Do not perform real sleep — tests run instantly
        }
    }
}
