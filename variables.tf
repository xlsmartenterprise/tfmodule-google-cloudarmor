variable "project_id" {
  description = "The project ID of the VPC network"
  type        = string
}

variable "region" {
  description = "Region for regional policy. Set to null for global policy"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of security policy"
  type        = string
}

variable "description" {
  description = "Description of security policy"
  type        = string
  default     = null
}

variable "type" {
  description = "Type indicates the intended use of the security policy. Possible values are CLOUD_ARMOR and CLOUD_ARMOR_EDGE"
  type        = string
  default     = "CLOUD_ARMOR"
}

# Adaptive Protection Config (Layer 7 DDoS Defense) - Global only
variable "enable_layer7_ddos_defense" {
  description = "Enable Layer 7 DDoS Defense (Adaptive Protection). Only available for Global policies"
  type        = bool
  default     = false
}

variable "layer7_ddos_defense_enable" {
  description = "Enable the Layer 7 DDoS defense config"
  type        = bool
  default     = true
}

variable "layer7_ddos_defense_rule_visibility" {
  description = "Rule visibility for Layer 7 DDoS defense. Possible values: STANDARD, PREMIUM"
  type        = string
  default     = "STANDARD"
  validation {
    condition     = var.layer7_ddos_defense_rule_visibility == null || contains(["STANDARD", "PREMIUM"], var.layer7_ddos_defense_rule_visibility)
    error_message = "Rule visibility must be either STANDARD or PREMIUM"
  }
}

# Advanced Options Config
variable "json_parsing" {
  description = "JSON body parsing. Possible values are: DISABLED, STANDARD, STANDARD_WITH_GRAPHQL"
  type        = string
  default     = null
}

variable "log_level" {
  description = "Logging level. Possible values are: NORMAL, VERBOSE"
  type        = string
  default     = null
}

variable "request_body_inspection_size" {
  description = "An optional list of case-insensitive request header names to use for resolving the callers client IP address"
  type        = string
  default     = null
}

variable "user_ip_request_headers" {
  description = "An optional list of case-insensitive request header names to use for resolving the callers client IP address"
  type        = list(string)
  default     = []
}

variable "json_custom_content_types" {
  description = "A list of custom Content-Type header values to apply the JSON parsing. Only applicable when JSON parsing is set to STANDARD"
  type        = list(string)
  default     = []
}

# Pre-configured Rules
variable "pre_configured_rules" {
  description = "Map of pre-configured rules with Sensitivity levels"
  type = map(object({
    action                  = string
    priority                = number
    description             = optional(string)
    preview                 = optional(bool, false)
    target_rule_set         = string
    sensitivity_level       = optional(number, 4)
    include_target_rule_ids = optional(list(string), [])
    exclude_target_rule_ids = optional(list(string), [])
    rate_limit_options = optional(object({
      enforce_on_key      = optional(string)
      enforce_on_key_name = optional(string)
      enforce_on_key_configs = optional(list(object({
        enforce_on_key_name = optional(string)
        enforce_on_key_type = optional(string)
      })))
      exceed_action                        = optional(string)
      rate_limit_http_request_count        = optional(number)
      rate_limit_http_request_interval_sec = optional(number)
      ban_duration_sec                     = optional(number)
      ban_http_request_count               = optional(number)
      ban_http_request_interval_sec        = optional(number)
    }), {})

    preconfigured_waf_config_exclusions = optional(map(object({
      target_rule_set = string
      target_rule_ids = optional(list(string), [])
      request_header = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_cookie = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_uri = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_query_param = optional(list(object({
        operator = string
        value    = optional(string)
      })))
    })), null)

  }))

  default = {}
}

# Security Rules (IP-based)
variable "security_rules" {
  description = "Map of Security rules with list of IP addresses to block or unblock"
  type = map(object({
    action        = string
    priority      = number
    description   = optional(string)
    preview       = optional(bool, false)
    src_ip_ranges = list(string)
    rate_limit_options = optional(object({
      enforce_on_key      = optional(string)
      enforce_on_key_name = optional(string)
      enforce_on_key_configs = optional(list(object({
        enforce_on_key_name = optional(string)
        enforce_on_key_type = optional(string)
      })))
      exceed_action                        = optional(string)
      rate_limit_http_request_count        = optional(number)
      rate_limit_http_request_interval_sec = optional(number)
      ban_duration_sec                     = optional(number)
      ban_http_request_count               = optional(number)
      ban_http_request_interval_sec        = optional(number)
      }),
    {})
  }))

  default = {}
}

# Custom Rules
variable "custom_rules" {
  description = "Custom security rules"
  type = map(object({
    action      = string
    priority    = number
    description = optional(string)
    preview     = optional(bool, false)
    expression  = string
    rate_limit_options = optional(object({
      enforce_on_key      = optional(string)
      enforce_on_key_name = optional(string)
      enforce_on_key_configs = optional(list(object({
        enforce_on_key_name = optional(string)
        enforce_on_key_type = optional(string)
      })))
      exceed_action                        = optional(string)
      rate_limit_http_request_count        = optional(number)
      rate_limit_http_request_interval_sec = optional(number)
      ban_duration_sec                     = optional(number)
      ban_http_request_count               = optional(number)
      ban_http_request_interval_sec        = optional(number)
      }),
    {})

    preconfigured_waf_config_exclusions = optional(map(object({
      target_rule_set = string
      target_rule_ids = optional(list(string), [])
      request_header = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_cookie = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_uri = optional(list(object({
        operator = string
        value    = optional(string)
      })))
      request_query_param = optional(list(object({
        operator = string
        value    = optional(string)
      })))
    })), null)

  }))
  default = {}
}

# Default Rule
variable "default_rule_action" {
  description = "Default rule that allows/denies all traffic with the lowest priority (2,147,483,647)"
  type        = string
  default     = "allow"
}

variable "global_preview_mode" {
  description = "If true, all security rules, custom rules, and pre-configured WAF rules run in preview mode (logging only, no blocking)"
  type        = bool
  default     = false
}