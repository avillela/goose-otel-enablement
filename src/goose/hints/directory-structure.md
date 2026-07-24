# Directory Structure

The project directory structure is as follows:

```text
src/
  ├── docs/
  ├── goose/
  │   ├── hints/
  │   └── recipes/
  │       └── sub_recipes/
  ├── otel/
  ├── python/
  └── scripts/
```

* `src`: root for all source files
* `src/docs/`: root for all project documentation (except `README.md` at the project root)
* `src/goose/`: root for all goose files
* `src/goose/hints`: goose hints (except .`goosehints`, which go in the project root)
* `src/goose/recipes`: goose recipes
* `src/goose/recipes/sub_recipes`: goose sub-recipes
* `src/otel/`: OTel Collector config
* `src/python`: Python source code
* `src/scripts`: Bash scripts