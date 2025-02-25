# Examples

The `ballerinax/hubspot.crm.associations` connector provides practical examples illustrating usage in various scenarios.

1. [Create and read associations](../examples/create-read-associations) - This example demonstrates the usage of the HubSpot CRM Associations connector to create default and custom associations between deals and companies, as well as retrieve existing associations for a given deal.

## Prerequisites

- **Ballerina:** Download and install Ballerina from [here](https://ballerina.io/downloads/).
- **HubSpot developer account:** Create a HubSpot developer account and create an app to obtain the necessary credentials. Refer to the [Setup Guide](../ballerina/Package.md) for instructions.
- **`ballerinax/hubspot.crm.association` module:** Import the `ballerinax/hubspot.crm.association` module into your Ballerina project and configure it with the obtained credentials. Refer to the following code for creating the `Config.toml` file.

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
