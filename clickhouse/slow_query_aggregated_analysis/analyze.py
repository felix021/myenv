#!/usr/bin/python3

import sys
import re

try:
    import pandas as pd
except:
    print("Please install pandas using 'pip3 install pandas'")
    exit(1)

try:
    import sqlparse
    from sqlparse.sql import Token, TokenList
except:
    print("Please install sqlparse using 'pip3 install sqlparse'")
    exit(1)

total = 0
current = 0

def replace_constants_with_placeholder(sql):
    parsed = sqlparse.parse(sql)
    statement = parsed[0]

    def replace_tokens(token_list):
        for token in token_list.tokens:
            if token.ttype in (sqlparse.tokens.Literal.Number.Integer,
                               sqlparse.tokens.Literal.Number.Float,
                               sqlparse.tokens.Literal.String.Single):
                token.value = '?'
            elif isinstance(token, TokenList):
                replace_tokens(token)

    replace_tokens(statement)
    return str(statement)

def parse_query(query):
    global total, current
    current += 1
    if current % 10 == 0:
        print("\r%10d/%10d" % (current, total), end='', file=sys.stderr)

    # unescape backslash encoded string
    query = query.encode('latin-1', 'backslashreplace').decode('unicode-escape')

    # replace constant tokens with ?
    query = replace_constants_with_placeholder(query)

    # Replace `IN (x, y, z)` with `IN (?)`
    query = re.sub(r'\bin\s*\((\s|,|\?)*\)', 'IN (?)', query, flags=re.IGNORECASE)
    return query.replace('\n', '\\n').replace('\t', '\\t')

def aggregate_queries(file_path):
    global total
    # Read the tab-separated file
    df = pd.read_csv(file_path, sep='\t')

    total = len(df.index)
    print("total queries: %d" % (total), file=sys.stderr)

    # Parse queries to get query patterns
    df['query_pattern'] = df['query'].apply(parse_query)
    print("\nall parsed", file=sys.stderr)

    # Aggregate duration_second, memory_usage, user_cpu and execution count by query pattern
    aggregation = df.groupby('query_pattern').agg({
        'duration_second': 'sum',
        'memory_usage': 'sum',
        'user_cpu': 'sum',
        'query_pattern': 'count'
    }).rename(columns={'query_pattern': 'execution_count'}).reset_index()

    # Sort by the most resource-consuming queries
    aggregation = aggregation.sort_values(by=['duration_second', 'memory_usage', 'user_cpu'], ascending=False)

    return aggregation

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: %s <query_log>", sys.argv[0])
        sys.exit(1)
    file_path = sys.argv[1]
    output_path = file_path + ".tsv"
    result = aggregate_queries(file_path)
    result.to_csv(output_path, index=False, sep="\t")
    print(result)
    print("\n[DONE] details in: " + output_path + "\n")