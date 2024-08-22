/*
 * Copyright (c) 2023 European Commission
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
 *
 * Modified by AUTHADA GmbH
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
import Foundation

public struct AuthorizationType: Codable {
    public let type: String
    
    public init(type: String) {
        self.type = type
    }
}


public struct AuthorizationDetail: Encodable {
    public let type: String
    public let locations: [String]
    public let credentialConfigurationId: String
    
    public let claimsMdoc: MsoMdocClaims?
    public let claimsJWT: [String: Claim]?
    
    public init(
        type: AuthorizationType,
        locations: [String],
        credentialConfigurationId: String,
        claims: ClaimSet? = nil
    ) {
        self.type = type.type
        self.locations = locations
        self.credentialConfigurationId = credentialConfigurationId
        
        switch claims {
        case .msoMdoc(let mdocClaim):
            if let namespace = mdocClaim?.claims.first?.0 , let claimDict = mdocClaim?.claimDict(){
                
                claimsMdoc = [namespace: claimDict]
                claimsJWT = nil
            } else {
                claimsMdoc = nil
                claimsJWT = nil
            }
            
        case .sdJwtVc(let jwtClaim):
            claimsJWT = jwtClaim?.claims
            claimsMdoc = nil
        default:
            claimsJWT = nil
            claimsMdoc = nil
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.locations, forKey: .locations)
        try container.encode(self.credentialConfigurationId, forKey: .credentialConfigurationId)
        if let claims = self.claimsMdoc {
            try container.encode(claims, forKey: .claims)
        } else {
            try container.encodeIfPresent(self.claimsJWT, forKey: .claims)
        }
        
    }
    
    private enum CodingKeys: String,CodingKey {
        case type
        case locations
        case credentialConfigurationId = "credential_configuration_id"
        case claims
    }
}
