# Portfolio 1 — Database Design and Modelling

I organised the data into customer, product, sales_order, order_line. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| customer | 2 |
| product | 2 |
| sales_order | 2 |
| order_line | 3 |

The 30 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Ogunsolu_Damilola_301922623_P1_Design.md)
- [ER diagram](Ogunsolu_Damilola_301922623_P1_ERDiagram.md)
- [Normalisation](Ogunsolu_Damilola_301922623_P1_Normalisation.md)
- [Schema](Ogunsolu_Damilola_301922623_P1_Schema.sql)
- [Sample data](Ogunsolu_Damilola_301922623_P1_SampleData.sql)
- [Constraint tests](Ogunsolu_Damilola_301922623_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Ogunsolu_Damilola_301922623_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

