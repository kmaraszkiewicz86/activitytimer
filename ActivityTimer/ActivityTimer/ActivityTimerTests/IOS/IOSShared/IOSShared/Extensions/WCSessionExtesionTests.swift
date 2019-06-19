//
//  WCSessionExtesionTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 19/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import IOSShared
import WatchConnectivity
import XCTest

class WCSessionExtesionTests: XCTestCase {
    
    private var session: WCSessionExtensionMock?
    
    override func setUp() {
        self.session = WCSessionExtensionMock()
        WCSession.session = session
    }

    override func tearDown() {
        WCSession.session = nil
    }

    func test_initIOSSession_withValidState_shouldEnterToSessionAction() {
        
        //When
        let isEnterToActionMethod = doWork()
        
        //Then
        XCTAssert(isEnterToActionMethod, "Extension do not enter to session action")
    }
    
    func test_initIOSSession_withIsWatchAppInstalledSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isWatchAppInstalled = false
        
        //When
        let isEnterToActionMethod = doWork()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    func test_initIOSSession_withIsSupportedSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isSupported = false
        
        //When
        let isEnterToActionMethod = doWork()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    func test_initIOSSession_withIsPairedSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isPaired = false
        
        //When
        let isEnterToActionMethod = doWork()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    func test_initIOSSession_withIsReachableSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isReachable = false
        
        //When
        let isEnterToActionMethod = doWork()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    //MARK: Helper methods
    private func doWork() -> Bool {
        //Given
        var isEnterToActionMethod = false
        
        //When
        WCSession.initIOSSession(session: session) { (sess) in
            isEnterToActionMethod = true
        }
        
        return isEnterToActionMethod
    }
}
