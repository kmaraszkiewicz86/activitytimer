//
//  ServiceError.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 27/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

///The service error types used to rise error in action service
public enum ServiceError: Error {
    
    ///Database error could be rise wile using database service
    case databaseError
}