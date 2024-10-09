docs:
    # install via
    # go install github.com/terraform-docs/terraform-docs@v0.19.0
	terraform-docs markdown table --output-file README.md --output-mode inject modules/sdc_host_linux/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_linux/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_esxi/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_esxi/
	terraform-docs markdown table --output-file README.md --output-mode inject modules/sdc_host_win/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_win/
	terraform-docs markdown table --output-file README.md --output-mode inject modules/user/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/user/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/vsphere-ova-vm-deployment/
	terraform-docs markdown table --output-file README.md --output-mode inject modules/vsphere-ova-vm-deployment/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/vsphere_pfmp_installation/
	terraform-docs markdown table --output-file README.md --output-mode inject modules/vsphere_pfmp_installation/
