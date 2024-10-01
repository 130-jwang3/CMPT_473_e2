# Assignment 2 Report
LeTian Wang
301421744
CMPT 473 FALL 2024

---

## Setup Instructions

To run the test harness and the `csv2json` program, you need to clone my repository. The repository contains the `csv2json.py` Python script as well as the test harness and data files necessary to perform the testing.

Clone the repository using the following command:

```sh
git clone git@github.com:130-jwang3/CMPT_473_e2.git
```
## Specification of Program Under Test (PUT)

### Program Under Test: `csv2json.py`

### Description
`csv2json.py` is a Python script that converts a CSV file into JSON format. The script provides various options for customizing the conversion, such as selecting specific columns or rows, defining custom separators, and more.

### Inputs

#### Positional Arguments
- **`infile`** *(string)*:  
  The input CSV file. Default is `data.csv`.

- **`outfile`** *(string)*:  
  The output JSON file. If not provided, the default output file is `[infile_basename].json`.

#### Optional Arguments
- **`-S, --separator SEPARATOR`**:  
  Specifies the separator used in the CSV file. Default is a comma `,`.

- **`-H, --headerline HEADERLINE`**:  
  The line number to use as column names. Default is the first row (`1`).

- **`-c, --columns COLUMNS`**:  
  The number of columns to crop to.

- **`-u, --usecols USECOLS [USECOLS ...]`**:  
  A list of column names to use. This is useful for selective conversion of specific columns.

- **`-n, --names NAMES [NAMES ...]`**:  
  Custom column names to use instead of those in the header.

- **`-N, --nrows NROWS`**:  
  The number of rows to read from the CSV file.

- **`-s, --skiprows SKIPROWS`**:  
  The number of rows to skip at the beginning before reading.

- **`-r, --userows USEROWS [USEROWS ...]`**:  
  List of specific rows to use.

- **`-a, --append APPEND [APPEND ...]`**:  
  Additional columns to append to the output.

- **`-p, --printdata`**:  
  Prints the formatted JSON data to the console after conversion.

### Outputs

#### JSON File
The output is a JSON file containing the data from the CSV file, formatted according to the specified parameters. By default, the output file is `[infile_basename].json`. The JSON output will use the following structures based on the input arguments:

- **Array of Records**: The JSON output will be an array of records (objects), where each record corresponds to a row in the CSV. Column names are used as keys, and cell values are used as values.

#### Error Messages
Standard error messages will be displayed for issues such as:
- **Missing Input File**: If the specified input file does not exist.
- **Improper Formatting**: If the CSV file cannot be properly parsed (e.g., due to incorrect delimiter or other issues).
- **Invalid Arguments**: If any of the command-line arguments are improperly provided.

### CSV Specification (Input Format)
The input CSV file should follow [RFC 4180](https://tools.ietf.org/html/rfc4180) specifications:

- **Field Separator**:  
  The default field separator is a comma `,`, but it can be customized using the `-S` flag.

- **Headers**:  
  By default, no headers are assumed (`-H 0`). The user can specify which line should be treated as the header using the `-H` flag. If no headers are provided, default names will be used for columns.

- **Fields**:  
  The CSV fields may include special characters, and proper handling of double quotes is expected for fields containing commas or line breaks.

### JSON Specification (Output Format)
The output JSON file follows [RFC 8259](https://tools.ietf.org/html/rfc8259):

- **Array of Objects (Records)**:  
  Each CSV row is converted into an object in JSON. If a header row is specified, the keys for each object are derived from the header values. If no header is provided, generic keys such as `"col_1"`, `"col_2"`, etc., will be used.

### Example Input-Output Mapping

1. **Input CSV File** (`data.csv`):
    ```csv
    name,age,city
    Alice,30,New York
    Bob,25,Los Angeles
    ```

2. **Command**:
    ```sh
    python3 bin/csv2json/csv2json.py simpleTestRun/data.csv simpleTestRun/data.json
    ```

3. **Output JSON File** (`data.json`):
    ```json
    [
        {"name": "Alice", "age": 30, "city": "New York"},
        {"name": "Bob", "age": 25, "city": "Los Angeles"}
    ]
    ```

### Limitations
- **No Option to Remove Empty Rows**:  
  The script removes empty rows by default, but there is no explicit argument to disable this behavior.
  
- **No Explicit Option for No Headers**:  
  The `-H` flag is used to specify which line should be treated as headers. If no header is desired, default column names will be assigned automatically.
