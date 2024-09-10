import os
import pyodbc, struct
from azure import identity

from typing import Union
from fastapi import FastAPI
from pydantic import BaseModel

class Sale(BaseModel):
    OrderId: int
    AppUserId: int
    Product: str
    Qty: int
    
connection_string = os.environ["AZURE_SQL_CONNECTIONSTRING"]

app = FastAPI()

### MUST VISIT ROOT URL FIRST TO CREATE DATABASE, THANKS MICROSOFT ###
@app.get("/")
def root():
    print("Root of Sales API")
    # try:
    #     conn = get_conn()
    #     cursor = conn.cursor()

    #     # Table should be created ahead of time in production app.
    #     cursor.execute("""
    #         CREATE TABLE Sales (
    #             OrderId int,
    #             AppUserId int,
    #             Product varchar(10),
    #             Qty int
    #         );
    #     """)

    #     conn.commit()
    # except Exception as e:
    #     # Table may already exist
    #     print(e)
    # try:
    #     conn = get_conn()
    #     cursor = conn.cursor()

    #     # Table should be created ahead of time in production app.
    #     cursor.execute("""
    #         INSERT Sales VALUES
    #             (1, 1, 'Valve', 5),
    #             (2, 1, 'Wheel', 2),
    #             (3, 1, 'Valve', 4),
    #             (4, 2, 'Bracket', 2),
    #             (5, 2, 'Wheel', 5),
    #             (6, 2, 'Seat', 5);
    #     """)

    #     conn.commit()
    # except Exception as e:
    #     # Rows may already exist
    #     print(e)
    
    return "Sales API"

@app.get("/all")
def sales():
    rows = []
    with get_conn() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Persons")

        for row in cursor.fetchall():
            print(row.FirstName, row.LastName)
            rows.append(f"{row.ID}, {row.FirstName}, {row.LastName}")
    return rows

@app.get("/person/{person_id}")
def get_sale(person_id: int):
    with get_conn() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Persons WHERE ID = ?", person_id)

        row = cursor.fetchone()
        return f"{row.ID}, {row.FirstName}, {row.LastName}"

@app.post("/person")
def create_person(item: Sale):
    with get_conn() as conn:
        cursor = conn.cursor()
        cursor.execute(f"INSERT INTO Persons (FirstName, LastName) VALUES (?, ?)", item.first_name, item.last_name)
        conn.commit()

    return item

def get_conn():
    credential = identity.DefaultAzureCredential(exclude_interactive_browser_credential=False)
    token_bytes = credential.get_token("https://database.windows.net/.default").token.encode("UTF-16-LE")
    token_struct = struct.pack(f'<I{len(token_bytes)}s', len(token_bytes), token_bytes)
    SQL_COPT_SS_ACCESS_TOKEN = 1256  # This connection option is defined by microsoft in msodbcsql.h
    conn = pyodbc.connect(connection_string, attrs_before={SQL_COPT_SS_ACCESS_TOKEN: token_struct})
    return conn