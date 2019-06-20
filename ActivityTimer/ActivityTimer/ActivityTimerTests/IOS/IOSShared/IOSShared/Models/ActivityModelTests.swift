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
        let activity = ActivityModel(id: URL(string: "test1"), name: "test1", operationType: .added)
        
        self.nsCoderMock.id = activity.id
        self.nsCoderMock.name = activity.name
        self.nsCoderMock.operationType = "added"
        
        //When
        self.sut = ActivityModel(coderMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(activity.id, sut.id)
        XCTAssertEqual(activity.name, sut.name)
    }
    
    func test_initWithCoder_withNilId_DecodeData() {
        
        //Given
        let activity = ActivityModel(name: "test1")
        
        self.nsCoderMock.name = activity.name
        self.nsCoderMock.operationType = "added"
        
        //When
        self.sut = ActivityModel(coderMock: self.nsCoderMock)
        
        //Then
        XCTAssertEqual(activity.id, sut.id)
        XCTAssertEqual(activity.name, sut.name)
    }

}
