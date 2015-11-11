# Container for content that was created using Tilda.CC

Many of you must know [Tilda](http://tilda.cc/?lang=en). This is an on demand content management system that helps to create awesome mobile ready pages in one moment. Tilda has many preinstalled design patterns and a very handy editor. Sure, it has been created for publishers first. But we (developers) also fell in love with **Tilda** at first touch. Yeah.

After some experience with **Tilda**, we found that it's impossible to create our site with SSL. So we decided to create a container. It can collect content from Tilda's API, store it locally in Redis, and deliver to our visitors from our servers. We had two aims: to support SSL and to make delivery extremely fast.

## How it works

We use [Tilda](http://tilda.cc/?lang=en) API to get page content and compile it into pages. Precompiled pages are stored in the [Redis](http://redis.io/) container. Some JS, CSS, and image files are copied to [Amazon S3](https://aws.amazon.com/s3/) that distributes them into [Cloud Front](https://aws.amazon.com/cloudfront/) to make files' delivery fast and reliable. That's all.

### Install and Start

If you want to use the container, please make sure you've got a machine with docker to deploy **tilda-site** there. You also need the following data:

- *Project ID* on Tilda you want to deliver
- *Public Key* and *Secret Key* of Tilda API
- You've created 404 error page on Tilda. You need to know its slug
- *Facebook App ID* is also useful
- *Favicon URL* is required. Good news: you may also place it in the Amazon Cloud
- *Google Analytics ID* is optional but we recommend to use it
- *Amazon API Key*  and *Amazon API Secret* to deal with Amazon through its API
- *Amazon S3 Bucket* and *Amazon Region* for this Bucket
- *Amazon CDN Domain* it's a Cloud Front domain that caches content from your Bucket

That's not all. You also need SSL certificates for your domain. Please place them somewhere on your server. Just create a folder that contains ``server.crt`` and ``server.key`` files for SSL. Unfortunately, this version won't work without SSL certificates.  

Once all is done, you're ready for the magic. Please login to your server via **SSH** as **root** and start the *Redis* container via the following command:

```bash
docker run \
        -d \
        --restart=always \
        --name redis \
        redis
```

After it's done, you may start the *tilda-site* container.

```bash
docker run \
        -d \
        --restart=always \
        -p 80:8080 \
        -p 443:8443 \
        -e HOSTNAME=<your host name> \
        -e TILDA_PROJECT_ID=<project id on Tilda> \
        -e TILDA_PUBLIC_KEY=<publickey on Tilda> \
        -e TILDA_SECRET_KEY=<secretkey on Tilda> \
        -e TILDA_404=<slug of 404 page on Tilda> \
        -e FACEBOOK_APP_ID=<Facebook AppID> \
        -e FAVICON_URL=<URL to Favicon> \
        -e GOOGLE_ANALYTICS_ID=<Google Analytics ID> \
        -e AMAZON_API_KEY=<API Key on Amazon> \
        -e AMAZON_API_SECRET=<API Secret on Amazon> \
        -e AMAZON_BUCKET=<Amazon S3 Bucket> \
        -e AMAZON_REGION=<Bucket region> \
        -e AMAZON_CDN_DOMAIN=<CloudFront domain> \
        --link redis:redis \
        -v <folder with certificates on your server>:/data/certs \
        --name tilda \
        ecomgems/tilda-site
```

That's all. *tilda-site* will connect to your project on **Tilda** and pull content from there. Something will be uploaded onto Amazon Cloud and something will be stored in Redis. In about a minute you will have your site on the cloud.

### Hooks from Tilda

After you start your copy of *tilda-site*, please setup the *hook* from tilda to ``https://<your site>/api/hook``. **Tilda** makes hook after each page publish. So you will always have fresh content.

### Uninstall

If you doesn't want to use it anymore, just run the following command to remove *tilda-site*.

```bash
docker stop tilda && docker rm tilda
```

Don't forget to clean up your server from the *Redis* container.

```bash
docker stop redis && docker rm redis
```

## Credits

Created by [EcomGems](http://www.ecomgems.com) using [NodeJS](https://nodejs.org/en/) and [CoffeeScript](http://coffeescript.org/).
Works smoothly with [Docker](https://www.docker.com/), [Redis](http://redis.io/), and [AWS](https://aws.amazon.com/).
We wouldn't be able to deal without all these technologies.
Thanks to all creators.

## Contribution

Feel free to fork the repo and contribute through pull requests. It's appreciated.

## License

The MIT License (MIT)

Copyright (c) 2015 EcomGems Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.