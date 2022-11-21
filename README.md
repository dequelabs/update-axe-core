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
      - run: dequelabs/update-axe-core@main
        id: update
      - name: Open PR
        uses: peter-evans/create-pull-request@v3
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "chore: Update axe-core to v${{ steps.update.outputs.Version }}"
          branch: auto-update-axe-core
          base: develop
          title: "chore: Update axe-core to v${{ steps.update.outputs.Version }}"
          body: |
            This patch updates version of [`axe-core`](https://npmjs.org/axe-core) to v${{ steps.update.outputs.Version }}.

            This PR was opened by a robot :robot: :tada:.
```
