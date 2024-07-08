## Project Description
- Build an API using Rails 7, and expose 11 endpoints:
- Restful
  - Merchants (Index,Show, Merchant Items)
  - Items (Index, Show, Create, Edit, Delete, Item Mercahnt)
- Non-RESTful
  - Find one merchant based on search criteria
  - find all items based on search criteria
 
## Database Schema
<img width="1009" alt="DB_SCHEMA_RAILSENGINE" src="https://github.com/DHowell1150/rails_engine/assets/74687494/ad04904c-b331-4dec-83b5-f2070941c286">

## How to use our API
Example REQUEST
Since this API doesn't require you to provide an API key, it's extremely easy to use.

METHOD: GET

URL: http://localhost:3000/api/v1/merchants

RESULT: <br/>

<img width="743" alt="result" src="https://github.com/DHowell1150/rails_engine/assets/74687494/97ed6924-5bc4-4a99-9256-dd9f93956eba">

# Merchant Endpoints
 - All Mercahnts: get /api/v1/merchants
 - Specific Merchant: get /api/v1/merchants/{Merchant_ID}
 - Specific Merchants Items: get /api/v1/merchants/{Merchant_ID}/items
   
# Items Endpoints
 - All Items: get /api/v1/items
 - Specific Item: get /api/v1/items/{Item_ID}
 - Create Item: post /api/v1/items
 - Edit Item: patch /api/v1/items/{Item_ID}
 - Delete Item: destroy /api/v1/items/{Item_ID}
 - Specific Item for Merchant: get /api/v1/items/{Item_ID}

## Collaborators
https://github.com/DHowell1150 <br/>
https://github.com/LJ9332 <br/>
https://github.com/GBowman1
