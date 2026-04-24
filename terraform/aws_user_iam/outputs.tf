# Affiche l'Access Key ID
output "access_key" {
  value = aws_iam_access_key.terraform_key.id
}

# Affiche le Secret Access Key (visible temporairement)
output "secret_key" {
  value = aws_iam_access_key.terraform_key.secret
  sensitive = true
}