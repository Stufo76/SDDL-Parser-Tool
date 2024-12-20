# SDDL Parser Tool

[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://opensource.org/licenses/GPL-3.0)

## Overview
The **SDDL Parser Tool** is a PowerShell script designed to parse and translate SDDL (Security Descriptor Definition Language) strings into human-readable formats. It provides detailed analysis of both the Discretionary Access Control List (DACL) and System Access Control List (SACL), translating rights, audit flags, and security identifiers (SIDs) into understandable descriptions. The tool also supports saving the output to a file for further use.

## Features
- **Parse SDDL Strings**: Splits and interprets DACL and SACL sections.
- **Human-Readable Output**: Translates rights codes, audit flags, and SIDs into descriptive formats.
- **Error Handling**: Detects and reports malformatted SDDL strings and untranslatable SIDs.
- **Optional File Output**: Save the results to a specified file.

## Usage
### Requirements
- **PowerShell 5.1 or later** (tested on Windows environments).

### Download
Clone the repository or download the script file `SDDLParser.ps1` directly.

```bash
https://github.com/Stufo76/SDDL-Parser-Tool.git
```

### Execution
Run the script from PowerShell with the required parameters:

```powershell
.\SDDLParser.ps1 -SDDL "<your SDDL string>" [-OutputFile <path to output file>]
```

#### Parameters
- **`-SDDL`**: (Required) The SDDL string to parse.
- **`-OutputFile`**: (Optional) Path to a file where the output will be saved.

#### Example
```powershell
.\SDDLParser.ps1 -SDDL "D:(A;;RPWP;;;AU)(A;;RP;;;S-1-5-21-1234567890-1234567890-1234567890-12345)S:(AU;FA;RP;;;WD)" -OutputFile "C:\Temp\SDDL_Output.txt"
```

This will parse the provided SDDL string and save the output to `C:\Temp\SDDL_Output.txt`.

## Output Example
### DACL
```plaintext
=== DACL (Discretionary Access Control List) ===
Raw DACL Entry: A;;RPWP;;;AU
  ACE Type: Allow
  Rights: ReadProperty, WriteProperty
  Security Identifier: NT AUTHORITY\Authenticated Users
```

### SACL
```plaintext
=== SACL (System Access Control List) ===
Raw SACL Entry: AU;FA;RP;;;WD
  Audit Flags: Failure
  Rights: ReadProperty
  Security Identifier: Everyone
```

## License
This project is licensed under the [GPLv3 License](https://opensource.org/licenses/GPL-3.0). See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Feel free to fork this repository and submit a pull request with your improvements or bug fixes.

## Author
- **Diego Pastore (Stufo76)**
  - **Email**: stufo76@gmail.com
  - **Script URL**: [SDDLParser.ps1](https://raw.githubusercontent.com/Stufo76/SDDL-Parser-Tool/refs/heads/main/SDDLParser.ps1)

For any questions, issues, or suggestions, feel free to create an issue in this repository or contact the author via GitHub.
