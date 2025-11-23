# Changelog

All notable changes to this Terraform Cloud Armor module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-23

### Added

#### Core Security Policy Features
- Initial release of Terraform Google Cloud Armor security policy module
- Support for both Global and Regional security policies with automatic scope detection based on region parameter
- Global security policies via `google_compute_security_policy`
- Regional security policies via `google_compute_region_security_policy`
- Policy type configuration (CLOUD_ARMOR, CLOUD_ARMOR_EDGE)
- Configurable policy name and description

#### Layer 7 DDoS Protection
- Adaptive Protection configuration for Layer 7 DDoS defense (Global policies only)
- Configurable rule visibility options (STANDARD, PREMIUM)
- Enable/disable toggle for Layer 7 DDoS defense
- Input validation for rule visibility values

#### Advanced Options Configuration
- JSON parsing support with multiple modes (DISABLED, STANDARD, STANDARD_WITH_GRAPHQL)
- Configurable log levels (NORMAL, VERBOSE)
- Custom user IP request headers for client IP resolution
- JSON custom content types configuration for custom JSON parsing
- Request body inspection size configuration
- Dynamic advanced options enabling based on configuration values

#### Security Rule Types

**IP-based Security Rules**
- Block or allow traffic based on source IP ranges (SRC_IPS_V1)
- Support for multiple IP ranges per rule
- IPv4 and IPv6 CIDR notation support
- Rule prioritization (0-2147483647)
- Preview mode for testing rules without enforcement
- Support for both global and regional policies

**Pre-configured WAF Rules**
- Integration with Google Cloud Armor managed WAF rule sets
- Configurable sensitivity levels (0-4)
- Opt-in rules via `include_target_rule_ids`
- Opt-out rules via `exclude_target_rule_ids`
- Automatic CEL expression generation for WAF rules based on configuration
- Support for all Google Cloud Armor WAF rule sets
- Smart handling of rule combinations

**Custom Rules**
- CEL (Common Expression Language) based custom security rules
- Full expression support for complex matching logic
- Request path, header, method, and geographic matching
- Combined conditions support
- Flexible rule expressions for advanced use cases

#### Rate Limiting Capabilities
- Rate-based ban actions with configurable thresholds
- Throttle actions for traffic control
- Multiple enforcement key options:
  - IP-based enforcement (`IP`)
  - HTTP header-based enforcement (`HTTP_HEADER`)
  - Global enforcement (`ALL`)
  - X-Forwarded-For enforcement (`XFF_IP`)
  - Custom enforcement key configurations
  - Multiple enforcement key configs support
- Configurable rate limit thresholds (count and interval)
- Optional ban thresholds for rate-based bans
- Ban duration configuration for rate-based bans (in seconds)
- Support for rate limiting on all rule types (IP-based, pre-configured WAF, custom)

#### WAF Rule Exclusions
- Pre-configured WAF exclusions support for fine-tuning false positives
- Request header-based exclusions with multiple operators
- Request cookie-based exclusions with multiple operators
- Request URI-based exclusions with multiple operators
- Request query parameter-based exclusions with multiple operators
- Multiple exclusion operators support (EQUALS, EQUALS_ANY, STARTS_WITH, ENDS_WITH, CONTAINS, etc.)
- Exclusions applicable to both pre-configured WAF and custom rules
- Target specific rule IDs within rule sets

#### Rule Actions
- `allow` - Allow matching traffic
- `deny(status)` - Deny with custom HTTP status code (e.g., deny(403), deny(404))
- `rate_based_ban` - Temporarily ban IPs exceeding rate limits
- `throttle` - Throttle matching traffic
- `redirect` - Redirect matching traffic

#### Rule Management
- Priority-based rule ordering (lower priority number executes first)
- Preview mode for testing rules without enforcement
- Custom descriptions for each rule
- Dynamic rule creation based on map configuration
- Support for conditional rule creation

#### Regional Policy Features
- Automatic default rule creation for regional policies
- Configurable default rule action (allow/deny with status)
- Default rule with lowest priority (2147483647)
- Support for all rule types in regional policies (IP-based, pre-configured WAF, custom)

#### Smart Rule Expression Generation
- Automatic WAF expression generation based on sensitivity levels
- Smart handling of opt-in rule configurations (include_target_rule_ids)
- Smart handling of opt-out rule configurations (exclude_target_rule_ids)
- Expression merging for complex rule combinations
- Base64 encoding for exclusion keys to handle special characters

#### Outputs
- `policy` - Complete security policy resource (global or regional)
- `security_policy_id` - Security policy ID
- `security_policy_self_link` - Security policy self link
- `security_rules` - All created security rules (merged from global and regional)

### Technical Requirements
- Terraform >= 1.5.0
- Google Provider >= 7.0.0, < 8.0.0
- Google Beta Provider >= 7.0.0, < 8.0.0