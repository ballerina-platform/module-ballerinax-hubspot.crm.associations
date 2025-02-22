# Ballerina HubSpot CRM Associations connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.associations.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.associations.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.associations)

## Overview

[HubSpot](https://developers.hubspot.com) is an AI-powered customer relationship management (CRM) platform.

The `ballerinax/hubspot.crm.associations` offers APIs to connect and interact with the [HubSpot Association Details API](https://developers.hubspot.com/docs/reference/api/crm/associations/association-details) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api).

## Setup guide

To use the HubSpot Association details connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Login to the HubSpot developer account

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

### Step 2 (Optional): Create a Developer Test Account

Within app developer accounts, you can create a [developer test account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account to test apps and integrations without affecting any real HubSpot data.

> **Note:** These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to the Test accounts section from the left sidebar.
   ![Test accounts section](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/test_account.png)

2. Click on the `Create developer test account` button on the top right corner.
   ![Create developer test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/create_test_account.png)

3. In the pop-up window, provide a name for the test account and click on the `Create` button.
   ![Create test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/create_account.png)
   You will see the newly created test account in the list of test accounts.
   ![Test account portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/test_account_portal.png)

   ### Step 3: Create a HubSpot App

1. Now navigate to the `Apps` section from the left sidebar and click on the `Create app` button on the top right corner.
   ![Create app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/create_app.png)

2. Provide a public app name and description for your app.
   ![App name and description](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/app_name_desc.png)

 ### Step 4: Setup Authentication

1. Move to the `Auth` tab.
   ![Configure authentication](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/config_auth.png)

2. In the `Scopes` section, add the following scopes for your app using the `Add new scopes` button.
   - `media_bridge.read`
   - `tickets`
   - `e-commerce`
   - `crm.objects.goals.read`
   - `crm.objects.custom.write`
   - `crm.objects.custom.read`
   - `crm.objects.listings.write`
   - `crm.objects.orders.read`
   - `crm.objects.deals.read`
   - `crm.objects.subscriptions.read`
   - `crm.objects.companies.read`
   - `crm.objects.companies.write`
   - `crm.objects.users.read`
   - `crm.objects.users.write`
   - `crm.objects.invoices.write`
   - `crm.objects.carts.write`
   - `crm.objects.appointments.write`
   - `crm.objects.contacts.read`
   - `crm.objects.services.write`
   - `crm.objects.orders.write`
   - `crm.objects.commercepayments.read`
   - `crm.objects.deals.write`
   - `crm.objects.invoices.read`
   - `crm.objects.appointments.read`
   - `crm.objects.quotes.write`
   - `crm.objects.leads.write`
   - `crm.objects.leads.read`
   - `crm.objects.contacts.write`
   - `crm.objects.partner-clients.write`
   - `crm.objects.line_items.read`
   - `crm.objects.line_items.write`
   - `crm.objects.courses.read`
   - `crm.objects.listings.read`
   - `crm.objects.courses.write`
   - `crm.objects.quotes.read`
   - `crm.objects.partner-clients.read`
   - `crm.objects.carts.read`
   - `crm.objects.services.read`

   ![Add scopes](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/add_scopes.png)

3. In the `Redirect URL` section, add the redirect URL for your app. This is the URL where the user will be redirected after the authentication process. You can use `localhost:9090` for testing purposes. Then click the `Create App` button.

   ![Redirect URL](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/redirect_url.png)
  
### Step 5: Get the Client ID and Client Secret

Navigate to the `Auth` tab and you will see the `Client ID` and `Client Secret` for your app. Make sure to save these values.
![Client ID and Client Secret](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/client_id_secret.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token or Refresh Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.
2. Paste it in the browser and select your developer test account to install the app when prompted.
   ![Account select](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/main/docs/resources/account_select.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```
   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token and refresh token which are necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```
5. Store the refresh token securely for use in your application.

## Quickstart

To use the `HubSpot CRM Associations` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.associations` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.associations as hsassociations;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `hsassociations:ConnectionConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina
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

    final hsassociations:Client baseClient = check new (config);
    ```
### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Get list all associations of an object by object type and object id
    
```ballerina
public function main() returns error? {
    hsassociations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging readResponse 
    = check hubspotAssociations->/objects/["deals"]/["41479955131"]/associations/["companies"].get();
}
```

## Examples

The `HubSpot CRM Associations` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.associations/tree/main/examples/), covering the following use cases:

1. [Create and Read Associations](./examples/create_read_associations) - This example demonstrates the usage of the HubSpot CRM Associations connector to create default and custom associations between deals and companies, as well as retrieve existing associations for a given deal.


## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.associations` package](https://central.ballerina.io/ballerinax/hubspot.crm.associations/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
