resource "aws_instance" "sonarqube-01" {
  ami                         = "ami-0557a15b87f6559cf" # free tier AMI image
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.public-subnet1.id
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.class-demo-sg.id}"]
  user_data                   = file("sonar_script.sh")
  key_name                    = "testkp2024" # Existing ssh key 
  
  tags = {
    Name        = "sonarqube-01"
    Builder     = "Dennis O"
    Application = "SonarQube-App"
    Date        = "12/9/2024"
  }
}

resource "aws_instance" "sonarqube-02" {
  ami                         = "ami-0557a15b87f6559cf" # free tier AMI image
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.public-subnet2.id
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.class-demo-sg.id}"]
  user_data                   = file("sonar_script.sh")
  key_name                    = "testkp2024"

  tags = {
    Name        = "sonarqube-02"
    Builder     = "Dennis O"
    Application = "SonarQube-App"
    Date        = "12/9/2024"
  }
}