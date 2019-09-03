# XR Global jekyll website

## Install
### Install Requirements

- Docker

or

- Ruby 2.6.3
- Gem 3.0.3
- Bundler 2.0.1
- Jekyll 3.8.6
- Imagemagick 6.9.7

### Using Docker

- [Download and install Docker](https://www.docker.com/products/docker-desktop)

- Clone this repo  
  `git clone https://code.organise.earth/xr-global/jekyll.git`

- Then run:
  `xr:path/to/site$ docker-compose build`

this step is only required once, or if the package dependancies have changed since the last build (which would be rare).

- Last step:

  `xr:path/to/site$ docker-compose up`

this step is required each time you'd like to start the server. Once started, the server will hot reload with any saved changes.
Voilà! You can now see the site through Localhost as you would with any Jekyll site.
If required, the compiled files for the site are available in the `_site` folder.
Note: With the Docker method you do not need to manage any of the projects dependancies (Ruby, Jekyll, Bundler, Imagemagick...) yourself, it's all taken care of in the Docker image that you built!

- To stop the Jekyll server, hit `ctrl + c`

### Without Docker

- Install Ruby, Bundler and Jekyll (see https://jekyllrb.com/docs/installation/)
- Install Imagemagick https://imagemagick.org/script/download.php
- Clone this repo  
  `git clone https://code.organise.earth/xr-global/jekyll.git`
- Change directory to the repo root folder:  
  `cd jekyll`
- To install gems run:  
  `bundle install`

### Running development server

- Change directory to the repo root folder:  
  `cd ~/jekyll`
- To start development server run:  
  `bundle exec jekyll serve`

### Install Debian 9 stretch

- Install deps:  
  `apt install git curl libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libssl1.0-dev`
- Install rbenv: https://github.com/rbenv/rbenv-installer
- Install ruby 2.6.3:  
  `rbenv install 2.6.3`
- Use it:  
  `rbenv global 2.6.3`
- Install Bundler and Jekyll:  
  `gem install jekyll bundler`

## Usage

### Posts

Posts are in the `_posts` directory.
To add new posts, simply add a file in the `_posts` directory that follows the convention `YYYY-MM-DD-name-of-post.md` and includes the necessary front matter.

See: https://jekyllrb.com/docs/posts/

#### Multiligual posts

XR Global site use [jekyll-polyglot](https://github.com/untra/polyglot) plugin.
To create a traslatable post you must add a `lang` property to the front matter.
To translate the post if the post name is `2019-07-31-post-title-en.md` the french version should be `2019-07-31-post-title-fr.md` and have `lang` property set to fr.

If you'r creating the post via netlify you must set the `slug` parameter, it must be the same for every translations of the post.

The `slug` parameter is what links posts together.

### Plugins

#### Atom reader

Atom reader plugin provide the `atom_read` tag. It's made to fetch atom feeds and render it with a liquid template.
It's currently tested on others jekyll websites feeds, mastodon feeds and peertube feeds.

It takes `key=value` parameters style. If value is quoted it's considered as a string, if not as a variable.

##### Parameters

| param    | value                                                |
| ------   | ------                                               |
| url      | feed url                                             |
| limit    | maximum number of rendered items                     |
| body     | attribute used as body when rendering                |
| template | template file path, relative to _include             |
| title    | set feed title or "0" (a string) to display no title |

##### Example

```
{% atom_read url='https://social.rebellion.global/users/news_en.atom' limit='30' body='content' title="0" template="atom-reader-mastodon.html" %}
```

## Deployment

The `master` branch is deployed on [Netlify](https://www.netlify.com/) at https://dev.rebellion.global/.
For details, refer to the [wiki](https://code.organise.earth/xr-global/jekyll/wikis/Netlify).
