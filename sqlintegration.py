from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os
from azure.identity import DefaultAzureCredential
import pyodbc
from urllib.parse import quote_plus
# import logging
import struct

# Enable SQLAlchemy logging
# logging.basicConfig()
# logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

# Get the Azure Connection string from env var
connection_string = os.environ["AZURE_SQL_CONNECTIONSTRING"]

# Acquire the token using Azure Identity (for Managed Identity)
credential = DefaultAzureCredential()

# This is the Azure SQL resource URL (default for SQL Server)
resource_url = "https://database.windows.net/"

# Get the access token for Azure SQL
token = credential.get_token(resource_url)
# Make it good for SQLAlchemy
tokenb = bytes(token[0], "UTF-8")
exptoken = b''
for i in tokenb:
    exptoken += bytes({i})
    exptoken += bytes(1)
tokenstruct = struct.pack("=i", len(exptoken)) + exptoken

# PyODBC connection function that uses the Access Token
def get_connection():
    try: 
        conn = pyodbc.connect(connection_string, attrs_before={1256: tokenstruct})
    except Exception as e:
        print(f"Error querying the database: {e}")
    return conn

# Function to create SQLAlchemy engine using pyodbc connection
def create_engine_with_token():
    connection_url = "mssql+pyodbc:///?odbc_connect=" + quote_plus(connection_string)
    
    # SQLAlchemy engine setup
    engine = create_engine(connection_url, creator=get_connection, echo=True)
    return engine

# Create an engine
engine = create_engine_with_token()

# SQLAlchemy engine and session setup (example connection string)
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Define the SQLAlchemy Base model
Base = declarative_base()

# SQLAlchemy model for the Student table
class StudentSchema(Base):
    __tablename__ = 'Students'
    
    id = Column(Integer, primary_key=True, index=True)
    firstname = Column(String, nullable=False)
    lastname = Column(String, nullable=False)