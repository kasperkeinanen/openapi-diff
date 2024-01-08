# OpenAPI Diff Tool

> Created for own use, shared for others to use.

`openapi-diff.sh` is a Bash script for comparing the current version of an OpenAPI specification with its previous version. It highlights changes, helping maintainers to track and review updates in API specifications.

**NOTE:** Do not use this script with untrusted sources. The script stores the OpenAPI specs on your device, and sets variables from the spec file. This can be a security risk if you use the script with untrusted sources.

## Prerequisites

- Bash
- `jq`: Command-line JSON processor
- `diff`: File comparison tool

## Installation

1. Download the `openapi-diff.sh` script.
2. Make it executable: `chmod +x openapi-diff.sh`.

## Usage

You can run the script by either passing the OpenAPI spec file as an argument or piping the spec to the script.

- Using file argument:

```bash
./openapi-diff.sh <spec-file>
```

- Using standard input:
  
```bash
cat <spec-file> | ./openapi-diff.sh

# or
curl <spec-url> | ./openapi-diff.sh
```

By default, the script stores the OpenAPI specs in `~/.openapi-diff`. You can change this location by setting the `OPENAPI_DIFF_FOLDER` environment variable.

### Options

- `-h`, `--help`: Show the help message.

## Features

- Compares the current OpenAPI spec with the previous version.
- Highlights changes in the spec.
- Stores each OpenAPI spec for future comparison.
- Handles specs from file input or standard input.

## License

This script is provided under the MIT License. See the LICENSE file for more details.
