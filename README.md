## Running the code
```bash
$ terraform init
$ terraform fmt
$ terraform validate
$ terraform plan
$ terraform apply
```

## To run the pipeline
```bash
$ git add .
$ git commit -m "commit message"
$ git push origin dev
```

You push to dev, so you create a **Pull request** to merge your successful code into the main branch.

Code is successful if it runs through the pipeline (passes all tests) without throwing any errors.