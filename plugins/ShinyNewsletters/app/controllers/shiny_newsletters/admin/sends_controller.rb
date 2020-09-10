# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter sends - part of ShinyNewsletters plugin for ShinyCMS
  class Admin::SendsController < AdminController
    def index
      authorize Send

      @sending = Send.sending
      authorize @sending if @sending.present?

      @scheduled = Send.scheduled if page_number == 1
      authorize @scheduled if @scheduled.present?

      @sends = Send.unscheduled.page( page_number )
      authorize @sends if @sends.present?
    end

    def sent
      authorize Send
      @sent = Send.sent.recent.page( page_number )
      authorize @sent if @sent.present?
    end

    def new
      @send = Send.new
      authorize @send
    end

    def create
      @send = Send.new( send_params )
      authorize @send

      if @send.save
        redirect_to shiny_newsletters.edit_send_path( @send ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @send = Send.find( params[:id] )
      authorize @send
    end

    def update
      @send = Send.find( params[:id] )
      authorize @send

      if @send.update( send_params )
        redirect_to shiny_newsletters.edit_send_path( @send ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def cancel
      send = Send.find( params[:send_id] )
      authorize send

      flash[ :notice ] = t( '.success' ) if send.cancel

      redirect_to shiny_newsletters.sends_path
    end

    def destroy
      send = Send.find( params[:id] )
      authorize send

      flash[ :notice ] = t( '.success' ) if send.destroy

      redirect_to shiny_newsletters.sends_path
    end

    private

    def send_params
      params.require( :send ).permit( :edition_id, :list_id, :send_at )
    end
  end
end
