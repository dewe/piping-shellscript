# Testing Guide

ShellSpec tests using fakes and HTML fixtures for external API calls.

## Structure

```text
spec/
├── fixtures/                     # HTML fixtures for Wiktionary responses
├── plural_sv_spec.sh             # Plural SV unit tests (with fakes)
├── plural_sv_integration_spec.sh # Plural SV integration tests (real API)
└── ...                           # Other script tests (without fakes)
```

## Faking External Commands

### Problem
`plural_sv` fetches HTML from Wiktionary using `curl`. Tests shouldn't depend on external networks.

### Solution: PATH Manipulation
Use PATH manipulation instead of ShellSpec's `Mock` directive:

1. **BeforeAll**: Creates a temporary directory with a fake `curl` script
2. **Fake script**: Extracts the word from the URL and returns the corresponding HTML fixture
3. **PATH injection**: Prepends the fake directory to `$PATH` so the fake overrides the real `curl`
4. **AfterAll**: Cleans up the temporary directory

### How It Works

The fake `curl` script:
- Parses curl arguments (`-s`, `--max-time`, etc.)
- Extracts the word from the URL (e.g., `https://sv.wiktionary.org/wiki/kvinna` → `kvinna`)
- Returns the content of `spec/fixtures/kvinna.html`

### Adding More Fixtures

1. Fetch the HTML from Wiktionary:

   ```sh
   curl -s "https://sv.wiktionary.org/wiki/mittord" > spec/fixtures/mittord.html
   ```

2. Add a test case to `plural_sv_spec.sh`

3. The mock automatically uses the fixture

## Running Tests

```sh
# Run all tests (unit + integration)
make test

# Run only unit tests (with fakes)
shellspec spec/plural_sv_spec.sh

# Run only integration tests (against real Wiktionary)
shellspec spec/plural_sv_integration_spec.sh
```

## Integration Tests

`plural_sv_integration_spec.sh` verifies the script works with the real Wiktionary API:
- 3 basic test words
- Requires network access
- Can be skipped if network is unavailable
