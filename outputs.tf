output "policy" {
  value = length(google_compute_security_policy.security_policy) > 0 ? google_compute_security_policy.security_policy : (
    length(google_compute_region_security_policy.security_policy) > 0 ? google_compute_region_security_policy.security_policy : []
  )
  description = "Security policy created (global or regional)"
}

output "security_policy_id" {
  value = length(google_compute_security_policy.security_policy) > 0 ? google_compute_security_policy.security_policy[0].id : (
    length(google_compute_region_security_policy.security_policy) > 0 ? google_compute_region_security_policy.security_policy[0].id : null
  )
  description = "Security policy ID"
}

output "security_policy_self_link" {
  value = length(google_compute_security_policy.security_policy) > 0 ? google_compute_security_policy.security_policy[0].self_link : (
    length(google_compute_region_security_policy.security_policy) > 0 ? google_compute_region_security_policy.security_policy[0].self_link : null
  )
  description = "Security policy self link"
}

output "security_rules" {
  value = merge(
    { for k, v in google_compute_security_policy_rule.security_rules : k => v },
    { for k, v in google_compute_region_security_policy_rule.security_rules : k => v }
  )
  description = "Security policy rules created"
}