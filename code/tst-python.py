import argparse
import filecmp
import pandas as pd

if __name__ == '__main__':

    parser = argparse.ArgumentParser()  
    parser.add_argument('--csvpath', required=True)
    args = parser.parse_args()
    print(args.csvpath)
    filepath = args.csvpath
    df = pd.read_csv(filepath, index_col = False) 
    print(df)
    print(type(df))
    print(df.shape)
    print(df.head(2))
    print(df.iloc[[3]])
    print(df['Name'].iloc[[2]])
    df.head(2).to_csv('test.csv', index=False)

## print("h")