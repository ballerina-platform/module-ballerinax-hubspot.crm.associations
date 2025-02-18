_Author_:  @arunapriyadarshana \
_Created_: 2025/02/14 \
_Updated_: 2025/02/17 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Ballerina HubSpot CRM Associations Connector. 
The OpenAPI specification is obtained from [Hubspot API Reference](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Associations/Rollouts/130902/v4/associations.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Change the `url` property of the servers object
- **Original**: 
`https://api.hubspot.com`

- **Updated**: 
`https://api.hubapi.com/crm/v4`

- **Reason**: This change of adding the common prefix `crm/v4` to the base url makes it easier to access endpoints using the client.

2. Update the API Paths
- **Original**: Paths included common prefix above in each endpoint. (eg: `/crm/v4`)

- **Updated**: Common prefix is now removed from the endpoints as it is included in the base URL.
- **Reason**: This change simplifies the API paths, making them shorter and more readable.
 
3. Update the `date-time` into `datetime` to make it compatible with the ballerina type conversions
- **Original**: `"foramt":"date-time"`
- **Updated**: `"foramt":"datetime"`

- **Reason**: The `date-time` format is not compatible with the openAPI generation tool. Therefore, it is updated to `datetime` to make it compatible with the generation tool.

4. Enhance API Summaries and Return Descriptions 
- **Original**: API summaries were too generic, often using single-word descriptions like "create", "read", or "delete", which lacked sufficient detail about their functionality. Similarly, return descriptions were too vague, such as "no contact" for a delete operation, providing little clarity on the response.

- **Updated**: Each API summary has been revised to provide a clearer, more meaningful description of its purpose. Additionally, return descriptions now explicitly specify the response format, HTTP status codes, and expected results.

- **Reason**: These updates improve readability, making it easier for developers to understand API functionality and expected responses at a glance.

5. Change `AssociationSpecWithLabel label` to Nullable
- **Original**: The `label` field in AssociationSpecWithLabel was `not nullable`.

- **Updated**: The `label` field has been updated to be `nullable`.
- **Reason**: The HubSpot API can return a null value for this field, so making it nullable ensures accurate representation of API responses.

6. Change `typeId` from `String` to Integer
- **Original**: The `typeId` field was defined as a `string`.

- **Updated**: The `typeId` field has been changed to an `integer`.
- **Reason**: The HubSpot API can return a null value for this field, so making it nullable ensures accurate representation of API responses.

7. Update `LabelsBetweenObjectPair` to change `toObjectId` and `fromObjectId` from string to integer
- **Original**: `toObjectId` and `fromObjectId` were defined as `string`.

- **Updated**: `Both` fields are now `integer`.
- **Reason**: The HubSpot API returns these IDs as integers instead of strings, so updating their types ensures accurate representation.

8. Change `int:signed32` to `int` in `DateTime Record`
- **Original**: `"int:signed32 value"`

- **Updated**:`"int value"`
- **Reason**: The field `value` in the DateTime record can hold a larger value than int:signed32 can accommodate. Therefore, int:signed32 has been replaced with integer to allow for larger values.
## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.yaml -o ballerina --mode client --license docs/license.txt
```
Note: The license year is hardcoded to 2025, change if necessary.
