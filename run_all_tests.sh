#!/bin/bash

# Directories
TEST_DIR="TestData"
TEST_FILES_DIR="$TEST_DIR/TestFiles"
EXPECTED_OUTPUT_DIR="$TEST_DIR/ExpectedOutput"
EXPECTED_MESSAGES_DIR="$TEST_DIR/ExpectedMessages"
ACTUAL_OUTPUT_DIR="$TEST_DIR/ActualOutput"
ACTUAL_ERROR_DIR="$ACTUAL_OUTPUT_DIR/Errors"
ACTUAL_ERROR_UNFILTERED_DIR="$ACTUAL_OUTPUT_DIR/Errors_test"
ACTUAL_MESSAGES_DIR="$ACTUAL_OUTPUT_DIR/Messages"

# Paths to Program
PROGRAM="python3 bin/csv2json.py"

# create output directories if they don't exist
mkdir -p "$ACTUAL_OUTPUT_DIR"
mkdir -p "$ACTUAL_ERROR_DIR"
mkdir -p "$ACTUAL_ERROR_UNFILTERED_DIR"
mkdir -p "$ACTUAL_MESSAGES_DIR"

# run each test case
for i in {0..12}
do
  INPUT_FILE="$TEST_FILES_DIR/test_${i}.csv"
  OUTPUT_FILE="$ACTUAL_OUTPUT_DIR/test_${i}.json"
  EXPECTED_OUTPUT_FILE="$EXPECTED_OUTPUT_DIR/test_${i}.json"
  EXPECTED_ERROR_FILE="$EXPECTED_MESSAGES_DIR/test_${i}_error.txt"
  EXPECTED_MESSAGE_FILE="$EXPECTED_MESSAGES_DIR/test_${i}.txt"
  ERROR_FILE="$ACTUAL_ERROR_DIR/test_${i}_error.txt"
  ERROR_UNFILTERED_FILE="$ACTUAL_ERROR_UNFILTERED_DIR/test_${i}_error_unfiltered.txt"
  ACTUAL_MESSAGE_FILE="$ACTUAL_MESSAGES_DIR/test_${i}.txt"

  # reset all optional arguments
  HEADER_OPTION=""
  USE_COLUMNS=""
  SKIP_ROWS=""
  LIMIT_ROWS=""
  CUSTOM_NAMES=""
  APPEND_COLUMNS=""
  EXPLICIT_ROW_SELECTION=""
  SEPARATOR=""
  PRINT_DATA=""

  # define parameters for each test case based on the specification
  case $i in
    0)
      # Test Case 0: No Header, DISKFILE as Input and Output, Limit Columns
      HEADER_OPTION="--headerline None"
      COLUMN_SELECTION="--columns 2"
      SEPARATOR="-S ,"
      ;;

    1)
      # Test Case 1: Configuring all required options
      HEADER_OPTION="--headerline 0"
      USE_COLUMNS="--usecols id name"
      SKIP_ROWS="--skiprows 1"
      LIMIT_ROWS="--nrows 0"
      CUSTOM_NAMES="--names custom_id custom_name custom_new_col1 custom_new_col2"
      APPEND_COLUMNS="--append new_col1 new_col2"
      EXPLICIT_ROW_SELECTION="--userows 0"
      SEPARATOR="-S ,"
      PRINT_DATA="-p"
      ;;

    2)
      # Test Case 2: Specific Header Line, All Columns, Skip Rows, Explicit Row Selection, and Print Data
      HEADER_OPTION="--headerline 1"
      SKIP_ROWS="--skiprows 1"
      EXPLICIT_ROW_SELECTION="--userows 1 2 3 4"
      SEPARATOR="-S ,"
      PRINT_DATA="-p"
      ;;

    3)
      # Test Case 3: No Header, DISKFILE as Input and Output, Use Specific Columns, Limit Rows, Append Columns, Custom Column Names
      HEADER_OPTION="--headerline None"
      USE_COLUMNS="--usecols 0 1" # Use the first and second columns
      LIMIT_ROWS="--nrows 2" # Limit the number of rows to 2
      CUSTOM_NAMES="--names custom_col1 custom_col2"
      APPEND_COLUMNS="--append appended_col1 appended_col2"
      SEPARATOR="-S ;"
      PRINT_DATA="" # No data will be printed
      ;;

    4)
      # Test Case 4: First line as header, skip rows, custom column names, use all columns, print data, semicolon separator
      HEADER_OPTION="--headerline 0"
      SKIP_ROWS="--skiprows 1"
      CUSTOM_NAMES="--names custom_id custom_name custom_age custom_city"
      SEPARATOR="-S ;"
      PRINT_DATA="-p"
      ;;

    5)
      # Test Case 5: SPECIFIC_LINE header, DISKFILE as Input and Output, Limit Columns, Explicit Row Selection, Append Columns
      HEADER_OPTION="--headerline 1" # Use the header from line 2 (indexing starts at 0)
      COLUMN_SELECTION="--columns 2" # Limit to 2 columns
      LIMIT_ROWS="--nrows 0" # Since Number_Of_Records is ZERO, no data rows are used
      EXPLICIT_ROW_SELECTION="--userows 1 2" # Select specific rows, though no data rows are available
      APPEND_COLUMNS="--append appended_col1 appended_col2" # Append two new columns
      SEPARATOR="-S ;"
      PRINT_DATA=""
      ;;

    6)
      # Test Case 6: No Header, DISKFILE as Input and Output, All Columns, Skip Rows, Custom Column Names, Append Columns, Tab Separator, Zero Records
      HEADER_OPTION="--headerline None"
      SKIP_ROWS="--skiprows 1" # Skip the first row
      CUSTOM_NAMES="--names custom_col1 custom_col2 custom_col3"
      APPEND_COLUMNS="--append appended_col1 appended_col2" # Append two new columns
      SEPARATOR="-S $'\t'" # Tab separator
      PRINT_DATA="" # No data printed to the console
      ;;

    7)
      # Test Case 7: FIRST_LINE header, DISKFILE as Input and Output, Limit Columns, Print Data, Tab Separator
      HEADER_OPTION="--headerline 0" # Use the first line as the header (indexing starts at 0)
      LIMIT_ROWS="--nrows 2" # Limit the number of rows to 2 for testing
      EXPLICIT_ROW_SELECTION="--userows 1 2" # Select specific rows by their index
      SEPARATOR="-S $'\t'" # Use tab as the separator
      PRINT_DATA="-p" # Print data to stdout
      ;;

    8)
      # Test Case 8: SPECIFIC_LINE header, DISKFILE as Input and Output, Use Specific Columns, Skip Rows, Custom Column Names, Append Columns, Print Data, Tab Separator
      HEADER_OPTION="--headerline 1" # Use the header from the second line (indexing starts at 0)
      SKIP_ROWS="--skiprows 1" # Skip the first row (index 0)
      CUSTOM_NAMES="--names custom_id custom_name" # Rename columns for the output
      USE_COLUMNS="--usecols id name" # Use specific columns: 'id' and 'name'
      APPEND_COLUMNS="--append extra_col1 extra_col2" # Append two new columns
      SEPARATOR="-S $'\t'"
      PRINT_DATA="-p" # Print data to stdout
      ;;

    9)
      # Test Case 9: No Header, DISKFILE as Input and Output, Limit Rows, All Columns, Explicit Row Selection, Custom Separator, Print Data
      HEADER_OPTION="--headerline None" # No header line is present
      LIMIT_ROWS="--nrows 0" # Since Number_Of_Records is ZERO, no data rows are used
      EXPLICIT_ROW_SELECTION="--userows 1 2" # Explicitly select rows, although no rows should be processed due to ZERO limit
      SEPARATOR="-S |" # Custom separator (vertical bar)
      PRINT_DATA="-p" # Print data to stdout
      ;;

    10)
    # Test Case 10: FIRST_LINE header, DISKFILE as Input and Output, Skip Rows, Custom Column Names, Limit Columns, Custom Separator, Append Columns
      HEADER_OPTION="--headerline 0" # Use the first line as the header (indexing starts at 0)
      SKIP_ROWS="--skiprows 1" # Skip the first row after the header
      CUSTOM_NAMES="--names custom_id custom_name custom_age custom_city custom_new_col1 custom_new_col2" # Assign custom names to the columns
      COLUMN_SELECTION="--columns 2" # Limit to the first two columns
      APPEND_COLUMNS="--append new_col1 new_col2" # Append two new columns
      SEPARATOR="-S :" # Custom separator (colon)
      PRINT_DATA="" # No data will be printed to the console
      ;;
    11)
      # Test Case 11: SPECIFIC_LINE header, DISKFILE as Input and Output, Limit Rows, Skip Rows, Use Specific Columns, Explicit Row Selection, Custom Separator
      HEADER_OPTION="--headerline 1" # Use the header from line 2 (indexing starts from 1)
      LIMIT_ROWS="--nrows 2" # Limit to 2 rows after the header
      SKIP_ROWS="--skiprows 1" # Skip the first row after the header
      USE_COLUMNS="--usecols id age" # Use specific columns (1 and 3, which are 'id' and 'age')
      EXPLICIT_ROW_SELECTION="--userows 1 2" # Explicitly select rows 1 and 2 (after skipping)
      SEPARATOR="-S |" # Use custom separator (pipe '|')
      PRINT_DATA="-p" # Print data to stdout
      ;;

    12)
      # Test Case 12: No Header, DISKFILE as Input and Output, Custom Column Names, All Columns, Semicolon Separator
      HEADER_OPTION="--headerline None" # No header line
      CUSTOM_NAMES="--names ID Name Age City" # Custom column names since the file has no header
      SEPARATOR="-S ;"
      ;;

    *)
      echo "Invalid Test Case Number $i"
      continue
      ;;
  esac

  echo "Running Test Case $i..."

  # run the csv2json program and capture stdout and stderr separately
  # redirect printed data to ACTUAL_MESSAGE_FILE and JSON output to OUTPUT_FILE
  $PROGRAM "$INPUT_FILE" "$OUTPUT_FILE" $HEADER_OPTION $USE_COLUMNS $COLUMN_SELECTION $SEPARATOR $LIMIT_ROWS $SKIP_ROWS $CUSTOM_NAMES $EXPLICIT_ROW_SELECTION $APPEND_COLUMNS $PRINT_DATA > "$ACTUAL_MESSAGE_FILE" 2> "$ERROR_UNFILTERED_FILE"

  # check if there was an error by examining the error file
  if [ -s "$ERROR_UNFILTERED_FILE" ]; then
    # if the error file is not empty, create an empty JSON file as output
    echo "{}" > "$OUTPUT_FILE"

    # copy unfiltered error to the filtered directory for processing
    cp "$ERROR_UNFILTERED_FILE" "$ERROR_FILE"

    # normalize and filter the error message to capture only the relevant error
    tail -n 1 "$ERROR_FILE" | sed -e 's/[[:space:]]*$//' > "${ERROR_FILE}_normalized"
    sed -e 's/[[:space:]]*$//' "$EXPECTED_ERROR_FILE" > "${EXPECTED_ERROR_FILE}_normalized"

    # compare the normalized versions of the error files
    if diff "${ERROR_FILE}_normalized" "${EXPECTED_ERROR_FILE}_normalized"; then
      echo "Test Case $i: PASSED (Error Output Matches)"
    else
      echo "Test Case $i: FAILED (Error Output Mismatch)"
    fi

    # normalize empty JSON files for comparison
    sed -e 's/[[:space:]]*$//' "$OUTPUT_FILE" > "${OUTPUT_FILE}_normalized"
    sed -e 's/[[:space:]]*$//' "$EXPECTED_OUTPUT_FILE" > "${EXPECTED_OUTPUT_FILE}_normalized"

    # compare the empty JSON file with the expected JSON file
    if diff "${OUTPUT_FILE}_normalized" "${EXPECTED_OUTPUT_FILE}_normalized"; then
      echo "Test Case $i: PASSED (Empty JSON Output Matches)"
    else
      echo "Test Case $i: FAILED (Empty JSON Output Mismatch)"
    fi

    # clean up normalized files
    rm "${ERROR_FILE}_normalized" "${EXPECTED_ERROR_FILE}_normalized" "${OUTPUT_FILE}_normalized" "${EXPECTED_OUTPUT_FILE}_normalized"

  else
    # compare the printed data with the expected printed data
    if [ -f "$ACTUAL_MESSAGE_FILE" ] && [ -f "$EXPECTED_MESSAGE_FILE" ]; then
      # normalize printed output for comparison
      sed -e 's/[[:space:]]*$//' "$ACTUAL_MESSAGE_FILE" > "${ACTUAL_MESSAGE_FILE}_normalized"
      sed -e 's/[[:space:]]*$//' "$EXPECTED_MESSAGE_FILE" > "${EXPECTED_MESSAGE_FILE}_normalized"

      if diff "${ACTUAL_MESSAGE_FILE}_normalized" "${EXPECTED_MESSAGE_FILE}_normalized"; then
        echo "Test Case $i: PASSED (Printed Data Matches)"
      else
        echo "Test Case $i: FAILED (Printed Data Mismatch)"
      fi

      # clean up normalized files
      rm "${ACTUAL_MESSAGE_FILE}_normalized" "${EXPECTED_MESSAGE_FILE}_normalized"
    else
      echo "Test Case $i: FAILED (Printed Data Missing)"
    fi

    # compare the output with the expected output if no error is expected
    if [ -f "$OUTPUT_FILE" ] && [ -f "$EXPECTED_OUTPUT_FILE" ]; then
      # normalize JSON output for comparison
      cp "$OUTPUT_FILE" "${OUTPUT_FILE}_normalized"
      cp "$EXPECTED_OUTPUT_FILE" "${EXPECTED_OUTPUT_FILE}_normalized"

      if diff "${OUTPUT_FILE}_normalized" "${EXPECTED_OUTPUT_FILE}_normalized"; then
        echo "Test Case $i: PASSED"
      else
        echo "Test Case $i: FAILED (Output Mismatch)"
      fi

      # clean up normalized files
      rm "${OUTPUT_FILE}_normalized" "${EXPECTED_OUTPUT_FILE}_normalized"
    else
      echo "Test Case $i: FAILED (No Output Generated)"
    fi
  fi

  echo ""
done
