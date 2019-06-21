//
//  ActivityModelTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 20/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

@testable import IOSShared
import UIKit
import XCTest

class ActivityModelTests: XCTestCase {

    var sut: ActivityModel!
    var nsCoderMock: NSCoderMock!
    
    override func setUp() {
        super.setUp()
        
        nsCoderMock = NSCoderMock()
    }

    override func tearDown() {
        
        super.tearDown()
        
        if sut != nil {
            self.sut = nil
        }
        
        self.nsCoderMock = nil
    }
    
    func test_initWithCoder_DecodeData() {
        
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
    
    func test_initWithCoder_withNilId_DecodeData() {
        
        //Given
        let activity = ActivityModel(name: "test1")
        
        self.nsCoderMock.name = activity.name
        
        //When
        self.sut = ActivityModel(coderMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(activity.id, sut.id)
        XCTAssertEqual(activity.name, sut.name)
    }
    
    func test_encode_encodeData() {
        
        //Given
        self.sut = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .added)
        
        testEncodedData(operationType: 1)
        
        self.sut = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .deleted)
        
        testEncodedData(operationType: 2)
        
        self.sut = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .updated)
        
        testEncodedData(operationType: 3)
    }
    
    func test_encode_withNilId_encodeData() {
        
        //Given
        self.sut = ActivityModel(name: "test1")
        
        testEncodedData(operationType: 0)
    }
    
    //MARK: helper methods
    private func testEncodedData (operationType: Int) {
        
        //When
        self.sut.encode(withMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(self.nsCoderMock.id, sut.id)
        XCTAssertEqual(self.nsCoderMock.name, sut.name)
        XCTAssertEqual(self.nsCoderMock.operationType, operationType)
        
    }
    
    private func testDecodedData (activity: ActivityModel) {
        
        //When
        self.sut = ActivityModel(coderMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(activity.id, sut.id)
        XCTAssertEqual(activity.name, sut.name)
        XCTAssertEqual(activity.operationType, sut.operationType)
        
    }
}
