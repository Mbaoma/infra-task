## Create the infrastructure manually
```bash
$ terraform init
$ terraform fmt
$ terraform validate
$ terraform plan
$ terraform apply
```

## To run the CI/CD pipeline
```bash
$ git add .
$ git commit -m "commit message"
$ git push origin dev
```

## To setup [Certbot](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04)
Run  the ```setupcertbot.sh``` file.
```bash
$ chmod u+x setupcertbot.sh
$ ./setupcertbot.sh
```

You push to dev, so you create a **Pull request** to merge your successful code into the main branch.

Code is successful if it runs through the pipeline (passes all tests) without throwing any errors.

<img width="803" alt="image" src="https://user-images.githubusercontent.com/49791498/221283026-390e138c-9259-4b1e-9bb2-2351ed195edf.png">
*web page served suing Nginx*

<img width="1157" alt="image" src="https://user-images.githubusercontent.com/49791498/221288522-25824cfe-f78c-4910-99a4-b08d2c30cb80.png">
*Cloud Watch*

## Nginx Config file
*/etc/nginx/nginx.conf*
<img width="679" alt="image" src="https://user-images.githubusercontent.com/49791498/221283392-3772a909-df72-4446-82ec-3db5c6746c74.png">

## Repo Secrets
<img width="818" alt="image" src="https://user-images.githubusercontent.com/49791498/221448725-d38edfdf-e7e0-4106-94e0-0efb8178ffe1.png">

## Successsful Pipeline Run
<img width="1068" alt="image" src="https://user-images.githubusercontent.com/49791498/221555093-ba7747e2-38c8-485a-8579-5596dd1b0d61.png">

