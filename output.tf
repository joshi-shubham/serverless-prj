output "dns_ids"{
    description = "DNS Records to add"
    value = aws_ses_domain_identity.domail_identity.verification_token
}
