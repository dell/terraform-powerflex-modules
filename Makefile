docs:
	# install via
	# go install github.com/terraform-docs/terraform-docs@v0.17.0
	terraform-docs markdown table --output-file README.md --output-mode inject modules/sdc_host_linux/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_linux/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_esxi/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/sdc_host_esxi/
	terraform-docs markdown table --output-file README.md --output-mode inject modules/user/
	terraform-docs markdown table --output-file README.md --output-mode inject examples/user/