# ShinyCMS: TODO

## Features the Perl version has, which the Ruby version doesn't. Yet. :)

### Small-ish

* Some sort of file-picker (for image elements, CKEditor, etc)
  * https://ckeditor.com/docs/ckeditor5/latest/features/image-upload/ckfinder.html
* Site map
* Affiliate cookie

### Medium-ish

* Form handlers (contact page, etc)
* 'Likes' on blog posts, shop items, and comments
* User profile pages (with content such as recent comments, recent posts, etc)
* Access control groups
  * Can be used to control access to file downloads and secure whole pages,
    but also to show/hide individual pieces of page content

### Large-ish

* Payment handling plugins
  * Options include recurring subscriptions to access control groups (AKA paid membership)
* Online shop
* Forums
* Autoresponders
	* Check out Heya - may or may not be useful to use / build on top of
	* https://github.com/honeybadger-io/heya
	* Oh, except the licence doesn't look great. Investigate that first.
* Event listings
* Polls


## New features that I'd like to add / features that I'd like to totally rebuild

### Small-ish

* 'Deploy to Heroku' button
  * https://devcenter.heroku.com/articles/heroku-button

* 2FA
  * https://github.com/tinfoil/devise-two-factor

* Configurable (per-site and per-user) menu order in admin area

* Better tooling for loading (and ideally, for creating/updating) the demo data

* In admin area, load the full dataset for user capabilities, feature flags,
  and possibly site settings, and stick them in some hashes, with some helper
  methods to check them. The menu already makes a crazy amount of hits on the
  db and there are still a load of 'feature hidden by flag/capability/etc'
  conditionals to implement.


### Medium-ish

* Tests for rake tasks
  * https://thoughtbot.com/blog/test-rake-tasks-like-a-boss ? (old)

* Improve UX for slug auto-generation
  * Look at Fae CMS slugger: https://www.faecms.com/documentation/features-slugger

* A/B testing
  * Field Test: https://github.com/ankane/field_test

* Cookie consent
  * https://github.com/infinum/cookies_eu ?

* Finish multi-blog code
  * Refactor news section to be a blog instance ?

* ¡español! :D

* Replace hand-rolled slug generation with FriendlyId ?
  * https://norman.github.io/friendly_id


### Large-ish

* GDPR compliance
  * https://github.com/prey/gdpr_rails

* Switch from ERB to handlebars or similar for main site templates

* Allow Page templates to be stored in database and edited in admin UI

* Allow in-situ editing of Page (and other?) content
  * Mercury: https://jejacks0n.github.io/mercury

* Replace hand-rolled trees and recursion (page sections, etc) with ClosureTree ?
  * https://github.com/ClosureTree/closure_tree
