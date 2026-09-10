import sqlite3
import pandas as pd
from pathlib import Path
import os

class SalesDatabase:

    INDEXES = {
    'orders':           ['order_id', 'customer_id'],
    'customers':        ['customer_id'],
    'products':         ['product_id'],
    'order_items':      ['order_id', 'product_id', 'seller_id'],
    'order_payments':   ['order_id'],
    'order_reviews':    ['order_id'],
    'sellers':          ['seller_id']
    }

    def __init__(self):
        self.project_root = Path(__file__).resolve().parent.parent
        self.db_dir = self.project_root / 'data' / 'database'
        self.db_dir.mkdir(exist_ok=True)
        self.db_path = self.db_dir / 'sales_analysis.db'
        self.connection = None

    def connect(self):
        self.connection = sqlite3.connect(self.db_path)
        self.connection.row_factory = sqlite3.Row
        print(f"Conectando ao banco: {self.db_path}")
        return self.connection

    def close(self):
        if self.connection:
            self.connection.close()
            print("Conexão encerrada")

    def execute_query(self, query, params=None):
        if not self.connection:
            self.connect()

        try:
            if params:
                df = pd.read_sql_query(query, self.connection, params=params)
            else:
                df = pd.read_sql_query(query, self.connection)
            return df
        except Exception as e:
            print(f"Erro ao executar query: {e}")
            return None

    def execute_many(self, query, params_list):

        if not self.connection:
            self.connect()

        cursor = self.connection.cursor()
        try:
            cursor.executemany(query, params_list)
            self.connection.commit()
            print(f"{cursor.rowcount} registros afetados")
        except Exception as e:
            print(f"Erro {e}")

    def create_tables_from_dataframes(self, dataframe_dict):
        if not self.connection:
            self.connect()

        for table_name, df in dataframe_dict.items():
            df.to_sql(table_name, self.connection,
                      if_exists='replace',
                      index=False)
            print(f"Tabela {table_name} criada com {len(df)} registros")

    def create_indexes(self, indexes=INDEXES):
        if not self.connection:
            self.connect()
            
        for table_name, columns in indexes.items():
            for col in columns:
                self.connection.execute(
                    f"CREATE INDEX IF NOT EXISTS idx_{table_name}_{col} ON {table_name}({col})"
                )

    def load_csv_to_db(self, csv_path, table_name):
        if not self.connection:
            self.connect()

        df = pd.read_csv(csv_path)
        df.to_sql(table_name, self.connection,
                  if_exists='replace',
                  index=False)
        print(f"CSV Carregado para a tabela {table_name}: {len(df)} registros.")
        return df

def get_db():

    return SalesDatabase()



"""
if __name__ == "__main__":
    db = get_db()
    db.connect()
    
    # Testar conexão
    result = db.execute_query("SELECT sqlite_version() as version")
    if result is not None:
        print(f"Versão do SQLite: {result.iloc[0]['version']}")
    
    db.close() 
"""
