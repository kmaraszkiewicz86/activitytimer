//
//  ActivityModelTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit
import XCTest

///Unit tests of ActivityModel
class ActivityModelTests: XCTestCase {

    ///The subject under tests
    var sut: ActivityModel!
    
    ///The mock version of NSCoder class
    var nsCoderMock: NSCoderMock!
    
    ///Set up required data
    override func setUp() {
        super.setUp()
        
        nsCoderMock = NSCoderMock()
    }

    //Clean data after each test
    override func tearDown() {
        
        super.tearDown()
        
        if sut != nil {
            self.sut = nil
        }
        
        self.nsCoderMock = nil
    }
    
    ///test of contructor with coder parameter should decode data
    func test_initWithCoder_ShouldDecodeData() {
        
        //Given
        var activity = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .added)
        
        self.nsCoderMock.id = activity.id
        self.nsCoderMock.name = activity.name
        self.nsCoderMock.operationType = 1
        
        testDecodedData(activity: activity)
        
        //Given
        activity = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .deleted)
        
        self.nsCoderMock.id = activity.id
        self.nsCoderMock.name = activity.name
        self.nsCoderMock.operationType = 2
        
        testDecodedData(activity: activity)
        
        //Given
        activity = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .updated)
        
        self.nsCoderMock.id = activity.id
        self.nsCoderMock.name = activity.name
        self.nsCoderMock.operationType = 3
        
        testDecodedData(activity: activity)
    }
    
    ///test constructor with coder parameter with nil identifier should decode data
    func test_initWithCoder_withNilId_ShouldDecodeData() {
        
        //Given
        let activity = ActivityModel(name: "test1")
        
        self.nsCoderMock.name = activity.name
        
        //When
        self.sut = ActivityModel(coderMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(activity.id, sut.id)
        XCTAssertEqual(activity.name, sut.name)
    }
    
    ///test of encode method should encode data
    func test_encode_shouldEncodeData() {
        
        //Given
        self.sut = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .added)
        
        testEncodedData(operationType: 1)
        
        self.sut = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .deleted)
        
        testEncodedData(operationType: 2)
        
        self.sut = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .updated)
        
        testEncodedData(operationType: 3)
    }
    
    ///test of encode method with nil identifier sould encode data
    func test_encode_withNilId_shouldEncodeData() {
        
        //Given
        self.sut = ActivityModel(name: "test1")
        
        testEncodedData(operationType: 0)
    }
    
    //MARK: helper methods
    
    ///test encode data checking method
    private func testEncodedData (operationType: Int) {
        
        //When
        self.sut.encode(withMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(self.nsCoderMock.id, sut.id)
        XCTAssertEqual(self.nsCoderMock.name, sut.name)
        XCTAssertEqual(self.nsCoderMock.operationType, operationType)
        
    }
    
    ///test decode data checking method
    private func testDecodedData (activity: ActivityModel) {
        
        //When
        self.sut = ActivityModel(coderMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(activity.id, sut.id)
        XCTAssertEqual(activity.name, sut.name)
        XCTAssertEqual(activity.operationType, sut.operationType)
        
    }
}
