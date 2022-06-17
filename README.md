# Weight Tracker Infrastructure As Code


 This project shows how to create Infrastrucure as code for the **Weight Tracker** app with **Terraform**.

The requested infrastructure:

![demo](doc/demo.png)


## Configuration

1. Create 2 virtual networks ,private and public network.
2. Create a Module to reuse creation of webserver virtual machines.
3. Create 3 virtual machines and add them to availability set and load balancer
4. Add NSG to public sunbet and allow access only from port 8080 and SSH with a specific IP address
5. Add NSG to private subnet and allow access only from the web app with port 5432.
6. Add PostgreSQL - Flexible Serve
7. Restrict access to server,allow connection only from the web server subnet 
7. Configure a terraform output, so the vm password can be retrieved during automation and set output to sensitive.
8.Use command: **terraform output  -json** to retrieve the VMs password.
8. Install the WeightTracker application and the Database into the VMs created by terraform .
9. Add Terraform backend to store the Terraform state in Azure Blob Storage


