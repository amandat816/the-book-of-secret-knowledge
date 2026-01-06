# Quick Reference Guide

A quick reference for common tasks when contributing to The Book of Secret Knowledge.

## First Time Setup

```bash
# 1. Fork the repository on GitHub
# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/the-book-of-secret-knowledge.git
cd the-book-of-secret-knowledge

# 3. Add upstream remote
git remote add upstream https://github.com/trimstray/the-book-of-secret-knowledge.git

# 4. Set up commit signing hook
mkdir -p .git/hooks
cat > .git/hooks/prepare-commit-msg << 'EOF'
#!/bin/bash
SOB=$(git var GIT_AUTHOR_IDENT | sed -n 's/^\(.*>\).*$/- signed-off-by: \1/p')
grep -qs "^$SOB" "$1" || echo "$SOB" >> "$1"
EOF
chmod +x .git/hooks/prepare-commit-msg
```

## Daily Workflow

### Start New Contribution

```bash
# Sync with upstream
git checkout master
git fetch upstream
git merge upstream/master
git push origin master

# Create feature branch
git checkout -b feature/your-feature-name
```

### Make Changes

```bash
# Edit README.md with your changes
vim README.md

# Check your changes
git diff

# Check links (optional but recommended)
./check-links.sh
```

### Submit Changes

```bash
# Stage changes
git add README.md

# Commit with automatic sign-off
git commit -m "Add: description of changes"

# Push to your fork
git push origin feature/your-feature-name

# Create pull request on GitHub
```

## Common Commands

### Check Link Validity

```bash
# Default check
./check-links.sh

# With custom delay and timeout
LINK_CHECK_DELAY=2 LINK_CHECK_TIMEOUT=15 ./check-links.sh
```

### Sync Fork with Upstream

```bash
git fetch upstream
git checkout master
git merge upstream/master
git push origin master
```

### Check Commit Signature

```bash
# View last commit
git log -1

# Should show "signed-off-by" line at the end
```

### Revert Uncommitted Changes

```bash
# Revert specific file
git checkout README.md

# Revert all changes
git checkout .
```

### View Status

```bash
# Check what's changed
git status

# See differences
git diff
```

## Troubleshooting

### Commit Hook Not Working

```bash
# Verify hook exists and is executable
ls -la .git/hooks/prepare-commit-msg
chmod +x .git/hooks/prepare-commit-msg
```

### Fork Out of Sync

```bash
# Force sync with upstream (careful: loses local changes)
git fetch upstream
git checkout master
git reset --hard upstream/master
git push origin master --force
```

### Accidental Commit to Master

```bash
# Move commits to new branch
git branch feature/your-feature-name
git reset --hard upstream/master
git checkout feature/your-feature-name
```

## Tips

- **Always** create a new branch for changes
- **Never** commit directly to master
- **Check** links before submitting PR
- **Keep** commits focused and atomic
- **Write** clear commit messages
- **Sync** your fork regularly

## Resources

- [Full Setup Guide](SETUP.md)
- [Contributing Guidelines](.github/CONTRIBUTING.md)
- [Code of Conduct](.github/CODE_OF_CONDUCT.md)

---

For detailed information, see [SETUP.md](SETUP.md).
