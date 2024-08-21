#!/bin/bash

# Ensure the script is run with the required argument(s)
if [ $# -lt 1 ]; then
  echo "Usage: $0 <input_text_file> [suffixes]"
  exit 1
fi

# Assign the arguments
input_file="$1"
suffixes="$2"

# Create directories for ZPL and PDF files
mkdir -p zpl pdf

# Call the R script to generate the ZPL files in the 'zpl' directory
Rscript generate_zpl.R "$input_file" "$suffixes"

# Check if ZPL files were created successfully
if [ "$(ls -A zpl/*.zpl 2>/dev/null)" ]; then
  # Loop through all the ZPL files in the 'zpl' directory and generate a PDF for each
  for zpl_file in zpl/*.zpl; do
    # Extract the ID from the ZPL file name
    id="$(basename "${zpl_file%.zpl}")"

    # Generate the corresponding PDF file in the 'pdf' directory
    curl --request POST http://api.labelary.com/v1/printers/24dpmm/labels/2x1/ \
      --form file=@"$zpl_file" \
      --header "Accept: application/pdf" > "pdf/${id}.pdf"

    # Check if the PDF was successfully created
    if [ $? -eq 0 ]; then
      echo "Label PDF successfully created: pdf/${id}.pdf"
    else
      echo "Error: Failed to create label PDF for ${id}."
    fi
  done
else
  echo "Error: No ZPL files found in the 'zpl' directory."
  rm -rf zpl
  exit 1
fi

# Remove the 'zpl' directory after processing
rm -rf zpl

echo "All ZPL files processed and 'zpl' directory removed."
