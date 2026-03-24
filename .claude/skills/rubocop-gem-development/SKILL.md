---
name: rubocop-gem-development
description: RuboCop configuration and style enforcement for Ruby gem development. Use when setting up code style rules, configuring gemspec validation, organizing test files, or enforcing consistent formatting in library code. Essential for maintaining code quality standards in gem projects.
---

# RuboCop for Gem Development

Code style and quality enforcement for Ruby gems with RuboCop.

## When to Apply

- Setting up style rules for a new gem project
- Configuring gemspec validation and dependency management
- Organizing code structure and file patterns
- Enforcing consistent formatting across gem codebase
- Integrating with RSpec testing workflow

## Critical Rules

**Gemspec Ruby Version Consistency**: Match `required_ruby_version` with RuboCop's `TargetRubyVersion`

```ruby
# .rubocop.yml
AllCops:
  TargetRubyVersion: 3.1.4

# gemspec - WRONG
spec.required_ruby_version = '>= 3.1.4'

# gemspec - RIGHT
spec.required_ruby_version = '>= 3.1.4'
```

**Development Dependencies Location**: Specify dev dependencies in Gemfile, not gemspec

```ruby
# gemspec - WRONG
spec.add_development_dependency "rspec"
spec.add_development_dependency "rubocop"

# Gemfile - RIGHT
gem "rspec"
gem "rubocop"
```

**Top-Level Method Organization**: Wrap methods in modules/classes

```ruby
# WRONG
def utility_method
end

# RIGHT
module MyGem
  def self.utility_method
  end
end
```

## Key Patterns

### Gem Configuration Setup

```ruby
# .rubocop.yml
AllCops:
  TargetRubyVersion: 3.1.4
  Include:
    - "**/*.gemspec"
    - "**/Rakefile"
  Exclude:
    - "vendor/**/*"
    - "spec/fixtures/**/*"

inherit_gem:
  rubocop-rspec: .rubocop.yml

Gemspec/RequiredRubyVersion:
  Enabled: true

Bundler/GemFilename:
  EnforcedStyle: Gemfile
```

### Gemspec Validation Rules

```ruby
# gemspec with proper constraints
Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1.4'

  # Runtime dependencies with versions
  spec.add_dependency 'parser', '>= 2.3.3.1', '< 4.0'

  # No development dependencies in gemspec
  # spec.add_development_dependency "rspec" # WRONG
end
```

### File Pattern Configuration

```yaml
AllCops:
  Include:
    - "lib/**/*.rb"
    - "**/*.gemspec"
    - "**/Rakefile"
    - "exe/**/*"
  Exclude:
    - "bin/**/*"
    - "vendor/**/*"
    - "tmp/**/*"

# Cop-specific exclusions
Metrics/BlockLength:
  Exclude:
    - "spec/**/*_spec.rb"
    - "**/*.gemspec"
```

### Rake Integration

```ruby
# Rakefile
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
  task.fail_on_error = true
end

desc 'Run tests and style checks'
task default: [:spec, :rubocop]
```

### Inline Cop Control

```ruby
# Disable specific cops temporarily
# rubocop:disable Metrics/MethodLength
def complex_method
  # ... complex logic here
end
# rubocop:enable Metrics/MethodLength

# Single line disable
long_method_call(arg1, arg2, arg3) # rubocop:disable Layout/LineLength

# Disable with explanation
# rubocop:disable Style/ClassVars -- Needed for backwards compatibility
@@legacy_var = value
# rubocop:enable Style/ClassVars
```

## Auto-Correction Workflow

Use auto-correction to fix style violations:

```bash
# Fix safe violations automatically
rubocop -a

# Fix all violations (including unsafe)
rubocop -A

# Preview corrections without applying
rubocop --dry-run -a
```

## Common Mistakes

- **Missing version constraints** — Add version ranges to runtime dependencies in gemspec
- **Wrong dependency location** — Put development dependencies in Gemfile, not gemspec
- **Inconsistent Ruby versions** — Sync `required_ruby_version` with `TargetRubyVersion`
- **Overly broad exclusions** — Use cop-specific excludes instead of global patterns
