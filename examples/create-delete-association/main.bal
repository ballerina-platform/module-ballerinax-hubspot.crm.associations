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

import ballerina/http;
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
const string mockFromObjectId = "46989749974";
const string mockToObjectId = "43500581578";

public function main() returns error? {

    // create an individual default associations between a deal and a company
    hsassociations:BatchResponsePublicDefaultAssociation createDefaultResponse = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId]/associations/default/[mockToObjectType]/[mockToObjectId].put();

    io:println("\nCreate individual default associations between a deal and a company response : \n", createDefaultResponse);

    // create individual associations with label between a deal and a company
    hsassociations:LabelsBetweenObjectPair createLabelResponse = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId]/associations/[mockToObjectType]/[mockToObjectId].put(
        payload = [{
                associationCategory: "USER_DEFINED",
                associationTypeId: 3
            }]
    );

    io:println("\nCreate individual associations with label between a deal and a company response : \n", createLabelResponse);

    // read associations between deals and companies
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check readAssociations(mockFromObjectId);
    io:println("\nRead associations between deals and companies : \n", readResponse);

    // delete specific associations between deals and companies
    http:Response _ = check hubspot->/associations/[mockFromObjectType]/[mockToObjectType]/batch/labels/archive.post(
        payload = {inputs: [
                {
                    types: [{
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 3
                        }],
                    'from: {
                        id: mockFromObjectId
                    },
                    to: {
                        id: mockToObjectId
                    }
                }
            
            ]}
    );

    // read associations between deals and companies after deleting
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponseAfterDeleteSpecific = check readAssociations(mockFromObjectId);
    io:println("\nRead associations between deals and companies after deleting (associationTypeId=3) : \n", readResponseAfterDeleteSpecific);

    // delete all associations between a deal and a company
    http:Response _ = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId]/associations/[mockToObjectType]/[mockToObjectId].delete();

    // read associations between deals and companies after deleting all associations
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponseAfterDeleteAll = check readAssociations(mockFromObjectId);
    io:println("\nRead associations between deals and companies after deleting all associations : \n", readResponseAfterDeleteAll);
}

// read all associations between a deal and companies by object id
function readAssociations(string fromObjectId) returns hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging|error {
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check hubspot->/objects/[mockFromObjectType]/[fromObjectId]/associations/[mockToObjectType].get();
    return readResponse;
}
