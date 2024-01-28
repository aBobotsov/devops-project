#### be-checks-basic.yml & fe-checks-basic.yml 
- Focuses on basic checks triggered by pushes to the repository. 
- It performs tasks such as enforcing EditorConfig rules, linting code, checking Markdown files, searching for hardcoded secrets using Gitleaks, and running unit tests. The health check for the container is exposed at the /health path.

#### be-checks-extended.yml & fe-checks-extended.yml 
- Extends the basic checks to be triggered specifically for pull requests related to the appropriate service. 
- It reuses the basic checks workflow.
- Performs a SonarCloud scan and runs a Snyk security scan.

#### be-build-deploy.yml & be-build-deploy.yml 
- Handles the deployment process triggered by pushes to the master branch. 
- It builds, pushes, and scans a Docker image
- Then deploys the application using Terraform for infrastructure provisioning. 

There's a consideration for deployment queues using action-workflow-queue
