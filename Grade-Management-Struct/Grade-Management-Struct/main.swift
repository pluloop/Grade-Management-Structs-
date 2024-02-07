//
//  main.swift
//  Grade-Management
//
//  Created by StudentAM on 1/23/24.
//

import Foundation // to use swift
import CSV // for file with names / grades

// to store data of student, used in printing
struct Student{
    var allGrades: [String]
    var name: String
    var finalGrade: Double
}

var students: [Student] = []

// to compute average grade and display
func averageGrade(){
    var name: String = ""
    var average: Double = 0.0// to display later (average grade)
    var position: Int = 0 // to get grade of name from finalGrades
    
    print("Which student would you like to choose?")
    if let student = readLine(){
        for user in students{
            position += 1
            if user.name.lowercased() == student.lowercased(){
                name = user.name
                average = user.finalGrade
                break
            }
        }
    }
    if name == ""{ // if name invalid, retype name
        print("Choose again bru.. use a usable name.")
        averageGrade()
    }else{ // if name valid print
        print("\(name)'s grade in class is \(String(format: "%.2f", average))\n")
    }
}

// to fill everyoneGrades and finalGrades list and names list
func manageData(studentData: [String]){
    var student: Student = Student(allGrades: [], name: "", finalGrade: 0.0) // to store list of grades of 1 (add to list of everyone's grade later)
    var total = 0.0 // operand to compute average
    var sum = 0.0 // operand to compute average
    
    for i in studentData.indices{
        if i == 0{
            student.name = studentData[i] // for printing name of student later
        }else{
            student.allGrades.append(studentData[i]) // for printing all grades of student later
            if let grade = Double(studentData[i]) // computing operands of average
            {
                sum += grade
                total += 1.0
            }
        }
    }
    student.finalGrade = (sum / total) // store 1 person's average in list
    students.append(student) // to organize students
}

// to read file
do{
    let file = InputStream(fileAtPath: "/Users/studentam/Desktop/swift/Grade-Management/Grade-Management/grades.csv")
    let csv = try CSVReader(stream: file!)
    while let row = csv.next(){
        manageData(studentData: row)
    }
}catch{
    print("There was an error trying to read the file!")
}

// to print 1 person's grades (ALL)
func allGrades(){
    var name = ""
    var grades = ""
    
    print("Which student would you like to choose?")
    if let student = readLine(){
        for user in students{
            if user.name.lowercased() == student.lowercased(){ // checks if name in list
                name = user.name
                for grade in user.allGrades{
                    if grade != user.allGrades[user.allGrades.count-1]{ // to not have comma @ end
                        grades += grade + ", "
                    }else{
                        grades += grade
                    }
                }
            }
        }
    }
    if name == ""{ // if name invalid, ask again
        print("Name not found. Choose again.")
        allGrades()
    }else{ // if name valid, print
        print("\(name)'s grades for this class are:\n\(grades)\n")
    }
}

// print everyone's grades (ALL)
func everyoneAllGrades(){
    var grades = "" // to format
    
    for name in students{
        for grade in name.allGrades{
            if grade != name.allGrades[name.allGrades.count-1]{ // to not have commas @ end
                grades += grade + ", "
            }else{
                grades += grade
            }
        }
        print("\(name.name) grades are: \(grades)\n")
        grades = "" // reset for next person
    }
}

// to print class average
func classAverage(){
    // operands for average
    var sum = 0.0
    var total = 0.0
    
    for name in students{ // computing operands
            sum += name.finalGrade
            total += 1.0
    }
    
    print("The class average is: \(sum / total)\n")
}

// to find average of certan assignment
func assignmentAverage(){
    var assignmentNum = -1 // to store what assignment to find average
    var sum = 0.0 // operand of average
    var total = 0.0 // operand of average
    
    print("Which assignent would you like to get the average of (1-10):")
    if let numStr = readLine(), let numInt: Int = Int(numStr), numInt >= 1 && numInt <= 10{ // checks if assignment input valid
        assignmentNum = numInt
        for name in students{
            if let grade: Double = Double(name.allGrades[numInt-1]){ // fill operands if assignment is input
                sum += grade
                total += 1.0
            }
        }
        print("The average for assignment #\(assignmentNum) is \(sum / total)\n") // print if valid
    }else{
        print("Assignment does not exist. Choose again.") // reenter if invalid
        assignmentAverage()
    }
}

// to find lowest grade
func lowestGrade(){
    var lowest = students[0].finalGrade // to have minimum value
    var name = "" // to print name of lowest grade person
    
    for student in students{ // iterate through list
        let grade = student.finalGrade
        if grade < lowest{ // to change lowest if any number is lower
            lowest = grade
            name = student.name
        }
    }
    
    print("\(name) is the student with the lowest grade: \(lowest)\n")
}
// to find highest grade
func highestGrade(){
    var highest = students[0].finalGrade // to have minimum value
    var name = "" //t o print name of highest grade person
    
    for student in students{ // iterate through list
        let grade = student.finalGrade
        if grade > highest{ // to change highest if any number is lower
            highest = grade
            name = student.name
        }
    }
    
    print("\(name) is the student with the highest grade: \(highest)\n")
}

// to show names and grades of people with certain grade range
func filterGrades(){
    var filteredList = "" // to store formatted string with names and grades in certain range (print later)
    
    print("Enter the low range you would like to use:")
    if let minFilterStr = readLine(), let minFilterInt: Double = Double(minFilterStr){ // input min
        print("Enter the high range you would like to use:")
        if let maxFilterStr = readLine(), let maxFilterInt: Double = Double(maxFilterStr){ // input max
            for student in students{ // iterate grades to find range
                if student.finalGrade >= minFilterInt && student.finalGrade <= maxFilterInt{ // if in range, add to formatted string
                    filteredList += "\(student.name): \(student.finalGrade)\n"
                }
            }
        }
    }
    
    print(filteredList)
}

// to allow user to execute certain activities
func mainMenu(){
    print("""
Welcome to the Grade Manager!
What would you like to do? (Enter the number):
1. Display grade of a single student
2. Display all grades for a student
3. Display all grades of ALL students
4. Find the average grade of the class
5. Find the average grade of an assignment
6. Find the lowest grade in the class
7. Find the highest grade of the class
8. Filter students by grade range
9. Quit
""")
    
    if let userInput = readLine(){
        switch userInput{
        case "1":
            averageGrade() // find average
            mainMenu()
        case "2":
            allGrades() // display 1 person's grades
            mainMenu()
        case "3":
            everyoneAllGrades() // display everyone's grades
            mainMenu()
        case "4":
            classAverage() // display class average
            mainMenu()
        case "5":
            assignmentAverage() // find average of 1 assignment
            mainMenu()
        case "6":
            lowestGrade() // find lowest average
            mainMenu()
        case "7":
            highestGrade() // find highest average
            mainMenu()
        case "8":
            filterGrades() // print names and grades of certain grade ranges
            mainMenu()
        case "9":
            print("Have a great rest of your day!") // exit out of program
        default:
            print("Bruh.. Open eyes and select right option smh") // reeneter (wrong option chosen)
            mainMenu()
        }
    }
}

mainMenu() // start
