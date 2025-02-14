_Author_:  @arunapriyadarshana \
_Created_: 14.02.2025 \
_Updated_: 14.02.2025 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Ballerina HubSpot CRM Associations Connector. 
The OpenAPI specification is obtained from [Hubspot API Reference](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Associations/Rollouts/130902/v4/associations.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Change the `url` property of the servers object
- **Original**: 
```https://api.hubspot.com```

- **Updated**: 
```https://api.hubapi.com/crm/v4```

- **Reason**: This change of adding the common prefix `crm/v4` to the base url makes it easier to access endpoints using the client.

2. Update the API Paths
- **Original**: Paths included common prefix above in each endpoint. (eg: ```/crm/v4```)

- **Updated**: Common prefix is now removed from the endpoints as it is included in the base URL.
  - **Original**: ```/crm/v4```
  - **Updated**: ```/```

- **Reason**: This change simplifies the API paths, making them shorter and more readable.
 

3. Update the `date-time` into `datetime` to make it compatible with the ballerina type conversions
- **Original**: `foramt:date-time`
`
- **Updated**: `foramt:datetime`

- **Reason**: The date-time format is not compatible with the openAPI generation tool. Therefore, it is updated to datetime to make it compatible with the generation tool.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i .\docs\spec\openapi.yaml -o .\ballerina\ --mode client  --license .\docs\license.txt
```
Note: The license year is hardcoded to 2025, change if necessary.
