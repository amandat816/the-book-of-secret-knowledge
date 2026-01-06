# Development Environment Setup

This guide will help you set up your development environment to contribute to The Book of Secret Knowledge.

## Prerequisites

- Git
- A text editor (VS Code, Vim, Emacs, etc.)
- Bash shell (for running scripts)
- curl (for link checking)

## Getting Started

### 1. Fork and Clone the Repository

First, fork this repository on GitHub, then clone your fork:

```bash
git clone https://github.com/YOUR_USERNAME/the-book-of-secret-knowledge.git
cd the-book-of-secret-knowledge
```

### 2. Set Up Remote Upstream

Add the original repository as an upstream remote to keep your fork in sync:

```bash
git remote add upstream https://github.com/trimstray/the-book-of-secret-knowledge.git
git fetch upstream
```

### 3. Set Up Commit Signing (Required)

All commits must include a "signed-off-by" line. Set up the Git hook:

```bash
# Create the hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create the prepare-commit-msg hook
cat > .git/hooks/prepare-commit-msg << 'EOF'
#!/bin/bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
EOF

# Make it executable
chmod +x .git/hooks/prepare-commit-msg
```

Alternatively, you can use the `-s` flag when committing:

```bash
git commit -s -m "Your commit message"
```

### 4. Configure Git User Information

Ensure your Git user information is set:

```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

## Development Workflow

### Creating a New Branch

Always create a new branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

### Making Changes

1. Edit the `README.md` file with your changes
2. Follow the project's style guidelines:
   - Keep content inviting and clear
   - Ensure additions are useful and not tiring
   - Maintain quality over quantity

### Testing Your Changes

#### Check Markdown Syntax

You can use online tools or install a markdown linter locally:

```bash
# Using npx (requires Node.js)
npx markdownlint-cli README.md
```

#### Check Links

Use the link checker script to verify all links work:

```bash
# Basic link check
for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then 
    echo " -> $i - $_rcode"
  fi
done
```

**Note:** Some links may return non-200 codes due to rate limiting or temporary issues. Links marked with **\*** in the README are known to be temporarily unavailable.

### Committing Changes

```bash
git add README.md
git commit -m "Add: description of your changes"
# The prepare-commit-msg hook will automatically add your sign-off
```

### Pushing Changes

```bash
git push origin feature/your-feature-name
```

### Creating a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your feature branch
4. Fill in the PR template with:
   - Clear description of changes
   - One-line summary (don't continue on new lines)
   - Explanation of the problem and solution
5. Submit the pull request

## Keeping Your Fork Updated

Regularly sync your fork with the upstream repository:

```bash
# Fetch upstream changes
git fetch upstream

# Checkout your main branch
git checkout master

# Merge upstream changes
git merge upstream/master

# Push to your fork
git push origin master
```

## Style Guidelines

### Content Guidelines

- **Inviting and clear**: Make content accessible and easy to understand
- **Not tiring**: Keep entries concise and to the point
- **Useful**: Only add high-quality, valuable resources

### Formatting Guidelines

- Use consistent markdown formatting
- Check links before submitting
- Follow existing patterns in the README
- Use proper headings hierarchy

## Troubleshooting

### Hook Not Working

If the commit signing hook isn't working:

```bash
# Check if hook exists
ls -la .git/hooks/prepare-commit-msg

# Verify it's executable
chmod +x .git/hooks/prepare-commit-msg

# Test the hook
.git/hooks/prepare-commit-msg .git/COMMIT_EDITMSG
```

### Links Failing

If link checking is too slow or hitting rate limits:

```bash
# Add a delay between requests
for i in $(sed -n 's/.*href="\([^"]*\).*/\1/p' README.md | grep -v "^#") ; do
  _rcode=$(curl -s -o /dev/null -w "%{http_code}" "$i")
  if [[ "$_rcode" != "2"* ]] ; then 
    echo " -> $i - $_rcode"
  fi
  sleep 1  # Add 1 second delay
done
```

## Additional Resources

- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Contributing Guidelines](.github/CONTRIBUTING.md)
- [Code of Conduct](.github/CODE_OF_CONDUCT.md)

## Getting Help

If you need help:

1. Check the [CONTRIBUTING.md](.github/CONTRIBUTING.md) file
2. Search existing issues and pull requests
3. Open a new issue with your question
4. Join community discussions

---

Thank you for contributing to The Book of Secret Knowledge! 🎉
