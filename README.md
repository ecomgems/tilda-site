# Container for content that was created using Tilda.CC

Suppose you know the [Tilda](http://tilda.cc/?lang=en). There is on demand content management system that helps to create awesome mobile ready pages in one moment. It has many preinstalled design patterns and very handy editor. Sure, It's created for publishers first. But we (developers) was also fell in love with the **Tilda** after very first touch. Yeah.

After some experience with **Tilda** we found that it's impossible to create our site with SSL. So we decided to create this tool. It can collect content from Tilda's API and store it locally in Redis and deliver to our visitors from our servers. We have had two aims: to support SSL and to make delivery extremely fast.  

## How it works

We use [Tilda](http://tilda.cc/?lang=en) API to get page content, compile it into pages. Precompiled pages are stored in the [Redis](http://redis.io/) container. Some JS, CSS and image files are copied to [Amazon S3](https://aws.amazon.com/s3/) that distributed into [Cloud Front](https://aws.amazon.com/cloudfront/) to make it's delivery fast and reliable. That's all.  

### Install and Start

If you want to use it, please make sure you've machine with docker to deploy **tilda-site** there. You also need following things:

- *Project ID* on Tilda you want to deliver
- *Public Key* and *Secret Key* of Tilda API
- You've created 404 error page on Tilda. You need to know it's slug
- *Facebook App ID* is also useful
- *Favicon URL* is required. Good news you may also place it in the Amazon Cloud
- *Google Analytics ID* is optional but we recommend to use it
- *Amazon API Key*  and *Amazon API Secret* to deal with Amazon through it's API
- *Amazon S3 Bucket* and *Amazon Region* for this Bucket
- *Amazon CDN Domain* it's a Cloud Front domain that caches content from your Bucket

That's not all. You also need SSL certificates for your domain. Please place it somewhere on your server. Please just create folder that contains ``server.crt`` and ``server.key`` files for SSL. Unfortunately this version won't work without SSL certificates.  

After all this mess you've prepared to the magic. Please login to your server via **SSH** as **root** and start *Redis* container via following command:

```bash
docker run \
        -d \
        --restart=always \
        --name redis \
        redis
```

After it done. You may start *tilda-site* container.

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

That's all. *tilda-site* will connect to your project on **Tilda** and pull content from there. Something will be uploaded onto Amazon Cloud and something will be stored in Redis. After about a minute you will have your site on the cloud.

### Hooks from Tilda

After you start your copy of *tilda-site*, please setup the *hook* from tilda to ``https://<your site>/api/hook``. **Tilda** makes hook after each page publish. So you will always have a fresh content.

### Uninstall

If you doesn't want to use it anymore. Please just run following command to remove *tilda-site*.

```bash
docker stop tilda && docker rm tilda
```

Don't forget to clean up your server from *Redis* container.

```bash
docker stop redis && docker rm redis
```

## Credits

Created by [EcomGems](http://www.ecomgems.com) using [NodeJS](https://nodejs.org/en/) and [CoffeeScript](http://coffeescript.org/).
Works smoothly with [Docker](https://www.docker.com/), [Redis](http://redis.io/) and [AWS](https://aws.amazon.com/).
We wouldn't be able to deal without all these technologies.
Thanks to all creators.

## Contribution

Feel free to fork the repo and contribute through pull requests. It's appreciated.

## Changes

**1.0.1**
- Use 1.5 multiplier to calculate thread count
- Refresh all pages HTML each 12 hours to prevent links to outdated JS and CSS files (looks like temporary solution)

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
