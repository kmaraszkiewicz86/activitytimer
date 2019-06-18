//
//  NSKeyedUnarchiverTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 16/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest
import IOSShared

class NSKeyedArchiverTests: XCTestCase {

    var sut: NSKeyedArchiver?
    var nsKeyedArchiverMock: NSKeyedArchiverMock?

    override func setUp() {

        self.nsKeyedArchiverMock = NSKeyedArchiverMock()

        NSKeyedArchiver.nsKeyedArchiver = self.nsKeyedArchiverMock

    }

    override func tearDown() {
        NSKeyedArchiver.nsKeyedArchiver = nil
    }

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
