# Local SSL

Local SSL enables you to redirect an no-secure - even local (localhost) - domain to an secure **HTTPS** and **HTTP/2** virtual domain.

# Version

See the *version* file on the project's root folder.

# License

See the *LICENSE* file on the project's root folder.

# Collaborators

- Fabio Marciano <fabioamarciano@gmail.com>

# Prerequisites

- OpenSSL
- Docker

# Setup

In order to use the local SSL, you will need to:

1. generate a local, but valid, certificate;
2. build a docker image with some parameters;
3. edit your `hosts` file to add the local domain entry;
4. Add the certificate file on your web browser

## 1. Generating the local certificate:

The first step is to generate a local certificate for the domain you wish.

This step should be executed one time per domain but must be **before** to run the docker container.

The `setup` script utility are able to generate the certificate set you will need.

Use the following command replacing the `my-local-domain` with your desired domain name.

Let's consider you choose the `secure.local` domain name. So you will run the following command on terminal:

``` shell
$ ./setup secure.local
```

The command above creates the *secure.local* folder inside the *ssl* folder.

Note there are 3 files inside it: **ca.pem**, **server.crt** and **server.key**.

These files will be used in the future, so **don't move or remove** then.
___
## 2. Building the docker image:

In order to build the Docker's image is necessary to provide some required arguments on the command line:

### Arguments:

- **domain**: the https/secure domain **without** the protocol. Eg.: `secure.local`.
- **port**: port used by Nginx's server (this is for the secure domain). Eg.: `80`.
- **target**: the fully target address **with** the protocol, domain and port - if applicable - Eg.: `http://localhost:3000`.
- **imageName**: the docker's image name. Eg.: `local-ssl`.

**Considering:**

- `domain`: secure.local
- `port`: 80
- `target`: http://localhost:3000
- `imageName`: local-ssl

**Execute:**

``` shell
$ sudo docker build --build-arg DOMAIN=secure.local --build-arg PORT=80 --build-arg TARGET=http://localhost:3000 -t local-ssl .
```
___

## 3. Editing the hosts file:

You should to update your **hosts** file using your favourite text application to add the following entry:

``` http
127.0.0.1 secure.local
```

Or, you may to run the following command to the same effect:

``` shell
$ echo "127.0.0.1 secure.local" | sudo tee -a /etc/hosts > /dev/null
```

> Considering you are using `secure.local` as your local domain name.
___

## 4. Add Certification Authority on your web browser:

The next step is to add your previous generated
certificate file on your web browser.

Let's use the *google chrome* as example:

- open **google chrome**
- type on address bar: *chrome://settings/certificates*
- Click on *Authorities* and *Import*
- Go to the your certificate folder  at `ssl/secure.local` and choose the *ca.pem* file, then *Open*
- On *Certification Authority* tab, select/check all options and then *Ok*

>**About the local certificates**
>
> Each virtual local domain has your own certificate (step #1).
>
> So, if you want to create another certificate, to another virtual domain or from another unsecure domain, it's necessary to repeat all previous described steps using new parameters.
___
# Usage

After sucessfully setting up your local domain, it's time to use it.

You don't need to repeat the previous steps each time you use the container unless you need a new local domain name.

Now you are able to run the docker container using the following command:

``` shell
$ sudo docker run --rm --network=host -it local-ssl
```

> Considering you used `local-ssl` for the `imageName` argument.

Access using the following address on your web browser:

``` http
https://secure.local/
```
___
## Health Check

Use the `/health` path to check if the service is enabled.

**Example:**

``` http
https://secure.local/health
```
