//
//  LockingSystemTests.swift
//  LockingSystemTests
//
//  Created by Maryam AlJanobi on 9/16/17.
//  Copyright © 2017 UNH. All rights reserved.
//
import XCTest
import MapKit
import CoreLocation

@testable import LockingSystem

class LockingSystemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMap(){
        // Testing MapViewController ----------------------
        let map_vc = MapViewController()
        let initialLocation = CLLocation(latitude: 41.296486, longitude: -72.9613023)
        let currentLocation1 = CLLocation(latitude: 41.297486, longitude: -72.9613023)
        let currentLocation2 = CLLocation(latitude: 42.296486, longitude: -72.9613023)
        // Test distance between the initial and the current location
        XCTAssertFalse(map_vc.isOutsideSafeZone(loc1: initialLocation, loc2:currentLocation1))
        XCTAssertTrue(map_vc.isOutsideSafeZone(loc1: initialLocation,loc2: currentLocation2))
    }
    
    func testStatus(){
        // Testing StatusViewController ----------------------
        let status_vc = StatusViewController()
        // Test status
        XCTAssertFalse(status_vc.isLocked(status: "unlock"))
        XCTAssertTrue(status_vc.isLocked(status: "lock"))
        // Test Battery
        XCTAssertEqual(0, status_vc.batteryImage(value: 90))
        XCTAssertEqual(1, status_vc.batteryImage(value: 60))
        XCTAssertEqual(2, status_vc.batteryImage(value: 30))
        XCTAssertEqual(3, status_vc.batteryImage(value: 10))

    }
    func testSignup(){
        // Testing StatusViewController ----------------------
        let signup_vc = SignupViewController()
        // Test for valid email
        XCTAssertFalse(signup_vc.isValidEmail(email: "maryam"))
        XCTAssertFalse(signup_vc.isValidEmail(email: "maryam@"))
        XCTAssertFalse(signup_vc.isValidEmail(email: "maryam.com"))
        XCTAssertTrue(signup_vc.isValidEmail(email: "maryam@unh.edu"))
        XCTAssertTrue(signup_vc.isValidEmail(email: "maryam@gmail.com"))
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
