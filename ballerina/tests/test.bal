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
import ballerina/oauth2;
import ballerina/test;

final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v4" : "http://localhost:9090";

configurable boolean isLiveServer = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final Client hubspotAssociations = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

final string mockFromObjectType = "deals";
final string mockToObjectType = "companies";
final string mockFromObjectId = "41479955131";
final string mockToObjectId = "38056537829";
final int:Signed32 mockUserId = 77406593;

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetAssociationsList() returns error? {
    CollectionResponseMultiAssociatedObjectWithLabelForwardPaging response = check hubspotAssociations->/objects/[mockFromObjectType]/[mockFromObjectId]/associations/[mockToObjectType].get();
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one association, but found none.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateDefaultAssociation() returns error? {
    BatchResponsePublicDefaultAssociation response = check hubspotAssociations->/associations/[mockFromObjectType]/[mockToObjectType]/batch/associate/default.post(
        payload = {
            inputs: [
                {
                    'from: {id: mockFromObjectId},
                    to: {id: mockToObjectId}
                }
            ]
        }
    );
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one default association to be created, but none were found.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateCustomAssociation() returns error? {
    BatchResponseLabelsBetweenObjectPair|BatchResponseLabelsBetweenObjectPairWithErrors response = check hubspotAssociations->/associations/[mockFromObjectType]/[mockToObjectType]/batch/create.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 9
                        }
                    ],
                    'from: {id: mockFromObjectId},
                    to: {id: mockToObjectId}
                }
            ]
        }
    );
    test:assertTrue(response.results.length() > 0,
            msg = "Expected at least one association to be created, but none were found.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testReadAssociation() returns error? {
    BatchResponsePublicAssociationMultiWithLabel response = check hubspotAssociations->/associations/[mockFromObjectType]/[mockToObjectType]/batch/read.post(
        payload = {
            inputs: [
                {
                    id: mockFromObjectId
                }
            ]
        }
    );
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one association for the given object, but no associations were found.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testReport() returns error? {
    ReportCreationResponse response = check hubspotAssociations->/associations/usage/high\-usage\-report/[mockUserId].post({});
    test:assertEquals(response.userId, mockUserId, msg = string `Expected userId to be ${mockUserId.toString()}, but got ${response.userId.toString()}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateDefaultAssociationType() returns error? {
    BatchResponsePublicDefaultAssociation response = check hubspotAssociations->/objects/[mockFromObjectType]/[mockFromObjectId]/associations/default/[mockToObjectType]/[mockToObjectId].put({});
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one default association to be created, but found none.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateAssociationLabel() returns error? {
    LabelsBetweenObjectPair response = check hubspotAssociations->/objects/[mockFromObjectType]/[mockFromObjectId]/associations/[mockToObjectType]/[mockToObjectId].put(
        [
            {
                "associationCategory": "USER_DEFINED",
                "associationTypeId": 9
            }
        ]
    );
    test:assertEquals(response.fromObjectId.toString(), mockFromObjectId, msg = string `Expected toObjectId to be ${mockToObjectId.toString()} but got ${response.toObjectId.toString()}`);
    test:assertEquals(response.toObjectId.toString(), mockToObjectId, msg = string `Expected toObjectId to be ${mockToObjectId.toString()}, but got ${response.toObjectId.toString()}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testRemoveAssociationBetweenObject() returns error? {
    http:Response response = check hubspotAssociations->/associations/[mockFromObjectType]/[mockToObjectType]/batch/archive.post(
        payload = {
            inputs: [
                {
                    'from: {id: mockFromObjectId},
                    to: [
                        {
                            id: mockToObjectId
                        }
                    ]
                }
            ]
        }
    );
    test:assertEquals(response.statusCode, 204,
            msg = string `Expected status code 204 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteSpecificLables() returns error? {
    http:Response response = check hubspotAssociations->/associations/[mockFromObjectType]/[mockToObjectType]/batch/labels/archive.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "HUBSPOT_DEFINED",
                            associationTypeId: 9
                        }
                    ],
                    'from: {id: mockFromObjectId},
                    to: {id: mockToObjectId}
                }
            ]
        }
    );
    test:assertEquals(response.statusCode, 204,
            msg = string `Expected status code 204 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteAllAssociations() returns error? {
    http:Response response = check hubspotAssociations->/objects/[mockToObjectType]/[mockToObjectId]/associations/[mockFromObjectType]/[mockFromObjectId].delete();
    test:assertEquals(response.statusCode, 204,
            msg = string `Expected status code 204 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetAssociationsListByInvalidObjectType() returns error? {
    CollectionResponseMultiAssociatedObjectWithLabelForwardPaging|error response = hubspotAssociations->/objects/["dea"]/[mockFromObjectId]/associations/invalidObjectType.get();
    test:assertTrue(response is error, msg = "Expected an error response, but got a successful response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateDefaultAssociationByInvalidObjectType() returns error? {
    BatchResponsePublicDefaultAssociation|error response = hubspotAssociations->/associations/["dea"]/["com"]/batch/associate/default.post(
        payload = {
            inputs: [
                {
                    'from: {id: mockFromObjectId},
                    to: {id: mockToObjectId}
                }
            ]
        }
    );
    test:assertTrue(response is error, msg = "Expected an error response, but got a successful response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateCustomAssociationByInvalidObjectType() returns error? {
    BatchResponseLabelsBetweenObjectPair|BatchResponseLabelsBetweenObjectPairWithErrors|error response = hubspotAssociations->/associations/["dea"]/["com"]/batch/create.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 9
                        }
                    ],
                    'from: {id: mockFromObjectId},
                    to: {id: mockToObjectId}
                }
            ]
        }
    );
    test:assertTrue(response is error, msg = "Expected an error response, but got a successful response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteSpecificLablesByInvalidObjectType() returns error? {
    http:Response response = check hubspotAssociations->/associations/["dea"]/["com"]/batch/labels/archive.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "HUBSPOT_DEFINED",
                            associationTypeId: 9
                        }
                    ],
                    'from: {id: mockFromObjectId},
                    to: {id: mockToObjectId}
                }
            ]
        }
    );
    test:assertEquals(response.statusCode, 400,
            msg = string `Expected status code 400 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteAllAssociationsByInvalidObjectType() returns error? {
    http:Response response = check hubspotAssociations->/objects/["com"]/["38056537829"]/associations/["dea"]/["41479955131"].delete();
    test:assertEquals(response.statusCode, 400,
            msg = string `Expected status code 400 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testRemoveAssociationBetweenObjectByInvalidObjectType() returns error? {
    http:Response response = check hubspotAssociations->/associations/["dea"]/["com"]/batch/archive.post(
        payload = {
            inputs: [
                {
                    'from: {id: mockFromObjectId},
                    to: [
                        {
                            id: mockToObjectId
                        }
                    ]
                }
            ]
        }
    );
        test:assertEquals(response.statusCode, 400,
                msg = string `Expected status code 400 but got ${response.statusCode}`);
}
