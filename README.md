# README

## Usage

`web-tv-show-downloader.rb <tv show episodes list URL>`

## Supported Websites

- America's Test Kitchen (https://www.americastestkitchen.com/episodes/browse)
- 177 Milk Street (https://www.177milkstreet.com/tv)

## Requirements

### youtube-dl

#### macOS

Use homebrew: `brew install youtube-dl`

## Configuration

Set in `config.yml`

### TV Show Directory

Key: `base_tv_show_directory`

Absolute directory path that will be prepended to `<Show Name>/<Season Number>/<Episode File>`

### Cookies

Key: `cookies`

Relative path to cookie file for source web site. These must be in the Netscape cookie file format. The [cookie.txt browser extension](https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg/related) is useful to create the cookie files.

#### Keys:

- America's Test Kitchen: `americas_test_kitchen`
- 177 Milk Street: `177_milk_street`
