# frozen_string_literal: true

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # ShinyForms plugin admin controller - add/edit/delete form handlers
  class Admin::FormsController < AdminController
    before_action :set_form_for_create, only: %i[ create ]
    before_action :set_form, only: %i[ edit update destroy ]
    before_action :set_form_handlers, only: %i[ new create edit update ]

    # GET /admin/forms
    def index
      authorise Form
      page_num = params[ :page ] || 1
      @forms = Form.page( page_num )
      authorise @forms if @forms.present?
    end

    # GET /admin/forms/new
    def new
      @form = Form.new
      authorise @form
    end

    # POST /admin/forms
    def create
      authorise @form

      if @form.save
        redirect_to edit_form_path( @form ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :new
      end
    end

    # GET /admin/forms/1
    def edit
      authorise @form
    end

    # PATCH/PUT /admin/forms/1
    def update
      authorise @form

      if @form.update(form_params)
        redirect_to edit_form_path( @form ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    # DELETE /admin/forms/1
    def destroy
      authorise @form

      @form.destroy!
      redirect_to forms_path, notice: t( '.success' )
    end

    private

    def set_form
      @form = ShinyForms::Form.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to forms_path, alert: t( 'shiny_forms.admin.forms.set_form.not_found' )
    end

    def set_form_for_create
      @form = Form.new( form_params )
    end

    def set_form_handlers
      handlers = ShinyForms::FormHandler::FORM_HANDLERS
      @form_handlers = []
      handlers.each do |handler|
        @form_handlers << [ I18n.t( "shiny_forms.admin.forms.handlers.#{handler}" ), handler ]
      end
    end

    def form_params
      params.require( :form ).permit(
        :internal_name, :public_name, :slug, :description, :handler,
        :email_to, :filename, :redirect_to, :success_message
      )
    end
  end
end
