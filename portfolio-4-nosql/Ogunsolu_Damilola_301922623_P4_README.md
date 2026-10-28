# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection sales_order_events for order_created and line_added events. These are fictional event examples based on sales_order, customer, order_line, product.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related product details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_line",
        "key": {
            "order_line_id": 401
        },
        "snapshot": {
            "order_line_id": 401,
            "sales_order_id": 301,
            "product_id": 201,
            "line_number": 1,
            "quantity": 4,
            "agreed_unit_price": 11.5
        }
    },
    "embedded": {
        "product": [
            {
                "key": {
                    "product_id": 201
                },
                "snapshot": {
                    "product_id": 201,
                    "sku": "NS-100",
                    "product_name": "Canvas Tote",
                    "list_price": 12.5
                },
                "via": [
                    "order_line.product_id → product"
                ]
            }
        ]
    },
    "references": {
        "sales_order": [
            {
                "key": {
                    "sales_order_id": 301
                },
                "via": [
                    "order_line.sales_order_id → sales_order"
                ]
            }
        ],
        "customer": [
            {
                "key": {
                    "customer_id": 101
                },
                "via": [
                    "order_line.sales_order_id → sales_order.customer_id → customer"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 3 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 5 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("sales_order_events").find({"eventType":"order_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  },
  {
    "_id": "event_000003",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "order_line_id": 402
    }
  },
  {
    "_id": "event_000005",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:04:00Z"
    },
    "source": {
      "order_line_id": 403
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("sales_order_events").find({"source.key.order_line_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "line_added",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("sales_order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "line_added",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  },
  {
    "_id": "event_000003",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "order_line_id": 402
    }
  },
  {
    "_id": "event_000004",
    "eventType": "line_added",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "order_line_id": 402
    }
  },
  {
    "_id": "event_000005",
    "eventType": "order_created",
    "occurredAt": {
      "$date": "2030-01-01T10:04:00Z"
    },
    "source": {
      "order_line_id": 403
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("sales_order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| line_added | 3 |
| order_created | 3 |

## Validation and suitability

MongoDB inserted 6 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 6 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Ogunsolu_Damilola_301922623_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Ogunsolu_Damilola_301922623_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

