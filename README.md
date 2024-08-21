# ZPL to PDF Label Generator

This repository contains a bash script to generate ZPL (Zebra Programming Language) files from a list of IDs and optionally add suffixes to those IDs. The generated ZPL files are then converted to PDF labels using the Labelary API.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Scripts](#scripts)
  - [generate_pdfs.sh](#generate_pdfssh)
  - [generate_zpl.R](#generate_zplr)
- [License](#license)

## Overview

This project provides a convenient way to generate barcode labels in ZPL format and convert them to PDF using the Labelary API. It is particularly useful for scenarios where you need to produce multiple labels with unique identifiers and optional suffixes.

## Prerequisites

- [R](https://cran.r-project.org/) installed on your machine.
- Basic command-line knowledge.
- Internet connection (for converting ZPL to PDF via Labelary API).
- [Homebrew](https://brew.sh/) for installing utilities (optional).

## Installation

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/yourusername/zplabel.git
    cd zplabel
    ```

2. **Install Required Utilities:**

    If you want to merge PDFs later, you may need `pdfunite`:

    ```bash
    brew install poppler
    ```

## Usage

### Generating ZPL Files and Converting to PDF

1. **Prepare a Text File:**

   Create a text file (`ids.txt`) with one ID per line, e.g.:

    ```plaintext
    ID001
    ID002
    ID003
    ```

2. **Run the Bash Script:**

    To generate ZPL files and convert them to PDFs, use the following command:

    ```bash
    ./zpl_curl.sh ids.txt "-EDTA -ADP-L -ADP-M"
    ```

    - The ZPL files will be generated in the `zpl` directory.
    - The PDFs will be saved in the `pdf` directory.
    - After processing, the `zpl` directory will be automatically removed.

    If no suffixes are needed, you can omit the second argument:

    ```bash
    ./generate_pdfs.sh ids.txt
    ```

## Scripts

### generate_pdfs.sh

This bash script orchestrates the entire process:

1. It calls the `generate_zpl.R` script to generate ZPL files from a list of IDs.
2. It uses `curl` to convert the generated ZPL files into PDFs via the Labelary API.
3. It saves the PDF files in the `pdf` directory and cleans up the `zpl` directory.

**Usage:**

```bash
./generate_pdfs.sh <input_text_file> [suffixes]
