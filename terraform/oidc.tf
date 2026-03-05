resource "aws_iam_openid_connect_provider" "github" {
    url = "https://github.com/SuhaniSharmaJoshi/CICD_flask_project.git"

    client_id_list = [ 
        "sts.amazonaws.com"
     ]
    thumbprint_list = [
        "6938fd4d98bab03faadb97b34396831e3780aea1"
    ]
}