//
//  WCSessionExtesionTests.swift
//  ActivityTimerTests
//
//  Created by Krzysztof Maraszkiewicz on 19/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import WatchConnectivity
import XCTest

///Unit tests of WCSession extesion
class WCSessionExtesionTests: XCTestCase {
    
    ///The mock version of WCSession
    private var session: WCSessionExtensionMock?

    ///Set up required data
    override func setUp() {
        self.session = WCSessionExtensionMock()
        WCSession.session = session
    }

    //Clean data after each test
    override func tearDown() {
        WCSession.session = nil
    }

    ///Test of contructor with valid state should enter to session action
    func test_initIOSSession_withValidState_shouldEnterToSessionAction() {
        
        //When
        let isEnterToActionMethod = runTest()
        
        //Then
        XCTAssert(isEnterToActionMethod, "Extension do not enter to session action")
    }
    
    ///test of contructor with IsWatchAppInstalles set to false should not enter to session action
    func test_initIOSSession_withIsWatchAppInstalledSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isWatchAppInstalled = false
        
        //When
        let isEnterToActionMethod = runTest()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    ///test of contructor eith IsSupported set to false should not enter to session sction
    func test_initIOSSession_withIsSupportedSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isSupported = false
        
        //When
        let isEnterToActionMethod = runTest()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    ///test of contructor with IsPaired set to false should not enter to session action
    func test_initIOSSession_withIsPairedSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isPaired = false
        
        //When
        let isEnterToActionMethod = runTest()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    ///test of contructor with IsReachable set to false should not enter to session action
    func test_initIOSSession_withIsReachableSetToFalse_shouldNotEnterToSessionAction() {
        
        //Given
        self.session?.isReachable = false
        
        //When
        let isEnterToActionMethod = runTest()
        
        //Then
        XCTAssert(!isEnterToActionMethod, "Extension enter to session action")
        
    }
    
    //MARK: Helper methods
    ///Run test scenario required functionality and check if sut enters to SessionAction predicate
    private func runTest() -> Bool {
        //Given
        var isEnterToActionMethod = false
        
        //When
        WCSession.initIOSSession(session: session) { (sess) in
            isEnterToActionMethod = true
        }
        
        return isEnterToActionMethod
    }
}
