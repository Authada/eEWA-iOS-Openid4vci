/*
 * Copyright (c) 2024 AUTHADA GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  VerifierKA.swift
//

import Foundation
import JOSESwift

// Grant, conforming to Codable.
public struct VerifierKA: Codable {
    
    public let jwk: JWK
    
    enum CodingKeys: String, CodingKey {
        case jwk
    }
    
    public init(jwk: JWK) {
        self.jwk = jwk
    }
    
    public init(from decoder: Decoder) throws {
        fatalError("No supported yet")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let verifierJwk = jwk as? RSAPublicKey {
            try container.encode(verifierJwk, forKey: .jwk)
        } else if let verifierJwk = jwk as? ECPublicKey {
            try container.encode(verifierJwk, forKey: .jwk)
        }
    }
}
