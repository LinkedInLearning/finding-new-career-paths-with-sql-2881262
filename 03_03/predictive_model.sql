-- Build a Forecasting Model based on Historical Product Sales data

CREATE OR REPLACE VIEW HPlusSports.forecast_training_data AS
(SELECT orders.OrderDate, 
ProductCode,
total_products_sold
FROM `sql-careers.HPlusSports.orders` as orders,
(SELECT OrderID, 
p.ProductCode,
SUM(Quantity) as total_products_sold
FROM `sql-careers.HPlusSports.order_item` i ,`sql-careers.HPlusSports.products` p
where i.ProductID = p.ProductID
group by ORDERID, ProductCode) as products_sold
WHERE orders.OrderID = products_sold.OrderID);


-- Create A Time Series Based Model
CREATE OR REPLACE MODEL HPlusSports.forecast_model
OPTIONS(
  MODEL_TYPE='ARIMA',
  TIME_SERIES_TIMESTAMP_COL='OrderDate', 
  TIME_SERIES_DATA_COL='total_products_sold',
  TIME_SERIES_ID_COL='ProductCode',
  HOLIDAY_REGION='US'
) AS
SELECT OrderDate, ProductCode,total_products_sold
FROM `sql-careers.HPlusSports.forecast_training_data`

-- Evaluate the Model
SELECT * FROM
ML.EVALUATE(MODEL `sql-careers.HPlusSports.forecast_model`);


-- Make Predictions for the next 30 days at a confidence interval of 90%
SELECT *
FROM 
ML.FORECAST(MODEL HPlusSports.forecast_model, 
STRUCT(30 AS horizon, 0.9 AS confidence_level));

-- Create a view to build visualization
CREATE OR REPLACE VIEW HPlusSports.forecast_datastudio AS (
  SELECT
    OrderDate AS timestamp,
    ProductCode,
    total_products_sold as history_value,
    NULL AS forecast_value,
    NULL AS prediction_interval_lower_bound,
    NULL AS prediction_interval_upper_bound
  FROM
    HPlusSports.forecast_training_data
  UNION ALL
  SELECT
    EXTRACT(DATE
    FROM
      forecast_timestamp) AS timestamp,
    ProductCode,
    NULL AS history_value,
    forecast_value,
    prediction_interval_lower_bound,
    prediction_interval_upper_bound
  FROM
    ML.FORECAST(MODEL `sql-careers.HPlusSports.forecast_model`,
      STRUCT(30 AS horizon, 0.9 AS confidence_level)) 
  ORDER BY timestamp
  );

  SELECT *  FROM `sql-careers.HPlusSports.forecast_datastudio`;
