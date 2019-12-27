# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rails db:setup`
# You can also load it (and reload it) at any time using `rails db:seed`

# Settings (unset; just here to let people know that they're available)
# TODO: replace this with the half-planned site/admin/user overrideable thing
seed Setting, { name: I18n.t( 'admin.settings.admin_ip_list' ) }, {
  value: '',
  description: 'Comma/space-separated list of IP addresses allowed to access admin area'
}
seed Setting, { name: I18n.t( 'admin.settings.default_page' ) }, {
  value: '',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'admin.settings.default_section' ) }, {
  value: '',
  description: 'Default top-level section (either its name or its slug)'
}

# Feature Flags (to turn on/off areas of site functionality)
seed FeatureFlag, { name: 'blogs' }, {
  description: '',
  enabled: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'user_login' }, {
  description: 'Allow users to log in',
  enabled: false,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'user_profiles' }, {
  description: 'Allow viewing of user profiles',
  enabled: true,
  enabled_for_admins: true
}
seed FeatureFlag, { name: 'user_registration' }, {
  description: 'Allow users to create accounts',
  enabled: true,
  enabled_for_admins: true
}

# Capabilities (for user authorisation via Pundit)
general_cc    = seed CapabilityCategory, { name: 'general'        }
blogs_cc      = seed CapabilityCategory, { name: 'blogs'          }
blog_posts_cc = seed CapabilityCategory, { name: 'blog_posts'     }
pages_cc      = seed CapabilityCategory, { name: 'pages'          }
sections_cc   = seed CapabilityCategory, { name: 'page_sections'  }
templates_cc  = seed CapabilityCategory, { name: 'page_templates' }
shared_cc     = seed CapabilityCategory, { name: 'shared_content' }
users_cc      = seed CapabilityCategory, { name: 'users'          }
admins_cc     = seed CapabilityCategory, { name: 'admin_users'    }
# General
seed Capability, { name: 'view_admin_area'    }, { category: general_cc }
seed Capability, { name: 'view_admin_toolbar' }, { category: general_cc }
# Blogs
seed Capability, { name: 'list',    category: blogs_cc }
seed Capability, { name: 'add',     category: blogs_cc }
seed Capability, { name: 'edit',    category: blogs_cc }
seed Capability, { name: 'destroy', category: blogs_cc }
# Blog Posts
seed Capability, { name: 'list',          category: blog_posts_cc }
seed Capability, { name: 'add',           category: blog_posts_cc }
seed Capability, { name: 'edit',          category: blog_posts_cc }
seed Capability, { name: 'destroy',       category: blog_posts_cc }
seed Capability, { name: 'change_author', category: blog_posts_cc }
# Pages
seed Capability, { name: 'list',    category: pages_cc }
seed Capability, { name: 'add',     category: pages_cc }
seed Capability, { name: 'edit',    category: pages_cc }
seed Capability, { name: 'destroy', category: pages_cc }
# Page Sections
seed Capability, { name: 'list',    category: sections_cc }
seed Capability, { name: 'add',     category: sections_cc }
seed Capability, { name: 'edit',    category: sections_cc }
seed Capability, { name: 'destroy', category: sections_cc }
# Page Templates
seed Capability, { name: 'list',    category: templates_cc }
seed Capability, { name: 'add',     category: templates_cc }
seed Capability, { name: 'edit',    category: templates_cc }
seed Capability, { name: 'destroy', category: templates_cc }
# Shared Content
seed Capability, { name: 'list',    category: shared_cc }
seed Capability, { name: 'add',     category: shared_cc }
seed Capability, { name: 'edit',    category: shared_cc }
seed Capability, { name: 'destroy', category: shared_cc }
# Users
seed Capability, { name: 'list',    category: users_cc }
seed Capability, { name: 'add',     category: users_cc }
seed Capability, { name: 'edit',    category: users_cc }
seed Capability, { name: 'destroy', category: users_cc }
seed Capability, { name: 'view_admin_notes', category: users_cc }
# Admin Users
seed Capability, { name: 'list',    category: admins_cc }
seed Capability, { name: 'add',     category: admins_cc }
seed Capability, { name: 'edit',    category: admins_cc }
seed Capability, { name: 'destroy', category: admins_cc }

# One Admin To Rule Them All
admin = seed User, { username: 'admin' }, {
  email: 'admin@example.com',
  password: 'I should change this password before I do anything else!'
}
admin.confirm
Capability.all.each do |c|
  admin.user_capabilities.find_or_create_by( capability_id: c.id )
end
