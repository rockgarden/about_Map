// Copyright 2016 Swift Studies
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

/*
 How to use:
 Duration.startMeasurement("Tough Math")
 yourToughMathStuff()
 Duration.stopMeasurement()
 
 Duration.measure("Tough Math"){
 yourToughMathStuff()
 }
 
 Duration.measure("Tough Math", block: yourToughMathStuff)
 */

import Foundation

/// Definition of a block that can be used for measurements
public typealias MeasuredBlock = () -> Void

private var depth = 0

private var depthIndent: String {
    return String(count: depth, repeatedValue: "\t" as Character)
}

private var now: Double {
    return NSDate().timeIntervalSinceReferenceDate
}

/// Define different styles of reporting
public enum MeasurementLogStyle {
    /// Don't measure anything
    case None
    
    /// Log results of measurements to the console
    case Print
}

/// Provides static methods for performing measurements
public class Duration {
    private static var timingStack = [(startTime: Double, name: String, reported: Bool)]()
    
    private static var logStyleStack = [MeasurementLogStyle]()
    
    /// When you are releasing and want to turn off logging, and your library
    /// may be used by another, it is better to push/pop a logging state. This
    /// will ensure your settings do not impact those of other modules. By pushing
    /// your desired log style, and sub-sequently pop'ing before returning from
    /// your measured method only your desired measuremets will be logged.
    public static func pushLogStyle(style: MeasurementLogStyle) {
        logStyleStack.append(logStyle)
        logStyle = style
    }
    
    /// Pops the last pushed logging style and restores the logging style to
    /// its previous style
    public static func popLogStyle() {
        logStyle = logStyleStack.removeLast()
    }
    
    /// Set to control how measurements are reported. It is recommended to use
    /// `pushLogStyle` and `popLogStyle` if you intend to make your module
    /// available for others to use
    public static var logStyle = MeasurementLogStyle.Print
    
    /// Ensures that if any parent measurement boundaries have not yet resulted
    /// in output that their headers are displayed
    private static func reportContaining() {
        if logStyle != .None && depth > 0 {
            if logStyle == .Print {
                for stackPointer in 0..<timingStack.count {
                    let containingMeasurement = timingStack[stackPointer]
                    
                    if !containingMeasurement.reported {
                        print(String(count: stackPointer, repeatedValue: "\t" as Character) + "Measuring \(containingMeasurement.name):")
                        
                        timingStack[stackPointer] = (containingMeasurement.startTime, containingMeasurement.name, true)
                    }
                    
                }
            }
        }
    }
    
    /// Start a measurement, call `stopMeasurement` when you have completed your
    /// desired operations. The `name` will be used to identify this specific
    /// measurement. Multiple calls will nest measurements within each other.
    public static func startMeasurement(name: String) {
        if logStyle == .None {
            return
        }
        reportContaining()
        timingStack.append((now, name, false))
        
        depth += 1
    }
    
    /// Stops measuring and generates a log entry. Note if you wish to include
    /// additional information (for example, the number of items processed) then
    /// you can use the `stopMeasurement(executionDetails:String?)` version of
    /// the function.
    public static func stopMeasurement() -> Double {
        if logStyle == .None {
            return 0
        }
        return stopMeasurement(nil)
    }
    
    /// Prints a message, optionally with a time stamp (measured from the
    /// start of the current measurement.
    public static func log(message: String, includeTimeStamp: Bool = false) {
        if logStyle == .None {
            return
        }
        guard logStyle != .None else {
            return
        }
        reportContaining()
        
        if includeTimeStamp {
            let currentTime = now
            
            let timeStamp = currentTime - timingStack[timingStack.count - 1].startTime
            
            return print("\(depthIndent)\(message)  \(timeStamp.milliSeconds)ms")
        } else {
            return print("\(depthIndent)\(message)")
        }
    }
    
    /// Stop measuring operations and generate log entry.
    public static func stopMeasurement(executionDetails: String?) -> Double {
        if logStyle == .None {
            return 0
        }
        let endTime = now
        precondition(depth > 0, "Attempt to stop a measurement when none has been started")
        
        let beginning = timingStack.removeLast()
        
        depth -= 1
        
        let took = endTime - beginning.startTime
        
        if logStyle == .Print {
            print("\(depthIndent)\(beginning.name) took: \(took.milliSeconds)" + (executionDetails == nil ? "" : " (\(executionDetails!))"))
        }
        
        return took
    }
    
    ///
    /// Calls a particular block measuring the time taken to complete the block.
    ///
    public static func measure(name: String, block: MeasuredBlock) -> Double {
        if logStyle == .None {
            // Still call the block
            block()
            return 0
        }
        startMeasurement(name)
        block()
        return stopMeasurement()
    }
    
    ///
    /// Calls a particular block the specified number of times, returning the average
    /// number of seconds it took to complete the code. The time
    /// take for each iteration will be logged as well as the average time and
    /// standard deviation.
    public static func measure(name: String, iterations: Int = 10, forBlock block: MeasuredBlock) -> Double {
        if logStyle == .None {
            return 0
        }
        
        precondition(iterations > 0, "Iterations must be a positive integer")
        
        var total: Double = 0
        var samples = [Double]()
        
        if logStyle == .Print {
            print("\(depthIndent)Measuring \(name)")
        }
        
        for i in 0..<iterations {
            let took = measure("Iteration \(i+1)", block: block)
            
            samples.append(took)
            
            total += took
        }
        
        let mean = total / Double(iterations)
        
        if logStyle == .Print {
            
            var deviation = 0.0
            
            for result in samples {
                
                let difference = result - mean
                
                deviation += difference * difference
            }
            
            let variance = deviation / Double(iterations)
            
            print("\(depthIndent)\(name) Average", mean.milliSeconds)
            print("\(depthIndent)\(name) STD Dev.", variance.milliSeconds)
        }
        
        return mean
    }
}

private extension Double {
    var milliSeconds: String {
        return String(format: "%03.2fms", self * 1000)
    }
    
}