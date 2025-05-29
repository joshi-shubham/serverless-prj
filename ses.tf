resource "aws_ses_email_identity" "personal_email" {
  email = "shubjoshi2056@gmail.com"
}
resource "aws_ses_domain_identity" "domail_identity" {
  domain = "devopswithshubham.com"
}

resource "aws_ses_domain_mail_from" "domain_from_email" {
  domain           = aws_ses_domain_identity.domail_identity.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.domail_identity.domain}"
}

resource "aws_ses_domain_dkim" "domain_dkim" {
    domain = aws_ses_domain_identity.domail_identity.domain
}

