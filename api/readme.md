# AzPAM

An experiment to create a PAM solution for Microsoft partners that need access to either local servers or O365 environments. There are still cases in which a system administrator needs access to O365 environments that are not covered by partner administration. Creating named accounts would be strongly advised but doing this for hundreds of tenants and administration of these accounts could prove difficult.

AzPAM should be able to create Microsoft 365 administrators with a selected permission level, local or domain administrator accounts on servers and log these accounts and any changes to a centralized location. We'll also try grabbing as much logging as possible to display the actions a specific account undertook.

Next to account creation, accounts will also be disabled after the allowed dates. AzPAM should also allow a workflow to request access to resources.

## Backend

Powershell 7.0 Azure functions are responsible for all backend stuff. For O365 it directly connects to the clients using the Secure Application Model. For local servers and domain servers there will need to be a client that connects to the API using its unique API key to retrieve which uses it needs to create.

## Frontend

I ain't no frontend developer, would love help but am currently thinking of using the bootstrap3 edmin template. Don't know if that should be a part of the function or an actual webapp that just does post/get requests to the API.