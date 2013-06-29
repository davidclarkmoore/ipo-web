# Ipo Web Tests

There are a couple of steps required to run the different specs for Ipo WEbas described below:


## Acceptance Tests

In order to run acceptance tests (those that test the web perspective) also known as feature tests, you should install **PhantomJS**. On the poltergeist gem README there are some basic instructions on how to do so ( https://github.com/jonleighton/poltergeist ). If you have HomeBrew installed on your mac then it is as easy as running `brew install phantomjs`

## Running Tests

You can run the tests by executing either `rake spec` or `guard start`. Rake spec is the traditional way of executing the test suite, and guard start is a autotest runner that runs tests as you modify your code (useful for active development). Either way works.

Before running `guard start` you must run `zeus start`.