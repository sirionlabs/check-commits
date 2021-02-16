# check-commits composite action

This action checks a repo for recent commits.

## Inputs

### `repo`

**Required** The name of the repo. Defaults to `${{ github.repository }}` which evaluates to the repo from which this action is used.

### `token`

**Required** The github api token used to access the repo. Defaults to `${{ github.token }}` which evaluates to the token used by the current action. If this action is run against another private repo, use an appropriate token for access.

### `days-since`

**Required** . Number of days since commits. Defaults to 1.

### `path`

**Optional** . Check for commits under this path instead of repo root. Defaults to repo root.

## Outputs

### `has-commits`

1 if repo has commits since the given date in the given path. 0 otherwise.

## Example usage

The following example shows a nightly job checking for commits since 2 days and only running the actual job if there are commits.

```yaml
jobs:
  check-commits:
    runs-on: ubuntu-latest
    outputs:
      result: ${{ steps.check-commits.outputs.has-commits }}

    steps:
      - name: check commits
        uses: sirionlabs/check-commits@v1
        id: check-commits
        with:
          days-since: '2'

  nightly-build:
    needs: check-commits
    if: needs.check-commits.outputs.result == '1'
```
