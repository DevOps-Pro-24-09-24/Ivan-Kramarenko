# Configure Git hooks

To configure Git hooks after cloning the repository, run the following command:
git config core.hooksPath .githooks

# Commit message formatting rules

All commit messages must start with the prefix `DJ-X:` or `DJ-XXXX:`, where `DJ` is the project abbreviation and `X` is the task number (0 to 100000).

**Example:**

DJ-1234: Implement user authentication feature

# Checking code formatting

`flake8` is used to check code formatting. Before a commit, Git automatically runs this linter.
To manually check the formatting, run the command: flake8
If formatting errors are found, they must be corrected before committing.
