------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 01_database_and_schema.sql
-- Purpose: Create database, schemas, and warehouse
------------------------------------------------------------------------

USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS PREPARED911_INTELLIGENCE;
USE DATABASE PREPARED911_INTELLIGENCE;

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;
CREATE SCHEMA IF NOT EXISTS ONTOLOGY;

CREATE OR REPLACE WAREHOUSE PREPARED911_WH WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Prepared911 Intelligence Agent';

USE WAREHOUSE PREPARED911_WH;
USE SCHEMA RAW;
