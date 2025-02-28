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

configurable boolean isLiveServer = false;
configurable string clientId = "clientId";
configurable string clientSecret = "clientSecret";
configurable string refreshToken = "refreshToken";

const string FROM_OBJECT_TYPE = "deals";
const string TO_OBJECT_TYPE = "companies";
const string FROM_OBJECT_ID = "46989749974";
const string TO_OBJECT_ID = "43500581578";
const int:Signed32 USER_ID = 77406147;
const string INVALID_FROM_OBJECT_TYPE = "dea";
const string INVALID_TO_OBJECT_TYPE = "com";

final Client hubspotAssociations = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, "https://api.hubapi.com/crm/v4");
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, "http://localhost:9090");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"],
    dependsOn: [testCreateAssociationLabel, testCreateDefaultAssociation, testCreateCustomAssociation, testCreateDefaultAssociationType]
}
isolated function testGetAssociationsList() returns error? {
    CollectionResponseMultiAssociatedObjectWithLabelForwardPaging response = check hubspotAssociations->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE].get();
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one association, but found none.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"]
}
isolated function testCreateDefaultAssociation() returns error? {
    BatchResponsePublicDefaultAssociation response = check hubspotAssociations->/associations/[FROM_OBJECT_TYPE]/[TO_OBJECT_TYPE]/batch/associate/default.post(
        payload = {
            inputs: [
                {
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
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one default association to be created, but none were found.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"]
}
isolated function testCreateCustomAssociation() returns error? {
    BatchResponseLabelsBetweenObjectPair|BatchResponseLabelsBetweenObjectPairWithErrors response = check hubspotAssociations->/associations/[FROM_OBJECT_TYPE]/[TO_OBJECT_TYPE]/batch/create.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 1
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
    test:assertTrue(response.results.length() > 0,
            msg = "Expected at least one association to be created, but none were found.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"],
    dependsOn: [testCreateAssociationLabel, testCreateDefaultAssociation, testCreateCustomAssociation, testCreateDefaultAssociationType]
}
isolated function testReadAssociation() returns error? {
    BatchResponsePublicAssociationMultiWithLabel response = check hubspotAssociations->/associations/[FROM_OBJECT_TYPE]/[TO_OBJECT_TYPE]/batch/read.post(
        payload = {
            inputs: [
                {
                    id: FROM_OBJECT_ID
                }
            ]
        }
    );
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one association for the given object, but no associations were found.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"]
}
isolated function testReport() returns error? {
    ReportCreationResponse response = check hubspotAssociations->/associations/usage/high\-usage\-report/[USER_ID].post({});
    test:assertEquals(response.userId, USER_ID, msg = string `Expected userId to be ${USER_ID.toString()}, but got ${response.userId.toString()}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"]
}
isolated function testCreateDefaultAssociationType() returns error? {
    BatchResponsePublicDefaultAssociation response = check hubspotAssociations->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/default/[TO_OBJECT_TYPE]/[TO_OBJECT_ID].put({});
    test:assertTrue(response.results.length() > 0, msg = "Expected at least one default association to be created, but found none.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"]
}
isolated function testCreateAssociationLabel() returns error? {
    LabelsBetweenObjectPair response = check hubspotAssociations->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE]/[TO_OBJECT_ID].put(
        [
            {
                associationCategory: "USER_DEFINED",
                associationTypeId: 1
            }
        ]
    );
    test:assertEquals(response.fromObjectId.toString(), FROM_OBJECT_ID, msg = string `Expected toObjectId to be ${TO_OBJECT_ID.toString()} but got ${response.toObjectId.toString()}`);
    test:assertEquals(response.toObjectId.toString(), TO_OBJECT_ID, msg = string `Expected toObjectId to be ${TO_OBJECT_ID.toString()}, but got ${response.toObjectId.toString()}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"],
    dependsOn: [testGetAssociationsList, testReadAssociation]
}
isolated function testRemoveAssociationBetweenObject() returns error? {
    http:Response response = check hubspotAssociations->/associations/[FROM_OBJECT_TYPE]/[TO_OBJECT_TYPE]/batch/archive.post(
        payload = {
            inputs: [
                {
                    'from: {
                        id: FROM_OBJECT_ID
                    },
                    to: [
                        {
                            id: TO_OBJECT_ID
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
    groups: ["live_tests", "mock_tests", "positive_tests"],
    dependsOn: [testGetAssociationsList, testReadAssociation]
}
isolated function testDeleteSpecificLables() returns error? {
    http:Response response = check hubspotAssociations->/associations/[FROM_OBJECT_TYPE]/[TO_OBJECT_TYPE]/batch/labels/archive.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "HUBSPOT_DEFINED",
                            associationTypeId: 1
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
    test:assertEquals(response.statusCode, 204,
            msg = string `Expected status code 204 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests", "positive_tests"],
    dependsOn: [testGetAssociationsList, testReadAssociation]
}
isolated function testDeleteAllAssociations() returns error? {
    http:Response response = check hubspotAssociations->/objects/[FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[TO_OBJECT_TYPE]/[TO_OBJECT_ID].delete();
    test:assertEquals(response.statusCode, 204,
            msg = string `Expected status code 204 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests", "negative_tests"]
}
isolated function testGetAssociationsListByInvalidObjectType() returns error? {
    CollectionResponseMultiAssociatedObjectWithLabelForwardPaging|error response = hubspotAssociations->/objects/[INVALID_FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/invalidObjectType.get();
    test:assertTrue(response is error, msg = "Expected an error response, but got a successful response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "negative_tests"]
}
isolated function testCreateDefaultAssociationByInvalidObjectType() returns error? {
    BatchResponsePublicDefaultAssociation|error response = hubspotAssociations->/associations/[INVALID_FROM_OBJECT_TYPE]/[INVALID_TO_OBJECT_TYPE]/batch/associate/default.post(
        payload = {
            inputs: [
                {
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
    test:assertTrue(response is error, msg = "Expected an error response, but got a successful response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "negative_tests"]
}
isolated function testCreateCustomAssociationByInvalidObjectType() returns error? {
    BatchResponseLabelsBetweenObjectPair|BatchResponseLabelsBetweenObjectPairWithErrors|error response = hubspotAssociations->/associations/[INVALID_FROM_OBJECT_TYPE]/[INVALID_TO_OBJECT_TYPE]/batch/create.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 9
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
    test:assertTrue(response is error, msg = "Expected an error response, but got a successful response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests", "negative_tests"]
}
isolated function testDeleteSpecificLablesByInvalidObjectType() returns error? {
    http:Response response = check hubspotAssociations->/associations/[INVALID_FROM_OBJECT_TYPE]/[INVALID_TO_OBJECT_TYPE]/batch/labels/archive.post(
        payload = {
            inputs: [
                {
                    types: [
                        {
                            associationCategory: "USER_DEFINED",
                            associationTypeId: 9
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
    test:assertEquals(response.statusCode, 400,
            msg = string `Expected status code 400 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests", "negative_tests"]
}
isolated function testDeleteAllAssociationsByInvalidObjectType() returns error? {
    http:Response response = check hubspotAssociations->/objects/[INVALID_FROM_OBJECT_TYPE]/[FROM_OBJECT_ID]/associations/[INVALID_TO_OBJECT_TYPE]/[TO_OBJECT_ID].delete();
    test:assertEquals(response.statusCode, 400,
            msg = string `Expected status code 400 but got ${response.statusCode}`);
}

@test:Config {
    groups: ["live_tests", "mock_tests", "negative_tests"]
}
isolated function testRemoveAssociationBetweenObjectByInvalidObjectType() returns error? {
    http:Response response = check hubspotAssociations->/associations/[INVALID_TO_OBJECT_TYPE]/[INVALID_FROM_OBJECT_TYPE]/batch/archive.post(
        payload = {
            inputs: [
                {
                    'from: {
                        id: FROM_OBJECT_ID
                    },
                    to: [
                        {
                            id: TO_OBJECT_ID
                        }
                    ]
                }
            ]
        }
    );
    test:assertEquals(response.statusCode, 400,
            msg = string `Expected status code 400 but got ${response.statusCode}`);
}
