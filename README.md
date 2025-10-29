# piping-shellscript

Small composable shell scripts following the Unix Philosophy.

## Scripts

- **`color`**: Add ANSI color codes to text (red, green, blue, yellow, etc.)
- **`dedup`**: Remove duplicate lines, preserving first occurrence
- **`slug`**: Convert text into URL-friendly slugs
- **`transpose`**: Transpose lines of text (convert rows to columns)
- **`trim`**: Remove leading and trailing whitespace from lines
- **`wrap`**: Wrap lines at specified width, breaking at word boundaries
- **`plural_sv`**: Convert Swedish nouns to plural form

## The Unix Philosophy

> Write programs that do one thing and do it well.  
> Write programs to work together.  
> Write programs to handle text streams, because that is a universal interface.

[[Wikipedia](https://en.wikipedia.org/wiki/Unix_philosophy)]

**Core principles:**
- Do one thing well
- Read from `stdin`, write to `stdout`, use `stderr` for errors
- Compose with pipes
- Silent on success
- Exit with meaningful status codes (0 for success)

## POSIX Compliance

Use POSIX syntax for maximum portability across systems.

**Key rules:**
- Use `#!/bin/sh` shebang (not `#!/bin/bash`)
- Use `[` not `[[`, `=` not `==`
- Quote variables: `"$var"`
- Use `printf` instead of `echo` for complex output
- Functions use `()` syntax: `func_name() { ... }`
- No local variables
- Use `command -v` instead of `which`

**Example:**

```shell
#!/bin/sh
set -eu  # Exit on error, undefined variables

main() {
    while IFS= read -r line || [ -n "$line" ]; do
        # process line
        echo "$line"
    done
}

main "$@"
```

**Testing:**
- `shellcheck -s sh script.sh`
- [`shellspec`](https://github.com/shellspec/shellspec)

[[POSIX Shell](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18)]
[[Portable Shell Guide](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/autoconf.html#Portable-Shell)]
