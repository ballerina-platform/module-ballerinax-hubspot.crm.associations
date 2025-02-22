## Overview

[HubSpot](https://developers.hubspot.com) is an AI-powered customer relationship management (CRM) platform.

The `ballerinax/hubspot.crm.associations` offers APIs to connect and interact with the [HubSpot Association Details API](https://developers.hubspot.com/docs/reference/api/crm/associations/association-details) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api).

> **Note:** This package may be changed in the future based on the HubSpot API changes, since it is currently under development and is subject to change based on testing and feedback. By using this package, you are agreeing to accept any future changes that might occur and understand the risk associated with testing an unstable API. Refer to the [HubSpot Developer Terms](https://legal.hubspot.com/developer-terms) & [Developer Beta Terms](https://legal.hubspot.com/developerbetaterms) for more information.
>
> The feedback submissions endpoints are currently read only. Feedback submissions cannot be submitted or edited through the API.

## Setup guide

To use the HubSpot Association details connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot Developer Account

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

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

    hsfeedback:ConnectionConfig config = {
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

#### Get list all associations of an object by object type
    
```ballerina
public function main() returns error? {

}
```



## Examples

The `HubSpot CRM Associations` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.associations/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)
