# Contributing to Animation Blueprint DSL

Thank you for your interest in contributing!

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or feature requests
- Include your browser version and OS when reporting editor issues
- For UE-related issues, include your UE version

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- HTML/JS: Use meaningful variable names and add comments for complex logic
- YAML: Follow the schema defined in `SPEC.md`

### Testing

- Test the visual editor in Chrome/Edge (File System Access API support)
- Verify YAML export/import roundtrip works correctly

## Development Setup

```bash
# Start local server
cd editor
python -m http.server 8080

# Open in browser
# http://localhost:8080
```

## Questions?

Open an issue for discussion before submitting large pull requests.
