//
//  SearchRequestValidator.swift
//  TestProject
//
//  Created by Egor Malyshev on 22.04.2021.
//

import Foundation

struct SearchRequestValidator {
    
    func validate(_ request: String) -> String {
        let transformedRequest = request.applyingTransform(.toLatin, reverse: false)
        return (transformedRequest != nil) ? transformedRequest! : request
    }
}

