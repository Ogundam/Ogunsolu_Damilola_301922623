// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("sales_order_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("sales_order_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "order_created",
                    "line_added"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "order_line"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "order_line_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("sales_order_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "line_added",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "address_snapshot": "illustrative address_snapshot",
                "promotion_code": "illustrative promotion_code",
                "delivery_instructions": "illustrative delivery_instructions",
                "tax_breakdown": "illustrative tax_breakdown"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "order_created",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "order_line",
            "key": {
                "order_line_id": 402
            },
            "snapshot": {
                "order_line_id": 402,
                "sales_order_id": 301,
                "product_id": 202,
                "line_number": 2,
                "quantity": 2,
                "agreed_unit_price": 22
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 202
                    },
                    "snapshot": {
                        "product_id": 202,
                        "sku": "CS-200",
                        "product_name": "Desk Organizer",
                        "list_price": 24
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "line_added",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "order_line",
            "key": {
                "order_line_id": 402
            },
            "snapshot": {
                "order_line_id": 402,
                "sales_order_id": 301,
                "product_id": 202,
                "line_number": 2,
                "quantity": 2,
                "agreed_unit_price": 22
            }
        },
        "embedded": {
            "product": [
                {
                    "key": {
                        "product_id": 202
                    },
                    "snapshot": {
                        "product_id": 202,
                        "sku": "CS-200",
                        "product_name": "Desk Organizer",
                        "list_price": 24
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "address_snapshot": "illustrative address_snapshot",
                "promotion_code": "illustrative promotion_code",
                "delivery_instructions": "illustrative delivery_instructions",
                "tax_breakdown": "illustrative tax_breakdown"
            }
        }
    },
    {
        "_id": "event_000005",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "order_created",
        "occurredAt": ISODate("2030-01-01T10:04:00Z"),
        "source": {
            "entity": "order_line",
            "key": {
                "order_line_id": 403
            },
            "snapshot": {
                "order_line_id": 403,
                "sales_order_id": 302,
                "product_id": 201,
                "line_number": 1,
                "quantity": 3,
                "agreed_unit_price": 12
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
                        "sales_order_id": 302
                    },
                    "via": [
                        "order_line.sales_order_id → sales_order"
                    ]
                }
            ],
            "customer": [
                {
                    "key": {
                        "customer_id": 102
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
    },
    {
        "_id": "event_000006",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "line_added",
        "occurredAt": ISODate("2030-01-01T10:05:00Z"),
        "source": {
            "entity": "order_line",
            "key": {
                "order_line_id": 403
            },
            "snapshot": {
                "order_line_id": 403,
                "sales_order_id": 302,
                "product_id": 201,
                "line_number": 1,
                "quantity": 3,
                "agreed_unit_price": 12
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
                        "sales_order_id": 302
                    },
                    "via": [
                        "order_line.sales_order_id → sales_order"
                    ]
                }
            ],
            "customer": [
                {
                    "key": {
                        "customer_id": 102
                    },
                    "via": [
                        "order_line.sales_order_id → sales_order.customer_id → customer"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "address_snapshot": "illustrative address_snapshot",
                "promotion_code": "illustrative promotion_code",
                "delivery_instructions": "illustrative delivery_instructions",
                "tax_breakdown": "illustrative tax_breakdown"
            }
        }
    }
]));
  await db.getCollection("sales_order_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("sales_order_events").find({"eventType":"order_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("sales_order_events").find({"source.key.order_line_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("sales_order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("sales_order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("sales_order_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("sales_order_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("sales_order_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
