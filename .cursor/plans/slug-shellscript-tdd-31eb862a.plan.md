<!-- 31eb862a-0b4a-488c-bdcf-d043f86c07a4 759f7b82-8b0d-4380-9c62-ea5a2745a3b5 -->
# Create URL-Safe Slug Shellscript with TDD

## Implementation Approach

Following TDD principles, we'll create tests first, then implement the `slug` script incrementally to make each test pass.

### Core Transformation Logic

The slugification will:

1. Convert to lowercase using `tr '[:upper:]' '[:lower:]'`
2. Replace non-alphanumeric characters with hyphens using `tr -c '[:alnum:]\n' '-'`
3. Remove leading/trailing hyphens using `sed`
4. Collapse consecutive hyphens into single hyphens using `sed 's/--*/-/g'`

### Files to Create

1. **`spec/slug_spec.sh`** - ShellSpec tests covering:

- Script exists and is executable
- Usage message on stderr when no input or with `-h`/`--help`
- Reads from stdin, writes to stdout
- Basic slugification (lowercase, spaces to hyphens)
- Special character handling
- Multiple consecutive spaces/special chars → single hyphen
- Leading/trailing special chars removal
- Multi-line input (each line processed independently)
- Empty input handling
- Pipeline composability

2. **`slug`** - POSIX-compliant shellscript with:

- `#!/bin/sh` shebang with `set -eu`
- Help/usage handling for `-h`, `--help`, or no stdin
- Filter pattern: stdin → transformation → stdout
- Line-by-line processing using `while read` loop

## Test-Driven Development Sequence

Tests will be written incrementally, with implementation following after each failing test:

1. Script exists and executable → create basic script structure
2. Usage on no input → add stdin check and usage function
3. Usage on `-h`/`--help` → add argument parsing
4. Basic slugify → implement lowercase + space-to-hyphen
5. Special character handling → add non-alphanumeric replacement
6. Consecutive hyphens → add hyphen collapsing
7. Leading/trailing hyphens → add trimming logic
8. Multi-line processing → verify line-by-line behavior
9. Pipeline composability → test with other tools

### To-dos

- [ ] Create spec/slug_spec.sh with comprehensive test cases
- [ ] Create basic slug script structure to pass initial tests
- [ ] Implement usage function and argument handling
- [ ] Implement slugification transformation logic
- [ ] Handle edge cases (consecutive hyphens, leading/trailing, empty)
- [ ] Run all tests and ensure they pass