
import Foundation

var firstName: String = "Maral"
var lastName: String = "Baigoz"
var birthYear: Int = 2005
let currentYear: Int = 2025
var age: Int = currentYear - birthYear
var isStudent: Bool = true
var height: Double = 1.71
var favoriteEmoji: String = "🌸"

var hobby: String = "painting 🎨"
var numberOfHobbies: Int = 4
var favoriteNumber: Int = 7
var isHobbyCreative: Bool = true
var secondHobby: String = "reading 📚"
var thirdHobby: String = "traveling ✈️"

var futureGoals: String = "In the future, I want to become a professional iOS developer 👩‍💻"

var lifeStory: String = """
My name is \(firstName) \(lastName) \(favoriteEmoji).
I am \(age) years old, born in \(birthYear).
I am currently a student: \(isStudent).
My height is \(height) meters.
My favorite hobby is \(hobby), which is a creative hobby: \(isHobbyCreative).
I also enjoy \(secondHobby) and \(thirdHobby).
I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber).
\(futureGoals)
"""

print(lifeStory)
