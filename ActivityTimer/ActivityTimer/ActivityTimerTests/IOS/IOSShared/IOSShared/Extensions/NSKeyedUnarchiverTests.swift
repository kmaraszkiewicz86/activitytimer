//
//  NSKeyedUnarchiverTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 16/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest
import IOSShared

///Ubit tests of NSKeyedArchiver extension
class NSKeyedArchiverTests: XCTestCase {

    ///The subject under tests
    var sut: NSKeyedArchiver?
    
    ///The mock version of NSKeyedArchiver class
    var nsKeyedArchiverMock: NSKeyedArchiverMock?

    ///Set up required data
    override func setUp() {

        self.nsKeyedArchiverMock = NSKeyedArchiverMock()

        NSKeyedArchiver.nsKeyedArchiver = self.nsKeyedArchiverMock

    }

    //Clean data after each test
    override func tearDown() {
        NSKeyedArchiver.nsKeyedArchiver = nil
    }

    ///test of encodeActivity method with valid state should return valid data
    func test_encodeActivity_withValidState_shouldReturnValidData() {

        //Given
        let expectedData = Data(base64Encoded: "test")
        nsKeyedArchiverMock!.data = expectedData
        
        //When
        let currentData = NSKeyedArchiver.encodeActivity(ActivityModel(id: URL(string: "test"), name: "test"), forKey: "test")

        //Then
        XCTAssertEqual(expectedData, currentData)
    }
}
