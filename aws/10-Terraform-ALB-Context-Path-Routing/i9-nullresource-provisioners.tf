resource "null_resource" "main" {
    # Changes to any instance of the cluster requires re-provisioning
    depends_on = [
        module.public_ec2_instance
    ]
    connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = aws_eip.main.public_ip
        private_key = file("private-key/sample-kp.pem")
    }

    # File Provisioners: Copies the .pem file to /temp/terraform-key.pem
    provisioner "file" {
        source = "private-key/sample-kp.pem"
        destination = "/tmp/sample-kp.pem"
    }

    # Remote Exec Provisioner: Using remote-exec provisioner to fix the private key permission
    provisioner "remote-exec" {
        inline = [
            "sudo chmod 400 /tmp/sample-kp.pem"
        ]
    }

    # Local Exec Provisioner: Local-exec provisioner (Creation-Time Provisioner)
    provisioner "local-exec" {
        command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
        working_dir = "local-exec-output-files"
        on_failure = continue
    }
    # can be used for logging, when terraform infrastructure is created.

    # When Destroy - Destroy Time Provisioner
    # Local Exec Provisioner: Local-exec provisioner (Creation-Time Provisioner)
    # provisioner "local-exec" {
    #     command = "echo VPC destroy on `date` >> destroy-time-vpc-id.txt"
    #     working_dir = "local-exec-output-files"
    #     when = destroy
    # }
    # can be used for logging, when was terraform destroy triggered.

}
