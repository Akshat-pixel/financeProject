resource "aws_key_pair" "finance_key" {
  key_name   = "finance-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMHrMIvYmZrKExDR4qVZopqO2KDTTLPc+St52wkuMRq akshatjain@Akshats-MacBook-Air.local" # Ensure this file exists with your public key
  tags = {
    Name = "finance_project"
  }
}