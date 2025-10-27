# piping-shellscript

Exploring how to create small composable shell scripts that follows the Unix Philosophy.

## Scripts

All scripts are located in the `bin/` directory.

### Available Scripts

- **`slug`**: Convert text into URL-friendly slugs by lowercasing and replacing non-alphanumeric characters with hyphens
- **`dedup`**: Remove duplicate lines, preserving the first occurrence of each unique line
- **`trim`**: Remove leading and trailing whitespace from each line

## The Unix Philosophy

* Write programs that do one thing and do it well. 
* Write programs to work together. 
* Write programs to handle text streams, because that is a universal interface.

[[Wikipedia](https://en.wikipedia.org/wiki/Unix_philosophy)]

This translates to the following core principles for shell scripting:

1. **Do one thing well**: each program should do one thing and do it well. One script, one transformation/operation. Small is beautiful.
2. **Everything is a file**: treat devices, processes, and data uniformly as files or streams, enabling consistent interfaces.
3. **Make each program a filter**: programs should read from `stdin` and write to `stdout`, enables piping and composition. Use `stderr` for errors and diagnostics, keeps data stream clean.
4. **Produce parseable output**: plain text, line-oriented when possible, tool-friendly.
5. **Use software leverage**: build on existing tools rather than reinventing functionality.
6. **Silent on success**: programs should be quiet when they succeed and only produce output when necessary.
7. **Exit with meaningful status codes**: 0 for success, non-zero for errors

## POSIX compliance

For maximum portability, write POSIX syntax shell scripts that are able to run on any POSIX-compliant system (which includes most Linux distributions and macOS and other Unix-like systems).

[[Wikipedia](https://en.wikipedia.org/wiki/POSIX)]

[[POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18)]

[[Autoconf guide to portable shell](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/autoconf.html#Portable-Shell)]

1. Use the POSIX shebang

    ```shell
    #!/bin/sh
    ```

    Never use `#!/bin/bash`, `#!/usr/bin/env bash` or other shell-specific shebangs.

2. Avoid Bash-specific features

    * No arrays: Use positional parameters or temporary files instead
    * No `[[` test operator: Use `[` (single brackets) only
    * No `==` in tests: Use `=` for string equality
    * No `{1..10}` brace expansion: Use seq or loops
    * No `$'...'` quoting: Use standard quoting
    * No process substitution `<(...)`: Use temporary files

3. POSIX-compliant syntax

    ```shell
    # Good - POSIX compliant
    if [ "$var" = "value" ]; then
        echo "match"
    fi

    # Bad - Bash specific
    if [[ $var == "value" ]]; then
        echo "match"
    fi
    ```

4. Variable handling

    ```shell
    # Always quote variables
    echo "$variable"

    # Parameter expansion (POSIX subset)
    ${var:-default}    # Use default if unset
    ${var#prefix}      # Remove shortest prefix
    ${var%suffix}      # Remove shortest suffix
    ```

5. Portable commands and options

    * Use `command -v` instead of `which`
    * Avoid GNU-specific options (like `ls --color`)
    * Use `printf` instead of `echo` for complex output
    * Use test or `[` instead of `[[`
    * Functions must use `()` syntax, not `function` keyword
    * No local variables 
    * No `source` command (use `.` instead)
    * No `pushd`/`popd`

6. Example POSIX script structure

    ```shell
    #!/bin/sh
    set -eu  # Exit on error, undefined variables

    # Function definition (POSIX style)
    check_dependency() {
        if ! command -v "$1" >/dev/null 2>&1; then
            printf "Error: %s not found\n" "$1" >&2
            exit 1
        fi
    }

    # Main logic
    main() {
        check_dependency "curl"
        
        # Use printf for reliable output
        printf "Processing file: %s\n" "$1"
        
        # POSIX-compliant conditional
        if [ -f "$1" ]; then
            # Process file
            cat "$1" | tr '[:lower:]' '[:upper:]'
        else
            printf "File not found: %s\n" "$1" >&2
            exit 1
        fi
    }

    # Call main with all arguments
    main "$@"
    ```

7. Testing for POSIX compliance

    * Use shellcheck with POSIX mode, automatically engaged with shebang `#!/bin/sh`, or manually with `shellcheck -s sh script.sh`
    * Use [`shellspec`](https://github.com/shellspec/shellspec) for test driving scripts.
