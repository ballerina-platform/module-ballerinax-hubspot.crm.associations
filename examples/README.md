# Examples

The `ballerinax/hubspot.crm.associations` connector provides practical examples illustrating usage in various scenarios.

1. [Create and read associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-read-associations) –  This example demonstrates how to use the HubSpot CRM Associations connector to batch-create default and custom-labeled associations between deals and companies, as well as retrieve existing associations for a given deal.
2. [Create and delete associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-delete-associations) - This example demonstrates how to use the HubSpot CRM Associations connector to create individual default associations with and without labels between deals and companies. It then shows how to delete a specific association label between them, followed by deleting all associations between the two objects.

## Prerequisites

- Ballerina Swan Lake Update 11 (2201.11.0)
- A HubSpot developer account (Refer to the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/blob/main/ballerina/Readme.md#setup-guide)) for instructions.
- `ballerinax/hubspot.crm.associations` module
- Refer to the following code for creating the `Config.toml` file.

```toml  
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
``` 

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
