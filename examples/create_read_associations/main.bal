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

// import ballerina/http;
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

final hsassociations:Client hubspotAssociations = check new (config);

public function main() returns error? {

    // create default association between deals and companies
    hsassociations:BatchResponsePublicDefaultAssociation createDefaultResponse = check hubspotAssociations->/associations/["deals"]/["companies"]/batch/associate/default.post(
        payload = {
            inputs: [
                {
                    'from: {id: "41479955131"},
                    to: {id: "38056537829"}
                }
            ]
        }
    );

    io:println("\nCreate default associations response : \n",createDefaultResponse.toJson());

    // create custom asspcoation between deals and companies
    hsassociations:BatchResponseLabelsBetweenObjectPair createCustomResponse = check hubspotAssociations->/associations/["deals"]/["companies"]/batch/create.post(
        payload = {inputs: [
            {
                'from: {id: "41479955131"},
                to: {id: "38056537805"},
                types: [
                    {
                        associationCategory: "USER_DEFINED",
                        associationTypeId: 9
                    }
                ]
            }
        ]}
    );

    io:println("\nCreate custom associations response : \n",createCustomResponse.toJson());

    // read associations of a deal
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse = check hubspotAssociations->/objects/["deals"]/["41479955131"]/associations/["companies"].get();

    io:println("\nAll created associations for deals(41479955131) with companies response : \n",readResponse);
}
