# devops-bootcamp-project

## 1. Introduction

This is a small devops bootcamp project that consists of a VPC with a public subnet and a private subnet. A microsite is hosted on a web server that resides in the public subnet. Meanwhile, in the private subnet, resides a monitoring server and a controller server. Only web server is assigned with an elastic IP.

The microsite is a Three.js-based which containerized and pushed to AWS ECR. The Docker on web server is installed via Ansible Galaxy role, geerlingguy.docker. The web server also hosts the Prometheus Node Exporter, which a tool that collects hardware and operating-system metrics from a Linux server. The web server is exposed to the public hence it accepts HTTP communication from any source besides the communication with monitoring server on port 9100.

These metrics are further send to the monitoring server. The monitoring server hosts the Prometheus and Grafana. Prometheus collects and stores metrics while Grafana displays and visualizes those metrics. The scrape-data are send from node exporter to Prometheus via TCP connection on port 9100. The data further send to Grafana via TCP connection on port 9090 for visualization purpose. Since Grafana is resides in the private subnet, the secured communication with the Internet is realized with Cloudflare Tunnel. The monitoring server is not exposed to the public as there is no port opened for ingress flow. The private subnet is connected to a NAT gateway and the NAT gateway is connected to a Internet gateway so that the Cloudflate tunnelling can be realized.

The another server is the controller server or Ansible controller which serves as a jump server. All Ansible configurations of the web server and the monitoring server are run from the controller server. No specific requirements for controller server except it should installed with AWS, Ansible, and SSM tool in order to serve as Ansible controller.

Please note that only web server is exposed to the public. So, it allows HTTP communication. Meanwhile, for the other servers, no outside exposure is allowed and the communication is via SSM only. Even, the SSH protocol is not set up for all servers.

## 2. Deployment 

### 2.1 Pre-Deployment

1. First of all, the Three.js microsite source code is packaged as a Docker image by using the multi-stage method. The Dockerfile is available in this repository. Then, then image is build and pushed to ECR.

2. Since the all communications are on SSM, few adjustments on IAM roles need to be done. This is to accomodate the Ansible command session on SSM and to provide EC2 role the permission to authenticate and pull images from ECR. The role name that used in this project is "EC2-SSM-Role". If you wanted to use the existing name, then just create the role from AWS console (IAM - Roles) with the policies as shown below:

<u>Policy Type - AWS Managed</u>
- AmazonEC2ContainerRegistryReadOnly
- AmazonS3FullAccess
- AmazonSSMManagedInstanceCore

<u>Policy Type - Customer Managed</u>
- Please use the JSON below and you may named it "Ansible-SSM-Access".

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AnsibleSSMSession",
            "Effect": "Allow",
            "Action": [
                "ssm:StartSession",
                "ssm:TerminateSession",
                "ssm:ResumeSession"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AnsibleSSMDescribe",
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeInstanceInformation"
            ],
            "Resource": "*"
        }
    ]
}

3. Add you domain to Cloudflare, create a record for sub-domain "web", and create a tunnel (type as cloudflared) for sub-domain "monitoring". In this project, the respective urls are web.hy4dev.com and monitoring.hy4dev.com. Please note, these urls may not live all the time as it serves for the bootcamp project only (temporary).

4. Create an S3 bucket for Terraform state file (tfstate). Please refer to providers.tf for the details and change the particular fields to match with the bucket that you created from AWS console.

5. For ec2.tf and playbook-web.yaml, please change the AWS account to your own account.

### 2.2 Deployment

1. Considering the repository is successfully cloned to you local machine (WSL Ubuntu), navigate to /terraform folder.
2. Perform the terraform init, terraform plan, and terraform apply instruction.
3. Once you have done with terraform apply, you can see the terraform output.
4. Copy the command to SSM to controller server and execute it or you may SSM from AWS console.
5. In SSM session of controller server, execute 'bash' and then 'cd'.
6. Please verify whether or not the terraform apply has successfully executed the command to install Ansible and SSM session plugin via batch script.
    - ansible --version
    - session-manager-plugin --version
7. If not found, please install Ansible and SSM plugin.
8. git clone https://github.com/hy4dev/devops-bootcamp-project.git
9. Since this is just a small project, please copy the content of inventory.ini that can be found from local machine and paste it to the newly created inventory.ini in ansible folder of controller server.
10. Run "ansible-playbook playbook-awscli.yaml".
11. Run "ansible-galaxy install -r requirements-ansible-galaxy.yml".
12. Run "ansible-playbook playbook-monitoring.yaml".
13. Run "ansible-playbook playbook-web.yaml"
14. Verify whether or not the microsite up and running by `http://{web_server_elastic_ip}:80`.
15. If the microsite is up and running, then open the DNS records of Cloudflare and replace the IP with the latest elastic IP. If the record was not created before, create it and linked the IP with the "web" sub-domain. 
16. Verify the access to the web.
17. Open the created tunnel from Cloudflare and click "Add a connector" button. If the tunnel was not created before, create a Cloudflared-type tunnel.
18. Select the OS as Debian (as the OS of EC2 is Ubuntu), and you will see the two commands to run.
19. Proceed to SSM to monitoring server and execute 'bash' and 'cd'.
20. Copy the commands and executed it on controller server.
21. If there is no issue, Cloudflare will show status of the tunnel as "Healthy" and you may veriy the access to Grafana.










