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

const string FROM_OBJECT_TYPE = "deals";
const string TO_OBJECT_TYPE = "companies";
const string FROM_OBJECT_ID = "46989749974";
const string TO_OBJECT_ID = "43500581578";

public function main() returns error? {

    // create an individual default associations between a deal and a company
    hsassociations:BatchResponsePublicDefaultAssociation createDefaultResponse = check hubspot->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/default/[TO_OBJECT_TYPE]/[TO_OBJECT_ID].put();

    io:println("\nCreate individual default associations between a deal and a company response : \n", createDefaultResponse);

    // create individual associations with label between a deal and a company
    hsassociations:LabelsBetweenObjectPair createLabelResponse = check hubspot->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE]/[TO_OBJECT_ID].put(
        payload = [
            {
                associationCategory: "USER_DEFINED",
                associationTypeId: 3
            }
        ]
    );

    io:println("\nCreate individual associations with label between a deal and a company response : \n", createLabelResponse);

    // read associations between deals and companies
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check hubspot->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE];
    io:println("\nRead associations between deals and companies : \n", readResponse);

    // delete specific associations between deals and companies
    error? res = check hubspot->/associations/[FROM_OBJECT_TYPE]/[TO_OBJECT_TYPE]/batch/labels/archive.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 3
                        }
                    ],
                    'from: {
                        id: FROM_OBJECT_ID
                    },
                    to: {
                        id: TO_OBJECT_ID
                    }
                }

            ]
        }
    );

    // read associations between deals and companies after deleting
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponseAfterDeleteSpecific = check hubspot->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE];
    io:println("\nRead associations between deals and companies after deleting (associationTypeId=3) : \n", readResponseAfterDeleteSpecific);

    // delete all associations between a deal and a company
    error? response = check hubspot->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE]/[TO_OBJECT_ID].delete();

    // read associations between deals and companies after deleting all associations
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponseAfterDeleteAll = check hubspot->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE];
    io:println("\nRead associations between deals and companies after deleting all associations : \n", readResponseAfterDeleteAll);
}
