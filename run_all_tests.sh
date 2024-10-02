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

# Create output directories if they don't exist
mkdir -p "$ACTUAL_OUTPUT_DIR"
mkdir -p "$ACTUAL_ERROR_DIR"
mkdir -p "$ACTUAL_ERROR_UNFILTERED_DIR"
mkdir -p "$ACTUAL_MESSAGES_DIR"

# Run each test case
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

  # Reset all optional arguments
  HEADER_OPTION=""
  USE_COLUMNS=""
  SKIP_ROWS=""
  LIMIT_ROWS=""
  CUSTOM_NAMES=""
  APPEND_COLUMNS=""
  EXPLICIT_ROW_SELECTION=""
  SEPARATOR=""
  PRINT_DATA=""

  # Define parameters for each test case based on the specification
  case $i in
    0)
      # Test Case 0: No Header, DISKFILE as Input and Output, Limit Columns
      HEADER_OPTION="--headerline 0"
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

    # More cases can be added here...

    *)
      echo "Invalid Test Case Number $i"
      continue
      ;;
  esac

  echo "Running Test Case $i..."

  # Run the csv2json program and capture stdout and stderr separately
  # Redirect printed data to ACTUAL_MESSAGE_FILE and JSON output to OUTPUT_FILE
  $PROGRAM "$INPUT_FILE" "$OUTPUT_FILE" $HEADER_OPTION $USE_COLUMNS $SEPARATOR $LIMIT_ROWS $SKIP_ROWS $CUSTOM_NAMES $EXPLICIT_ROW_SELECTION $APPEND_COLUMNS $PRINT_DATA > "$ACTUAL_MESSAGE_FILE" 2> "$ERROR_UNFILTERED_FILE"

  # Check if there was an error by examining the error file
  if [ -s "$ERROR_UNFILTERED_FILE" ]; then
    # If the error file is not empty, create an empty JSON file as output
    echo "{}" > "$OUTPUT_FILE"

    # Copy unfiltered error to the filtered directory for processing
    cp "$ERROR_UNFILTERED_FILE" "$ERROR_FILE"

    # Normalize and filter the error message to capture only the relevant error
    grep -E "pandas\.errors.*|ValueError|ParserError" "$ERROR_FILE" > "${ERROR_FILE}_filtered"

    # Clean up the error message to remove file paths or other sensitive data
    sed -e 's/.*pandas.errors/pandas.errors/' "${ERROR_FILE}_filtered" | sed -e 's/[[:space:]]*$//' > "${ERROR_FILE}_normalized"
    sed -e 's/[[:space:]]*$//' "$EXPECTED_ERROR_FILE" > "${EXPECTED_ERROR_FILE}_normalized"

    # Compare the normalized versions of the error files
    if diff "${ERROR_FILE}_normalized" "${EXPECTED_ERROR_FILE}_normalized"; then
      echo "Test Case $i: PASSED (Error Output Matches)"
    else
      echo "Test Case $i: FAILED (Error Output Mismatch)"
    fi

    # Clean up filtered and normalized error files
    rm "${ERROR_FILE}_filtered" "${ERROR_FILE}_normalized" "${EXPECTED_ERROR_FILE}_normalized"

  else
    # Compare the printed data with the expected printed data
    if [ -f "$ACTUAL_MESSAGE_FILE" ] && [ -f "$EXPECTED_MESSAGE_FILE" ]; then
      # Normalize printed output for consistent comparison
      sed -e 's/[[:space:]]*$//' "$ACTUAL_MESSAGE_FILE" > "${ACTUAL_MESSAGE_FILE}_normalized"
      sed -e 's/[[:space:]]*$//' "$EXPECTED_MESSAGE_FILE" > "${EXPECTED_MESSAGE_FILE}_normalized"

      if diff "${ACTUAL_MESSAGE_FILE}_normalized" "${EXPECTED_MESSAGE_FILE}_normalized"; then
        echo "Test Case $i: PASSED (Printed Data Matches)"
      else
        echo "Test Case $i: FAILED (Printed Data Mismatch)"
      fi

      # Clean up normalized printed files
      rm "${ACTUAL_MESSAGE_FILE}_normalized" "${EXPECTED_MESSAGE_FILE}_normalized"
    else
      echo "Test Case $i: FAILED (Printed Data Missing)"
    fi

    # Compare the output with the expected output if no error is expected
    if [ -f "$OUTPUT_FILE" ] && [ -f "$EXPECTED_OUTPUT_FILE" ]; then
      # Normalize JSON output for consistent comparison
      cp "$OUTPUT_FILE" "${OUTPUT_FILE}_normalized"
      cp "$EXPECTED_OUTPUT_FILE" "${EXPECTED_OUTPUT_FILE}_normalized"

      if diff "${OUTPUT_FILE}_normalized" "${EXPECTED_OUTPUT_FILE}_normalized"; then
        echo "Test Case $i: PASSED"
      else
        echo "Test Case $i: FAILED (Output Mismatch)"
      fi

      # Clean up normalized JSON files
      rm "${OUTPUT_FILE}_normalized" "${EXPECTED_OUTPUT_FILE}_normalized"
    else
      echo "Test Case $i: FAILED (No Output Generated)"
    fi
  fi

  echo ""
done
