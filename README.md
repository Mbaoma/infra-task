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

## To setup Certbot
Run  the ```setupcertbot.sh``` file.
```bash
$ chmod u+x setupcertbot.sh
$ ./setupcertbot.sh
```

You push to dev, so you create a **Pull request** to merge your successful code into the main branch.

Code is successful if it runs through the pipeline (passes all tests) without throwing any errors.

<img width="803" alt="image" src="https://user-images.githubusercontent.com/49791498/221283026-390e138c-9259-4b1e-9bb2-2351ed195edf.png">

## Nginx Config file
*/etc/nginx/nginx.conf*
<img width="679" alt="image" src="https://user-images.githubusercontent.com/49791498/221283392-3772a909-df72-4446-82ec-3db5c6746c74.png">
