//
//  ActivityServiceTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 21/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import XCTest
@testable import IOSShared

class ActivityServiceTests: XCTestCase {

    var sut: ActivityService!
    var coreDataManager: CoreDataManger!
    
    override func setUp() {
        coreDataManager = CoreDataManger()
        sut = ActivityService.shared(coreDataManager.mainContext)
    }

    override func tearDown() {
        coreDataManager = nil
        sut = nil
    }
}
