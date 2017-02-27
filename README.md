# StatusPage::API

[![NYU](https://github.com/NYULibraries/nyulibraries-assets/blob/master/lib/assets/images/nyu.png)](https://dev.library.nyu.edu)
[![Build Status](https://travis-ci.org/NYULibraries/status_page-api.svg)](https://travis-ci.org/NYULibraries/status_page-api)
[![Code Climate](https://codeclimate.com/github/NYULibraries/status_page-api/badges/gpa.svg)](https://codeclimate.com/github/NYULibraries/status_page-api)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/status_page-api/badge.svg?branch=development)](https://coveralls.io/github/NYULibraries/status_page-api?branch=development)

Ruby client for [StatusPage](https://www.statuspage.io/) [REST API](https://doers.statuspage.io/api/v1/).

## Installation

```
gem 'status_page-api', github: "NYULibraries/status_page-api"
require 'status_page/api'
```

You must set `STATUS_PAGE_API_KEY` environment variable to your API key.

## Usage

### Get component list

To fetch a list of components for a particular page:

```
component_list = StatusPage::API::ComponentList.new('page_id')
component_list.get
```

You can then interact with the instance as if it were an array:

```
component_list[0]
component_list.map(&:id)
component_list.each do |component|
  # do something with component
end
```

### Get component data

To fetch a particular component:

```
component = StatusPage::API::Component.new('component_id', 'page_id')
component.get
```

All data returned by the API exists in instance methods, e.g.:

```
component.id
component.name
component.description
component.status
component.page_id
component.group_id
component.created_at
component.updated_at
```

### Modifying a component

The API only allows the following fields to be modified: `status`, `name`, and `description`.

To modify a field:

```
component.status = 'major_outage'
component.description = 'Hello world'
component.save
```

The `save` method does not catch any errors raised by `RestClient`.
