# Update axe-core

A GitHub action for updating [`axe-core`](https://github.com/dequelabs/axe-core) to the latest stable version.

## Example

```yaml
name: Update axe-core
on:
  workflow_dispatch:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          # We must use a personal access token in order for tests to run on the commit this workflow creates.
          token: ${{ secrets.PAT }}
      - uses: actions/setup-node@v3
        with:
          node-version: 16
      - name: Update axe-core
        uses: dequelabs/update-axe-core@main
        id: update
      - name: Open PR
        uses: peter-evans/create-pull-request@v3
        with:
          # Use a personal access token, enabling workflows to be triggered by opening the pull request
          token: ${{ secrets.PAT }}
          commit-message: "Update axe-core to v${{ steps.update.outputs.version }}"
          branch: auto-update-axe-core
          base: develop
          title: "Update axe-core to v${{ steps.update.outputs.version }}"
          body: |
            This patch updates version of [`axe-core`](https://npmjs.org/axe-core) to v${{ steps.update.outputs.version }} from ${{ steps.update.outputs.previous_version }}.
```
