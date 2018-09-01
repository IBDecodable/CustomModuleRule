# IBlinter plugin for CustomModuleRule

Check if custom class match custom module by `custom_module_rule` config.


## Configuration

| key                  | description                 |
|:---------------------|:--------------------------- |
| `custom_module_rule` | Custom module rule configs. |


### CustomModuleConfig

You can configure `custom_module` rule by `CustomModuleConfig` list.

| key        | description                                                                  |
|:-----------|:---------------------------------------------------------------------------- |
| `module`   | Module name.                                                                 |
| `included` | Path to `*.swift` classes of the module for `custom_module` lint.            |
| `excluded` | Path to ignore for `*.swift` classes of the module for `custom_module` lint. |


```yaml
enabled_rules:
  - relative_to_margin
disabled_rules:
  - custom_class_name
excluded:
  - Carthage
custom_module_rule:
  - module: UIComponents
    included:
      - UIComponents/Classes
    excluded:
      - UIComponents/Classes/Config/Generated
```
