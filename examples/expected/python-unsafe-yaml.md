# Expected Review: Python Unsafe YAML

classification: finding
severity: P1

The reviewer should report unsafe YAML deserialization. Replacing `yaml.safe_load` with `yaml.load(..., Loader=yaml.Loader)` can construct Python objects from attacker-controlled config content.

The finding should ask to keep `safe_load` unless the caller proves the file is trusted and object construction is required.
