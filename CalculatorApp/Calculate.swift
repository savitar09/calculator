//
//  Calculate.swift
//  CalculatorApp
//
//  Created by Tuan SPK on 5/4/18.
//  Copyright © 2018 Tuan SPK. All rights reserved.
//

import Foundation

func factorial(of factorialNumber: Double) -> Double {
    if factorialNumber == 0 {
        return 1
    }
    return factorialNumber * factorial(of: factorialNumber - 1)
}

class Calculate {
    private var internalProgram = [String]()
    
    private var accumulator: Double?
    private var descriptionAccumulator = ""
    
    private var beforeParenthesisProgram = [Any]()
    private var beforeParenthesisDescriptionAccumulator: [Any] = []
    
    private var beforeBinaryOperationProgram = [PendingBinaryOperationInfo]()
    private var beforeBinaryOperationDescriptionAccumulator: [String] = []
    
    private var pending: PendingBinaryOperationInfo?
    private struct PendingBinaryOperationInfo {
        var binaryFuntction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: ((String, String) -> String)?
        var descriptionOperand: String?
        var priority: Int
    }
    
    var resultIsPending: Bool {
        get {
            return pending != nil || !beforeParenthesisProgram.isEmpty || !beforeParenthesisDescriptionAccumulator.isEmpty || !beforeBinaryOperationProgram.isEmpty
        }
    }
    
    var description: String {
        get {
            if resultIsPending && pending != nil, pending!.descriptionFunction != nil && pending!.descriptionOperand != nil {
                print("beforeBinaryOperationDescriptionAccumulator: \(beforeBinaryOperationDescriptionAccumulator)")
                let conditionalDescriptionAccumulator = pending!.descriptionOperand != descriptionAccumulator && pending?.descriptionOperand != "(\(descriptionAccumulator))" ? descriptionAccumulator : ""
                //
                let beforeParenthesis = beforeParenthesisDescriptionAccumulator.reduce("") {
                    var toAdd = ""
                    if let savedPendingOperations = $1 as? [String] {
                        toAdd = savedPendingOperations.reduce("") {$0 + $1}
                    } else {
                        toAdd = $1 as! String
                    }
                    return $0 + toAdd
                }
                print("count: \(beforeParenthesisDescriptionAccumulator.count)")
                print(beforeParenthesisDescriptionAccumulator)
                return beforeParenthesis + beforeBinaryOperationDescriptionAccumulator.reduce("") {$0 + $1} + pending!.descriptionFunction!(pending!.descriptionOperand!, conditionalDescriptionAccumulator)
            } else {
                print("beforeBinaryOperationDescriptionAccumulator: \(beforeBinaryOperationDescriptionAccumulator)")
                let beforeParenthesis = beforeParenthesisDescriptionAccumulator.reduce("") {
                    var toAdd = ""
                    if let savedPendingOperations = $1 as? [String] {
                        toAdd = savedPendingOperations.reduce("") {$0 + $1}
                    } else {
                        toAdd = $1 as! String
                    }
                    return $0 + toAdd
                }
                print("count: \(beforeParenthesisDescriptionAccumulator.count)")
                print(beforeParenthesisDescriptionAccumulator)
                return beforeParenthesis + beforeBinaryOperationDescriptionAccumulator.reduce("") {$0 + $1} + descriptionAccumulator
            }
        }
    }
    
    var useRadians: Bool = false {
        didSet {
            if useRadians {
                operations.updateValue(Operation.unaryOperations(function: sin, discriptionalFunction: {"sin(rad:\($0))"}, parenthesisByDefault: true), forKey: "sin")
                operations.updateValue(Operation.unaryOperations(function: cos, discriptionalFunction: {"cos(rad:\($0))"}, parenthesisByDefault: true), forKey: "cos")
                
            } else {
                operations.updateValue(Operation.unaryOperations(function: {__sinpi($0 / 180)}, discriptionalFunction: {"sin(\($0))"}, parenthesisByDefault: true), forKey: "sin")
                operations.updateValue(Operation.unaryOperations(function: {__cospi($0 / 180)}, discriptionalFunction: {"cos(\($0))"}, parenthesisByDefault: true), forKey: "cos")
            }
        }
    }
    
