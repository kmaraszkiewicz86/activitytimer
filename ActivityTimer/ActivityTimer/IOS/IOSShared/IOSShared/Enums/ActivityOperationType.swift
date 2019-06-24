//
//  ActivityOperationType.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 08/06/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

///Activity operation type to check what operation done on iphone and data is push to watchOS app.
public enum ActivityOperationType {
    ///The option for added operation on an activity, info about this will be push to watchOS app
    case added
    
    ///The option for updated operation on an activity, info about this will be push to watchOS app
    case updated
    
    ///The option for deleted operation on an activity, info about this will be push to watchOS app
    case deleted
}
