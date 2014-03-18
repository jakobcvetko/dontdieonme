### dontdieonme

"Don't die on me is" simple Ruby app that makes request to website every X seconds (default is 100 seconds).

### Setup
Make sure you add following to __environment variables__:

 - DELAY (number of seconds between requests, default is 100)
 - URL_0
 - URL_1
 - URL_2
 - URL_3
 - ... as many as you like, but they have to be continuous, starting with 0

### Using Heroku
#### Setting up URLs:
This is how you add your URLs to watch

    => heroku config:set URL_0=http://www.example.com URL_1=http://www.example2.com --app heroku_app_name

#### Setting up custom delay:
If you want to set the DELAY to 20 seconds

    => heroku config:set DELAY=20 --app heroku_app_name

### Rollbar
If you want to use Rollbar for error reporting:

 - ROLLBAR\_ACCESS_TOKEN
 - ROLLBAR_ENDPOINT

### People responsible

- [Oto Brglez](https://github.com/otobrglez)
- [Jakob Cvetko](https://github.com/jakobboss)