    private enum Operation {
        case constant(Double)
        case constantGenerated(by: () -> Double)
        case unaryOperations(function: (Double) -> Double, discriptionalFunction: (String) -> String, parenthesisByDefault: Bool)
        case binaryOperation(function: (Double, Double) -> Double, discriptionalFunction: (String, String) -> String, priority: Int)
        case equals
        case openParenthesis
        case closeParenthesis
    }
    
    private var operations: [String: Operation] = [
        "%" : Operation.unaryOperations(function: {$0 / 100}, discriptionalFunction: {"\($0)%"}, parenthesisByDefault: false),
        "log₂" : Operation.unaryOperations(function: {log2($0)}, discriptionalFunction: {"log₂(\($0))"}, parenthesisByDefault: true),
        "sin" : Operation.unaryOperations(function: {__sinpi($0 / 180)}, discriptionalFunction: {"sin(\($0))"}, parenthesisByDefault: true),
        "cos" : Operation.unaryOperations(function: {__cospi($0 / 180)}, discriptionalFunction: {"cos(\($0))"}, parenthesisByDefault: true),
        "×" : Operation.binaryOperation(function: {$0 * $1}, discriptionalFunction: {"\($0) × \($1)"}, priority: 1),
        "÷" : Operation.binaryOperation(function: {$0 / $1}, discriptionalFunction: {"\($0) / \($1)"}, priority: 1),
        "+" : Operation.binaryOperation(function: {$0 + $1}, discriptionalFunction: {"\($0) + \($1)"}, priority: 0),
        "−" : Operation.binaryOperation(function: {$0 - $1}, discriptionalFunction: {"\($0) - \($1)"}, priority: 0),
        "=" : Operation.equals,
        "(" : Operation.openParenthesis,
        ")" : Operation.closeParenthesis
    ]
    
    var result: Double {
        get {
            return accumulator ?? 0
        }
    }
    
    func clear(all: Bool = true) {
        pending = nil
        if all {
            internalProgram.removeAll()
            beforeParenthesisProgram.removeAll()
            beforeParenthesisDescriptionAccumulator = []
            accumulator = nil
            descriptionAccumulator = ""
            beforeBinaryOperationProgram = []
            beforeBinaryOperationDescriptionAccumulator = []
        }
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        internalProgram.append("\(operand)")
        descriptionAccumulator = String(format: "%g", operand)
    }
    
    private func descriptionAccumulatorConditionallyWrapped(priority: Int? = nil) -> String {
        if !resultIsPending, (priority != nil ? priority! > 0 : true) {
            if Double(descriptionAccumulator) == nil {
                if internalProgram.count > 1 {
                    let secondLastProgramElement = internalProgram[internalProgram.count - 2]
                    if let secondElementFunction = operations[secondLastProgramElement], case .unaryOperations(_, _, _) = secondElementFunction {
                        if priority != nil {
                            return "\(descriptionAccumulator == "" ? "0" : descriptionAccumulator)"
                        }
                    }
                }
                
                if let firstCharacter = descriptionAccumulator.characters.first,
                    let lastCharacter = descriptionAccumulator.characters.last,
                    (String(firstCharacter) != "(" || String(lastCharacter) != ")") {
                    return "(\(descriptionAccumulator == "" ? "0" : descriptionAccumulator))"
                }
            }
        }
        return "\(descriptionAccumulator == "" ? "0" : descriptionAccumulator)"
    }
    
    private func executePendingBinaryOperation() {
        
        // Debug
        print("***executePendingBinaryOperations***")
        print("execute pending: \(pending) with accumulator: \(accumulator)")
        print("Description at execute Pending: \(descriptionAccumulator)")
        // End debug
        
        if let pending = self.pending {
            accumulator = pending.binaryFuntction(pending.firstOperand, accumulator!)
            if let descriptionOperand = pending.descriptionOperand, let descriptionFunction = pending.descriptionFunction {
                print("Description Function: \(dump(descriptionFunction))")
                print("Description Operand: \(descriptionOperand)")
                descriptionAccumulator = descriptionFunction(descriptionOperand, "\(descriptionAccumulator)")
            }
            self.pending = nil
        }
    }
    
