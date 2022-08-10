import argparse
from mysql.connector import Error # MySQL exceptions
import mysql.connector as mysql # MySQL operations
import pandas as pd

if __name__ == '__main__':
    try:
        conn = mysql.connect(host='3.88.62.37', database='mysql', user='ravi', password='ravi123@PSWD')

        if conn.is_connected():
            print(f'DB is connected to server{conn}')
            sqltxt = 'show tables;'
            cursor = conn.cursor() 
            cursor.execute(sqltxt)
            
            records = cursor.fetchall()
            print(records)

            cursor.execute(f'\
                create table if not exists restaurant(\
                    `id` BIGINT NOT NULL,\
                    `position` BIGINT,\
                    `name` VARCHAR(1000),\
                    `score` FLOAT,\
                    `ratings` INT,\
                    `category` TEXT,\
                    `price_range` VARCHAR(10),\
                    `full_address` TEXT,\
                    `zip_code` VARCHAR(100),\
                    `lat` FLOAT,\
                    `lng` FLOAT, \
                    `last_modified_date` DATE, \
                    PRIMARY KEY (id)\
                    )\
                ')
            print(f'created successfully table' )
            cursor.execute(f'ALTER TABLE restaurant CONVERT TO CHARACTER SET utf8mb4;') 
            cursor.execute(sqltxt)
            records = cursor.fetchall()
            print(records)

            sqlQ = f'INSERT INTO mysql.restaurant VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)'
            for data in pd.read_csv(r"C:\Users\Phani Yelugula\Desktop\AWS\GIT\dm-local-repo-feature\DataMigration\data\restaurants.csv", chunksize= 500 ):
                print(type(data))
                # Filling missing values with 0, with out this it gave error 
                data = data.fillna(0)
                # Executemany can ingest chuck of data that is given as a list
                cursor.executemany(
                    sqlQ,
                    list(zip(data['id'],data['position'],data['name'],data['score'],data['ratings'],data['category'],data['price_range'],data['full_address'],data['zip_code'],data['lat'],data['lng'],data['last_modified_date']))
                    )
                conn.commit()
    except (mysql.Error,mysql.Warning) as e:
        print( f'following sql error: \n{str(e)}') 
    except Exception as e:
        print( f'following error: \n{str(e)}') 