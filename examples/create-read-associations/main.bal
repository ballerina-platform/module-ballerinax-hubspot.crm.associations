// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations as hsassociations;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

hsassociations:ConnectionConfig config = {
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    }
};

final hsassociations:Client hubspot = check new (config);

const string mockFromObjectType = "deals";
const string mockToObjectType = "companies";
const string mockFromObjectId1 = "46989749974";
const string mockToObjectId1 = "43500581578";
const string mockFromObjectId2 = "46989749975";
const string mockToObjectId2 = "43626089171";


public function main() returns error? {

    // create multiple default association between deals and companies
    hsassociations:BatchResponsePublicDefaultAssociation createDefaultResponse = check hubspot->/associations/[mockFromObjectType]/[mockToObjectType]/batch/associate/default.post(
        payload = {
            inputs: [
                {
                    'from: {
                        id: mockFromObjectId1
                    },
                    to: {
                        id: mockToObjectId1
                    }
                },
                {
                    'from: {
                        id: mockFromObjectId2
                    },
                    to: {
                        id: mockToObjectId2
                    }
                }
            ]
        }
    );

    io:println("\nCreate default associations response : \n", createDefaultResponse);

    // create multiple association with custom label between deals and companies
    hsassociations:BatchResponseLabelsBetweenObjectPair createCustomResponse = check hubspot->/associations/[mockFromObjectType]/[mockToObjectType]/batch/create.post(
        payload = {
            inputs: [
                {
                    'from: {
                        id: mockFromObjectId1
                    },
                    to: {
                        id: mockToObjectId1
                    },
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 1
                        }
                    ]
                },
                {
                    'from: {
                        id: mockFromObjectId2
                    },
                    to: {
                        id: mockToObjectId2
                    },
                    types: [
                        {
                            associationCategory: "HUBSPOT_DEFINED",
                            associationTypeId: 341
                        }
                    ]
                }
            ]
        }
    );

    io:println("\nCreate custom associations response : \n", createCustomResponse, "\n");

    // read associations of a deal with companies (dealId = 46989749974)
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId1]/associations/[mockToObjectType].get();

    io:println(string `All created associations for deals(${mockFromObjectId1}) with companies response : `, readResponse, "\n");

    // read associations of a company with deals (companyId = 43500581578)
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse2 = check hubspot->/objects/[mockToObjectType]/[mockToObjectId1]/associations/[mockFromObjectType].get();

    io:println(string `All created associations for companies(${mockToObjectId1}) with deals response : `, readResponse2);
}
