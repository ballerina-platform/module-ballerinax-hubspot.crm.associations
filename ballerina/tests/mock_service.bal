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
import ballerina/log;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {

    # Deletes all associations between two records
    #
    # + return - returns can be any of following types 
    # http:NoContent (Returns `http:Response` with status **204 No Content** on success, indicating successful deletion.)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function delete objects/[string objectType]/[string objectId]/associations/[string toObjectType]/[string toObjectId]() returns http:NoContent|http:BadRequest|error {
        if objectType == mockToObjectType && objectId == mockToObjectId && toObjectType == mockFromObjectType && toObjectId == mockFromObjectId {
            return http:NO_CONTENT;
        } else {
            return http:BAD_REQUEST;
        }
    }

    # List Associations of an Object by Type
    #
    # + after - The paging cursor token of the last successfully read resource will be returned as the `paging.next.after` JSON property of a paged response containing more results.
    # + 'limit - The maximum number of results to display per page.
    # + return - returns can be any of following types 
    # http:Ok (successful operation)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function get objects/[string objectType]/[string objectId]/associations/[string toObjectType](string? after, int:Signed32 'limit = 500) returns CollectionResponseMultiAssociatedObjectWithLabelForwardPaging|error {
        if objectType == mockFromObjectType && objectId == mockFromObjectId && toObjectType == mockToObjectType {
            return {
                results: [
                    {
                        toObjectId: 38056537805,
                        associationTypes: [
                            {
                                category: "HUBSPOT_DEFINED",
                                typeId: 5,
                                label: "Primary"
                            },
                            {
                                category: "HUBSPOT_DEFINED",
                                typeId: 341,
                                label: null
                            }
                        ]
                    },
                    {
                        toObjectId: 38056537829,
                        associationTypes: [
                            {
                                category: "USER_DEFINED",
                                typeId: 9,
                                label: "d->c"
                            },
                            {
                                category: "HUBSPOT_DEFINED",
                                typeId: 341,
                                label: null
                            }
                        ]
                    }
                ]
            };
        } else {
            return error("Unable to infer object type from: " + objectType);
        }
    }

    # Removes Links Between Objects
    #
    # + return - returns can be any of following types 
    # http:NoContent (Returns `http:Response` with status **204 No Content** on success, indicating successful deletion.)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function post associations/[string fromObjectType]/[string toObjectType]/batch/archive(@http:Payload BatchInputPublicAssociationMultiArchive payload) returns http:NoContent|http:BadRequest|error {
        if fromObjectType == mockFromObjectType && toObjectType == mockToObjectType {
            return http:NO_CONTENT;
        } else {
            return http:BAD_REQUEST;
        }
    }

    # Creates a Default HubSpot-Defined Association
    #
    # + return - returns can be any of following types 
    # http:Ok (successful operation)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function post associations/[string fromObjectType]/[string toObjectType]/batch/associate/default(@http:Payload BatchInputPublicDefaultAssociationMultiPost payload) returns BatchResponsePublicDefaultAssociation|error {
        if fromObjectType == mockFromObjectType && toObjectType == mockToObjectType {
            return {
                status: "COMPLETE",
                results: [
                    {
                        'from: {
                            id: mockFromObjectId
                        },
                        to: {
                            id: mockToObjectId
                        },
                        associationSpec: {
                            associationCategory: "HUBSPOT_DEFINED",
                            associationTypeId: 341
                        }
                    }
                ],
                startedAt: "2025-02-16T06:38:42.797Z",
                completedAt: "2025-02-16T06:38:42.890Z"
            };
        } else {
            return error("Unable to infer object type from: " + fromObjectType);
        }
    }

    # Creates Custom Associations
    #
    # + return - returns can be any of following types 
    # http:Created (successful operation)
    # http:MultiStatus (multiple statuses)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function post associations/[string fromObjectType]/[string toObjectType]/batch/create(@http:Payload BatchInputPublicAssociationMultiPost payload) returns BatchResponseLabelsBetweenObjectPair|error {
        if fromObjectType == mockFromObjectType && toObjectType == mockToObjectType {
            return {
                status: "COMPLETE",
                results: [
                    {
                        fromObjectTypeId: "0-3",
                        fromObjectId: 46989749974,
                        toObjectTypeId: "0-2",
                        toObjectId: 43500581578,
                        labels: ["test-deal->company-1"]
                    }
                ],
                startedAt: "2025-02-18T08:53:51.080Z",
                completedAt: "2025-02-18T08:53:51.205Z"
            };
        } else {
            return error("Unable to infer object type from: " + fromObjectType);
        }
    }

    # Delete Specific Labels
    #
    # + return - returns can be any of following types 
    # http:NoContent (Returns `http:Response` with status **204 No Content** on success, indicating successful deletion.)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function post associations/[string fromObjectType]/[string toObjectType]/batch/labels/archive(@http:Payload BatchInputPublicAssociationMultiPost payload) returns http:NoContent|http:BadRequest|error {
        if fromObjectType == mockFromObjectType && toObjectType == mockToObjectType {
            return http:NO_CONTENT;
        } else {
            return http:BAD_REQUEST;
        }
    }

    # Read Associations
    #
    # + return - returns can be any of following types 
    # http:Ok (successful operation)
    # http:MultiStatus (multiple statuses)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function post associations/[string fromObjectType]/[string toObjectType]/batch/read(@http:Payload BatchInputPublicFetchAssociationsBatchRequest payload) returns BatchResponsePublicAssociationMultiWithLabel|error {
        return {
            status: "COMPLETE",
            results: [
                {
                    'from: {
                        id: "46989749974"
                    },
                    to: [
                        {
                            toObjectId: 43500581578,
                            associationTypes: [
                                {
                                    category: "HUBSPOT_DEFINED",
                                    typeId: 341,
                                    label: null
                                },
                                {
                                    category: "HUBSPOT_DEFINED",
                                    typeId: 5,
                                    label: "Primary"
                                }
                            ]
                        },
                        {
                            toObjectId: 38056537829,
                            associationTypes: [
                                {
                                    category: "HUBSPOT_DEFINED",
                                    typeId: 341,
                                    label: null
                                },
                                {
                                    category: "USER_DEFINED",
                                    typeId: 9,
                                    label: "d->c"
                                }
                            ]
                        }
                    ]
                }
            ],
            startedAt: "2025-02-17T11:08:16.755Z",
            completedAt: "2025-02-17T11:08:16.767Z"
        };
    }

    # Report
    #
    # + userId -
    # + return - returns can be any of following types 
    # http:Ok (successful operation)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function post associations/usage/high\-usage\-report/[int:Signed32 userId]() returns ReportCreationResponse|error {
        return {
            enqueueTime: {
                value: 1739687932759,
                dateOnly: false,
                timeZoneShift: 0
            },
            userId: userId,
            userEmail: "email@gmail.com"
        };
    }

    # Create Default Association Between Two Object Types
    #
    # + return - returns can be any of following types 
    # http:Ok (successful operation)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function put objects/[string fromObjectType]/[string fromObjectId]/associations/default/[string toObjectType]/[string toObjectId]() returns BatchResponsePublicDefaultAssociation|error {
        return {
            status: "COMPLETE",
            results: [
                {
                    'from: {
                        id: "46989749974"
                    },
                    to: {
                        id: "43500581578"
                    },
                    associationSpec: {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 341
                    }
                },
                {
                    'from: {
                        id: "38056537829"
                    },
                    to: {
                        id: "41479955131"
                    },
                    associationSpec: {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 342
                    }
                }
            ],
            startedAt: "2025-02-17T12:01:32.039Z",
            completedAt: "2025-02-17T12:01:32.070Z"
        };
    }

    # Create Association Labels Between Two Records
    #
    # + return - returns can be any of following types 
    # http:Created (successful operation)
    # http:DefaultStatusCodeResponse (An error occurred.)
    resource function put objects/[string objectType]/[string objectId]/associations/[string toObjectType]/[string toObjectId](@http:Payload AssociationSpec[] payload) returns LabelsBetweenObjectPair|error {
        return {
            fromObjectTypeId: "0-3",
            fromObjectId: 46989749974,
            toObjectTypeId: "0-2",
            toObjectId: 43500581578,
            labels: ["test-deal->company-1"]
        };
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skipping mock service initialization. Tests are configured to run against live server.");
        return;
    }
    log:printInfo("Tests are configured to run against mock server. Initializing mock service...");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
