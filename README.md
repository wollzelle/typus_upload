# Typus Upload

Upload module for [Typus](https://github.com/typus/typus), adds support for uploading files to Amazon S3.

## Installation

In your `Gemfile`:

    gem 'typus_upload'
    gem 'react-rails', '~> 1.0.0.pre', github: 'reactjs/react-rails'

Note: until `react-rails` 1.0 is released you need to manually include this gem as a dependency. This will be fixed in the future.

## Configuration

Add your S3 config to your environment variables:

    AWS_BUCKET=<bucket>
    AWS_ACCESS_KEY_ID=<id>
    AWS_SECRET_ACCESS_KEY=<key>
    AWS_PROXY=<proxy>

In your model:

    class Post < ActiveRecord::Base
      typus_upload :attachment_url
    end

In your Admin controller:

    class Admin::PostsController < Admin::ResourcesController
      include Admin::Uploads
    end

    # Files will be uploaded to /posts by default, override this with:
    def upload_prefix
      'downloads/'
    end
