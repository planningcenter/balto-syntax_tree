# 🐺 Balto SyntaxTree

Balto SyntaxTree is Smart and Fast:

* Installs _your_ version of [SyntaxTree](https://github.com/ruby-syntax-tree/syntax_tree)
* _Only_ runs on files that have changed

Balto SyntaxTree comprises a few different actions: 

* The core functionality is found at `planningcenter/balto-syntax_tree`, which runs `stree write` on files that have changed. On its own this doesn't result in any action, but it can be combined with other actions for a variety of uses.
* For a "batteries included" setup, `planningcenter/balto-syntax_tree/autofix` will run the core action, commit anything that changed as a result, and add that commit to `.git-blame-ignore-revs`.
* There's also a `planningcenter/balto-syntax_tree/append-to-file` action that is really here for internal use. If you're brave, you can use it on its own, but there are no guarantees that it won't change without notice.

## Example Usage

Assuming most folks will opt for the autofix functionality, here's how you might set that up.

Sample config (place in `.github/workflows/balto.yml`):

```yaml
name: Balto

on: [pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - uses: ruby/setup-ruby@v1
      - uses: planningcenter/balto-syntax_tree/autofix@v1
```

### Other Languages

While SyntaxTree does support [languages](https://github.com/ruby-syntax-tree/syntax_tree#languages) other than Ruby, this action does not support those at this time. Everything is very focused on Ruby files. If you need additional language support, feel free to open an issue to discuss or suggest a change with a pull request.

## Inputs

| Name | Description | Required | Default |
|:-:|:-:|:-:|:-:|
| `smartGemInstall` | Whether to try and install the fewest gems required to run RuboCop. When `"false"` it will run a full `bundle install`. | no | `"true"` |
