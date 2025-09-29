
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Check console for results")
            .onAppear {
                runAll()
            }
    }
}


func runAll() {
    problem1_FizzBuzz()
    problem2_Primes()
    problem3_TemperatureConverter()
    problem4_ShoppingList()
    problem5_WordFrequency()
    problem6_Fibonacci()
    problem7_Grades()
    problem8_Palindrome()
    problem9_Calculator()
    problem10_UniqueChars()
}
 
import Foundation

// -------------------------
// Problem 1: FizzBuzz
// -------------------------
func problem1_FizzBuzz() {
    print("\n--- Problem 1: FizzBuzz ---")
    for i in 1...100 {
        if i % 3 == 0 && i % 5 == 0 {
            print("FizzBuzz")
        } else if i % 3 == 0 {
            print("Fizz")
        } else if i % 5 == 0 {
            print("Buzz")
        } else {
            print(i)
        }
    }
}

// -------------------------
// Problem 2: Prime Numbers
// -------------------------
func isPrime(_ number: Int) -> Bool {
    if number < 2 { return false }
    for i in 2..<number {
        if number % i == 0 { return false }
    }
    return true
}

func problem2_Primes() {
    print("\n--- Problem 2: Prime Numbers ---")
    for i in 1...100 {
        if isPrime(i) {
            print(i, terminator: " ")
        }
    }
    print("")
}

// -------------------------
// Problem 3: Temperature Converter
// -------------------------
func celsiusToFahrenheit(_ c: Double) -> Double { return (c * 9/5) + 32 }
func celsiusToKelvin(_ c: Double) -> Double { return c + 273.15 }
func fahrenheitToCelsius(_ f: Double) -> Double { return (f - 32) * 5/9 }
func fahrenheitToKelvin(_ f: Double) -> Double { return (f + 459.67) * 5/9 }
func kelvinToCelsius(_ k: Double) -> Double { return k - 273.15 }
func kelvinToFahrenheit(_ k: Double) -> Double { return (k * 9/5) - 459.67 }

func problem3_TemperatureConverter() {
    print("\n--- Problem 3: Temperature Converter ---")
    let value = 25.0
    let unit = "C"
    if unit == "C" {
        print("\(value)°C = \(celsiusToFahrenheit(value))°F, \(celsiusToKelvin(value))K")
    } else if unit == "F" {
        print("\(value)°F = \(fahrenheitToCelsius(value))°C, \(fahrenheitToKelvin(value))K")
    } else if unit == "K" {
        print("\(value)K = \(kelvinToCelsius(value))°C, \(kelvinToFahrenheit(value))°F")
    }
}

// -------------------------
// Problem 4: Shopping List
// -------------------------
func problem4_ShoppingList() {
    print("\n--- Problem 4: Shopping List ---")
    var shoppingList: [String] = []
    shoppingList.append("Apples")
    shoppingList.append("Milk")
    shoppingList.append("Bread")
    print("Current list:", shoppingList)
    if let index = shoppingList.firstIndex(of: "Milk") {
        shoppingList.remove(at: index)
    }
    print("After removing Milk:", shoppingList)
}

// -------------------------
// Problem 5: Word Frequency Counter
// -------------------------
func problem5_WordFrequency() {
    print("\n--- Problem 5: Word Frequency ---")
    let sentence = "Hello world hello Swift world"
    let words = sentence.lowercased().split(separator: " ")
    var frequency: [String: Int] = [:]
    for word in words {
        frequency[String(word), default: 0] += 1
    }
    for (word, count) in frequency {
        print("\(word): \(count)")
    }
}

// -------------------------
// Problem 6: Fibonacci
// -------------------------
func fibonacci(_ n: Int) -> [Int] {
    if n <= 0 { return [] }
    if n == 1 { return [0] }
    if n == 2 { return [0, 1] }
    var seq = [0, 1]
    for i in 2..<n {
        seq.append(seq[i-1] + seq[i-2])
    }
    return seq
}

func problem6_Fibonacci() {
    print("\n--- Problem 6: Fibonacci ---")
    print(fibonacci(10))
}

// -------------------------
// Problem 7: Grade Calculator
// -------------------------
func problem7_Grades() {
    print("\n--- Problem 7: Grade Calculator ---")
    let students = ["Alice": 85, "Bob": 70, "Charlie": 95, "Diana": 60]
    let scores = Array(students.values)
    let average = Double(scores.reduce(0, +)) / Double(scores.count)
    let highest = scores.max() ?? 0
    let lowest = scores.min() ?? 0
    print("Average: \(average), High: \(highest), Low: \(lowest)")
    for (name, score) in students {
        print("\(name): \(score) → \(score >= Int(average) ? "Above" : "Below") average")
    }
}

// -------------------------
// Problem 8: Palindrome Checker
// -------------------------
func isPalindrome(_ text: String) -> Bool {
    let cleaned = text.lowercased().filter { $0.isLetter }
    return cleaned == String(cleaned.reversed())
}

func problem8_Palindrome() {
    print("\n--- Problem 8: Palindrome ---")
    print(isPalindrome("A man a plan a canal Panama")) // true
    print(isPalindrome("Hello")) // false
}

// -------------------------
// Problem 9: Simple Calculator
// -------------------------
func add(_ a: Double, _ b: Double) -> Double { a + b }
func subtract(_ a: Double, _ b: Double) -> Double { a - b }
func multiply(_ a: Double, _ b: Double) -> Double { a * b }
func divide(_ a: Double, _ b: Double) -> Double? { b == 0 ? nil : a / b }

func problem9_Calculator() {
    print("\n--- Problem 9: Calculator ---")
    let a = 10.0, b = 2.0
    print("Add:", add(a,b))
    print("Subtract:", subtract(a,b))
    print("Multiply:", multiply(a,b))
    print("Divide:", divide(a,b) ?? -1)
}

// -------------------------
// Problem 10: Unique Characters
// -------------------------
func hasUniqueCharacters(_ text: String) -> Bool {
    var seen: Set<Character> = []
    for c in text {
        if seen.contains(c) { return false }
        seen.insert(c)
    }
    return true
}

func problem10_UniqueChars() {
    print("\n--- Problem 10: Unique Characters ---")
    print("Swift:", hasUniqueCharacters("Swift")) // true
    print("Hello:", hasUniqueCharacters("Hello")) // false
}

------------------------




