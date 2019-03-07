//
//  appoetry1Tests.swift
//  appoetry1Tests
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import XCTest

@testable import appoetry1

class UserServiceTests: XCTestCase {
    
    var userService: PUserService?
    
    override func setUp() {
        userService = DumbUserService()
        print("Setup code")
    }
    
    override func tearDown() {
        userService = nil
    }
    
    func testEmailIsValid() {
        XCTAssertTrue(EmailValidator.isValid(email: "abc@abc.lv"))
        XCTAssertTrue(EmailValidator.isValid(email: "a@a.lv"))
        XCTAssertTrue(EmailValidator.isValid(email: "abcabcab@abc.lv"))
        XCTAssertTrue(EmailValidator.isValid(email: ".mail@email.lv"))
        XCTAssertTrue(EmailValidator.isValid(email: ".@email.com"))
        XCTAssertTrue(EmailValidator.isValid(email: "abc@email.co.om"))

    }
    
    func testEmailIsNotValid() {
        XCTAssertFalse(EmailValidator.isValid(email: "@abc.lv"), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: "abc"), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: "abc@.lv"), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: "abc@abc.l"), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: "abc@"), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: ""), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: ".lv"), "Email is not valid")
//        XCTAssertFalse(EmailValidator.isValid(email: "abc@abc.lv."), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: "abc@abc@abc.lv"), "Email is not valid")
        XCTAssertFalse(EmailValidator.isValid(email: "abc@.email.co.om"), "Email is not valid")
    }
    
    func testExample2() {
        print("Test example2 called")
    }
}

class EmailValidator {
    class func isValid2(email: String) -> Bool {

        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }

    class func isValid(email: String) -> Bool {
        let before = email.components(separatedBy: "@")
        if email.count <= 15 && email.count >= 6 && email.contains("@") && before[1].contains(".") {
            let firstPart = before[0]
            if firstPart.count >= 1 {
                let wholeDomain = before[1].components(separatedBy: ".")
                let domain = wholeDomain[0]
                if domain.count >= 1 {
                    let lastPart = wholeDomain[1]
                    if lastPart.count >= 2 {
                        return true
                    } else { return false }
                } else { return false }
            } else { return false }
        } else { return false }
    }
}
