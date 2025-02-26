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
const string mockFromObjectId1 = "46989749974";
const string mockToObjectId1 = "43500581578";

public function main() returns error? {

    // create individual default association between deals and companies
    hsassociations:BatchResponsePublicDefaultAssociation createDefaultResponse = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId1]/associations/default/[mockToObjectType]/[mockToObjectId1].put();

    io:println("\nCreate individual default association between deals and companies response : \n", createDefaultResponse);

    // create individual association with label between deals and companies
    hsassociations:LabelsBetweenObjectPair createLabelResponse = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId1]/associations/[mockToObjectType]/[mockToObjectId1].put(
        payload = [{
                associationCategory: "USER_DEFINED",
                associationTypeId: 3
            }]
    );

    io:println("\nCreate individual association with label between deals and companies response : \n", createLabelResponse);

    // read association between deals and companies
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check readAssociation();
    io:println("\nRead association between deals and companies : \n", readResponse);

    // delete specific association between deals and companies
    http:Response _ = check hubspot->/associations/[mockFromObjectType]/[mockToObjectType]/batch/labels/archive.post(
        payload = {inputs: [
                {
                    types: [{
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 3
                        }],
                    'from: {
                        id: mockFromObjectId1
                    },
                    to: {
                        id: mockToObjectId1
                    }
                }
            
            ]}
    );

    // read association between deals and companies after deletion 
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponseAfterDeleteSpecific = check readAssociation();
    io:println("\nRead association between deals and companies after deletion associationTypeId=3 : \n", readResponseAfterDeleteSpecific);

    // delete all associations between deals and companies
    http:Response _ = check hubspot->/objects/[mockFromObjectType]/[mockFromObjectId1]/associations/[mockToObjectType]/[mockToObjectId1].delete();

    // read association between deals and companies after deletion all associations
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponseAfterDeleteAll = check readAssociation();
    io:println("\nRead association between deals and companies after deletion all associations : \n", readResponseAfterDeleteAll);
}

// read specific association between deals and companies
function readAssociation() returns hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging|error {
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check hubspot->/objects/[mockToObjectType]/[mockToObjectId1]/associations/[mockFromObjectType].get();
    return readResponse;
}
