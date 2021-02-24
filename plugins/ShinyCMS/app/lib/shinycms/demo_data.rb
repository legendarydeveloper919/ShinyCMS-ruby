# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Supporting methods for handling demo site data
  module DemoData
    # Used when loading demo data from file into database

    def skip_callbacks_on_templated_models
      ShinyPages::Page.skip_callback( :create, :after, :add_elements )
      ShinyPages::Template.skip_callback( :create, :after, :add_elements )
      ShinyNewsletters::Edition.skip_callback( :create, :after, :add_elements )
      ShinyNewsletters::Template.skip_callback( :create, :after, :add_elements )
    end

    def set_callbacks_on_templated_models
      ShinyPages::Template.set_callback( :create, :after, :add_elements )
      ShinyPages::Page.set_callback( :create, :after, :add_elements )
      ShinyNewsletters::Template.set_callback( :create, :after, :add_elements )
      ShinyNewsletters::Edition.set_callback( :create, :after, :add_elements )
    end

    def fix_primary_key_sequences
      models_with_demo_data.each do |model|
        fix_primary_key_sequence( model.table_name )
      end
    end

    def fix_primary_key_sequence( table_name )
      ActiveRecord::Base.connection.execute( <<~SQL.squish )
        BEGIN;
        LOCK TABLE #{table_name} IN EXCLUSIVE MODE;
        SELECT setval( '#{table_name}_id_seq', COALESCE( ( SELECT MAX(id)+1 FROM #{table_name} ), 1 ), false );
        COMMIT;
      SQL
    end

    # Used when exporting demo data from database to file

    def export_demo_data
      prepare_for_export

      sql = all_to_sql( models_with_demo_data )

      munged_sql = munge_user_id( sql )

      write_demo_data_to_file( munged_sql )
    end

    def prepare_for_export
      # We need all the models pre-loaded so we can find those offering demo data
      Rails.application.eager_load!

      # Avoid collision between seed data and demo data
      ShinyCMS::ConsentVersion.find_by( slug: 'shiny-lists-admin-subscribe' )&.delete
    end

    def all_to_sql( models )
      sql = ''
      models.each do |model|
        sql += to_sql( model )
      end
      sql
    end

    def to_sql( model )
      return '' if model.all.size.zero?

      Rails.logger.info "Dumping: #{model}"

      SeedDump.dump( model, exclude: %i[created_at updated_at tag_list hidden_tag_list] )
    end

    def write_demo_data_to_file( demo_data_sql )
      File.open( Rails.root.join( 'db/demo_data.rb' ), 'w' ) do |demo_data_file|
        demo_data_file.write demo_data_sql
      end
    end

    # This change means that `load_demo_data` can just require the dump file after
    # creating @shiny_admin, and all the imported content will belong to that user
    def munge_user_id( sql )
      sql.gsub 'user_id: 1', 'user_id: @shiny_admin.id'
    end

    def models_with_demo_data
      core_models = ShinyCMS::Plugin.get( 'ShinyCMS' ).models_that_respond_to( :demo_data? )
      plugin_models = ShinyCMS.plugins.models_with_demo_data

      shinycms_models = [ core_models + plugin_models ].flatten.sort_by( &:name ).sort_by( &:demo_data_position )

      shinycms_models + other_models
    end

    def other_models
      [
        ActsAsTaggableOn::Tag,
        ActsAsTaggableOn::Tagging,

        ActiveStorage::Blob,
        ActiveStorage::Attachment
      ]
    end
  end
end