    func performOperation(_ symbol: String) {
        internalProgram.append(symbol)
        
        // Debug
        print("***Perform Operation***")
        print("brain.internalProgram: \(internalProgram)")
        print("accumulator before Opeation: \(accumulator)")
        print("descriptionAccumulator: \(descriptionAccumulator)")
        print("pending? \(pending)")
        // End Debug
        
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .constantGenerated(let function):
                accumulator = function()
                descriptionAccumulator = symbol
            case .unaryOperations(let unaryFunction, let descriptionFunction, let parenthesisByDefault):
                if internalProgram.count > 2 {
                    let secondLastProgramElement = internalProgram[internalProgram.count - 2]
                    if let secondElementFunction = operations[secondLastProgramElement], case .binaryOperation(_, _, _) = secondElementFunction {
                        pending = nil
                        internalProgram.remove(at: internalProgram.count - 2)
                        debugPrint("Binary operation is followed by another operation, so binary operation will been removed")
                    }
                }
                self.accumulator = unaryFunction(accumulator ?? 0)
                print("unaryOperation Accumulator: \(self.accumulator)")
                descriptionAccumulator = descriptionFunction(parenthesisByDefault ? (descriptionAccumulator == "" ? "0" : descriptionAccumulator) : self.descriptionAccumulatorConditionallyWrapped())
            case .binaryOperation(let function, let descriptionFunction, let currentPriority):
                if internalProgram.count > 1 {
                    let secondLastProgramElement = internalProgram[internalProgram.count - 2]
                    if let secondElementFunction = operations[secondLastProgramElement], case .binaryOperation(_, _, _) = secondElementFunction {
                        pending?.binaryFuntction = function
                        pending?.descriptionFunction = descriptionFunction
                        pending?.priority = currentPriority
                        internalProgram.remove(at: internalProgram.count - 2)
                        debugPrint("Operation is followed by operation, so last operation has been ignored")
                        break
                    }
                }
                if let pending = pending, pending.priority < currentPriority {
                    print("1. beforeBinaryOperationDescriptionAccumulator: \(beforeBinaryOperationDescriptionAccumulator)")
                    beforeBinaryOperationDescriptionAccumulator.append(pending.descriptionFunction!(pending.descriptionOperand!, ""))
                    beforeBinaryOperationProgram.append(pending)
                    
                    print("2. beforeBinaryOperationDescriptionAccumulator: \(beforeBinaryOperationDescriptionAccumulator)")
                } else {
                    executePendingBinaryOperation()
                    if !beforeBinaryOperationProgram.isEmpty {
                        for index in 0..<beforeBinaryOperationProgram.count {
                            print("index: \(index)")
                            let savedPending = beforeBinaryOperationProgram.last!
                            if savedPending.priority < currentPriority {
                                break
                            }
                            accumulator = savedPending.binaryFuntction(savedPending.firstOperand, (accumulator ?? 0))
                            beforeBinaryOperationProgram.removeLast()
                            descriptionAccumulator = beforeBinaryOperationDescriptionAccumulator.removeLast() + descriptionAccumulator
                        }
                    }
                }
                pending = PendingBinaryOperationInfo(
                    binaryFuntction: function, firstOperand: accumulator ?? 0,
                    descriptionFunction: descriptionFunction, descriptionOperand: self.descriptionAccumulatorConditionallyWrapped(priority: currentPriority),
                    priority: currentPriority)
            case .equals:
                print("equals: \(internalProgram)")
                executePendingBinaryOperation()
                if !beforeBinaryOperationProgram.isEmpty {
                    let _ = beforeBinaryOperationProgram.reversed().map { accumulator = $0.binaryFuntction($0.firstOperand, accumulator!) }
                }
                descriptionAccumulator = beforeBinaryOperationDescriptionAccumulator.reduce("") {$0 + $1} + descriptionAccumulator
                beforeBinaryOperationDescriptionAccumulator.removeAll()
                beforeBinaryOperationProgram.removeAll()
                if !beforeParenthesisProgram.isEmpty {
                    internalProgram.removeLast()
                    performOperation(")")
                }
                
            case .openParenthesis:
                print("***.openParenthesis***")
                print("accumulator in parethesis: \(accumulator)")
                if internalProgram.count > 1 {
                    let secondLastProgramElement = internalProgram[internalProgram.count - 2]
                    var isBinaryOperation = false
                    if let parenthesisOperation = operations[secondLastProgramElement], case .binaryOperation(_, _, _) = parenthesisOperation {
                        isBinaryOperation = true
                    }
                    if secondLastProgramElement == "=" || isBinaryOperation {
                        if !beforeBinaryOperationProgram.isEmpty {
                            beforeParenthesisProgram.append( beforeBinaryOperationProgram as Any )
                            beforeBinaryOperationProgram.removeAll()
                            beforeParenthesisDescriptionAccumulator.append( beforeBinaryOperationDescriptionAccumulator )
                            beforeBinaryOperationDescriptionAccumulator.removeAll()
                        }
                        if let pending = pending, let pendingDescriptionFunction = pending.descriptionFunction, let pendingDescriptionOperand = pending.descriptionOperand {
                            beforeParenthesisProgram.append( self.pending as Any)
                            beforeParenthesisDescriptionAccumulator.append( pendingDescriptionFunction(pendingDescriptionOperand, "(") )
                        } else {
                            beforeParenthesisDescriptionAccumulator.append("(")
                        }
                        descriptionAccumulator = ""
                        pending = nil
                    } else {
                        internalProgram.removeLast()
                    }
                } else {
                    beforeParenthesisDescriptionAccumulator.append("(")
                }
                print("savedBeforeParenthesis: \(beforeParenthesisProgram)")
            case .closeParenthesis:
                if beforeParenthesisProgram.isEmpty && beforeParenthesisDescriptionAccumulator.isEmpty {
                    internalProgram.removeLast()
                    break
                }
                descriptionAccumulator += ")"
                executePendingBinaryOperation()
                if !beforeBinaryOperationProgram.isEmpty {
                    let _ = beforeBinaryOperationProgram.reversed().map { accumulator = $0.binaryFuntction($0.firstOperand, accumulator!) }
                    beforeBinaryOperationProgram.removeAll()
                    self.descriptionAccumulator = beforeBinaryOperationDescriptionAccumulator.reduce("") {$0 + $1} + self.descriptionAccumulator
                    beforeBinaryOperationDescriptionAccumulator.removeAll()
                }
                if !beforeParenthesisProgram.isEmpty && !beforeParenthesisDescriptionAccumulator.isEmpty {
                    if let beforeParenthesisPending = beforeParenthesisProgram.removeLast() as? PendingBinaryOperationInfo {
                        self.pending = beforeParenthesisPending
                        beforeParenthesisDescriptionAccumulator.removeLast()
                    }
                    if !beforeParenthesisProgram.isEmpty, let beforeParenthesisBinaryOperationProgram = beforeParenthesisProgram.removeLast() as? [PendingBinaryOperationInfo] {
                        self.beforeBinaryOperationProgram = beforeParenthesisBinaryOperationProgram
                        
                        if let beforeParenthesisBinaryOperationDescriptionAccumulator = beforeParenthesisDescriptionAccumulator.removeLast() as? [String] {
                            self.beforeBinaryOperationDescriptionAccumulator = beforeParenthesisBinaryOperationDescriptionAccumulator + self.beforeBinaryOperationDescriptionAccumulator
                        }
                    }
                    self.descriptionAccumulator = "(" + self.descriptionAccumulator
                } else if !beforeParenthesisDescriptionAccumulator.isEmpty, let beforeParenthesisDescription = beforeParenthesisDescriptionAccumulator.removeLast() as? String {
                    descriptionAccumulator = beforeParenthesisDescription + descriptionAccumulator
                }
            }
        }
        
        // Debug
        print("***End of Operation***")
        print("calculated accumulator: \(accumulator)")
        print("savedBeforeParenthesis: \(beforeParenthesisProgram)")
        print("internalProgram: \(internalProgram)")
        print("pending: \(pending)")
        print("descriptionAccumulator: \(descriptionAccumulator)")
        print("beforeBinaryOperationProgram: \(beforeBinaryOperationProgram.count)")
        print("result: \(result)")
        print("description: \(description)")
        print("*** ***\n\n")
        // End debug
    }
    
}
