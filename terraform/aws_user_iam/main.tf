# Création de l'utilisateur IAM Terraform
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
}

# Génère une clé d'accès pour cet utilisateur
resource "aws_iam_access_key" "terraform_key" {
  user = aws_iam_user.terraform_user.name
}

# Attache la policy admin (bootstrap uniquement)
resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}