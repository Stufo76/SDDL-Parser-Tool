# SDDL Parser Tool
# Author: Diego Pastore (Stufo76)
# Email: stufo76@gmail.com
# License: GPLv3
# Description: This script parses and translates SDDL (Security Descriptor Definition Language) strings into human-readable formats.
#              It provides detailed analysis of DACL (Discretionary Access Control List) and SACL (System Access Control List),
#              translating rights, audit flags, and security identifiers (SIDs) into understandable descriptions.

param(
    [string]$SDDL,          # The SDDL string to parse.
    [string]$OutputFile     # Optional file to save the output.
)

# Function to translate rights codes into human-readable permissions
function Translate-Rights {
    param ([string]$rights)

    # Mapping rights codes to their descriptions
    $translation = @{
        "CC" = "CreateChild"
        "DC" = "DeleteChild"
        "SW" = "SelfWrite"
        "LO" = "ListObject"
        "CR" = "ControlAccess"
        "RC" = "ReadControl"
        "SD" = "Delete"
        "WD" = "WriteDACL"
        "WO" = "WriteOwner"
        "RP" = "ReadProperty"
        "WP" = "WriteProperty"
        "DT" = "DeleteTree"
    }

    # Identify applied rights and translate them
    $translatedRights = @()
    foreach ($code in $translation.Keys) {
        if ($rights -match $code) {
            $translatedRights += $translation[$code]
        }
    }

    # Return translated rights as a comma-separated string
    return ($translatedRights -join ", ")
}

# Function to translate audit flags into human-readable descriptions
function Translate-AuditFlags {
    param ([string]$flags)

    # Mapping audit flags to their descriptions
    $translation = @{
        "S" = "Success"
        "F" = "Failure"
    }

    # Identify applied flags and translate them
    $translatedFlags = @()
    foreach ($code in $translation.Keys) {
        if ($flags -match $code) {
            $translatedFlags += $translation[$code]
        }
    }

    # Return translated flags as a comma-separated string
    return ($translatedFlags -join ", ")
}

# Ensure the SDDL string is provided
if (-not $SDDL) {
    Write-Host "Error: No SDDL string provided." -ForegroundColor Red
    return
}

# Start logging if an output file is specified
if ($OutputFile) {
    Start-Transcript -Path $OutputFile -Append
}

try {
    Write-Host "=== Processing SDDL ===" -ForegroundColor Cyan
    Write-Output "SDDL: $SDDL"

    # Split the SDDL string into DACL and SACL parts
    $parts = $SDDL -split "S:"
    $daclRaw = $parts[0] -replace "^D:\(", "" -replace "\)$", ""
    $saclRaw = $parts[1] -replace "^\(", "" -replace "\)$", ""

    # Process the DACL (Discretionary Access Control List)
    Write-Host "`n=== DACL (Discretionary Access Control List) ===" -ForegroundColor Green
    $daclEntries = $daclRaw -split "\)\("
    foreach ($entry in $daclEntries) {
        Write-Output "Raw DACL Entry: $entry"

        if ($entry -match "^(A|D);;([^;]+);;;([^;]+)$") {
            $aceType = $matches[1]
            $rights = $matches[2]
            $sid = $matches[3]

            # Translate the SID (Security Identifier)
            $translatedSid = try {
                (New-Object System.Security.Principal.SecurityIdentifier $sid).Translate([System.Security.Principal.NTAccount])
            } catch {
                $sid  # Return raw SID if translation fails
            }

            # Translate rights to human-readable format
            $humanReadableRights = Translate-Rights -rights $rights

            Write-Host "  ACE Type: $(if ($aceType -eq 'A') { 'Allow' } else { 'Deny' })"
            Write-Host "  Rights: $humanReadableRights"
            Write-Host "  Security Identifier: $translatedSid"
        } else {
            Write-Host "  Invalid DACL entry format: $entry" -ForegroundColor Yellow
        }
    }

    # Process the SACL (System Access Control List)
    Write-Host "`n=== SACL (System Access Control List) ===" -ForegroundColor Green
    $saclEntries = $saclRaw -split "\)\("
    foreach ($entry in $saclEntries) {
        Write-Output "Raw SACL Entry: $entry"

        if ($entry -match "^([^;]+);([^;]+);([^;]+);;;([^;]+)$") {
            $auditFlags = $matches[2]
            $rights = $matches[3]
            $sid = $matches[4]

            # Translate the SID (Security Identifier)
            $translatedSid = try {
                (New-Object System.Security.Principal.SecurityIdentifier $sid).Translate([System.Security.Principal.NTAccount])
            } catch {
                $sid  # Return raw SID if translation fails
            }

            # Translate rights and audit flags to human-readable format
            $humanReadableRights = Translate-Rights -rights $rights
            $humanReadableFlags = Translate-AuditFlags -flags $auditFlags

            Write-Host "  Audit Flags: $humanReadableFlags"
            Write-Host "  Rights: $humanReadableRights"
            Write-Host "  Security Identifier: $translatedSid"
        } else {
            Write-Host "  Invalid SACL entry format: $entry" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "Error: An error occurred while parsing the SDDL. $_" -ForegroundColor Red
} finally {
    if ($OutputFile) {
        Stop-Transcript
        Write-Host "Results saved to $OutputFile"
    }
}
