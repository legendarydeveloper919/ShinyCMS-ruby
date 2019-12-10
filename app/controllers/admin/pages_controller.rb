# Admin controller for CMS-controlled 'brochure' pages
class Admin::PagesController < AdminController
  after_action :verify_authorized

  def index
    authorise Page
    authorise PageSection

    @tl_pages = Page.top_level_pages + Page.top_level_hidden_pages
    authorise @tl_pages if @tl_pages.present?

    @tl_sections =
      PageSection.top_level_sections + PageSection.top_level_hidden_sections
    authorise @tl_sections if @tl_sections.present?
  end

  def new
    authorise Page
  end

  def create
    @page = Page.new( page_params )
    authorise @page

    if @page.save
      flash[ :notice ] = t( 'page_created' )
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = t( 'page_create_failed' )
      render action: :new
    end
  end

  def edit
    @page = Page.find( params[:id] )
    authorise @page
  end

  def update
    @page = Page.find( params[:id] )
    authorise @page

    if @page.update( page_params )
      flash[ :notice ] = t( 'page_updated' )
      redirect_to action: :edit, id: @page.id
    else
      flash.now[ :alert ] = t( 'page_update_failed' )
      render action: :edit
    end
  end

  def delete
    page = Page.find( params[:id] )
    authorise page

    flash[ :notice ] = t( 'page_deleted' ) if page.destroy
    redirect_to admin_pages_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    handle_delete_exceptions
  end

  private

  def page_params
    params.require( :page ).permit(
      :name, :description, :title, :slug, :template_id, :section_id,
      :sort_order, :hidden, :hidden_from_menu,
      elements_attributes: {}
    )
  end

  def handle_delete_exceptions
    flash[ :alert ] = t( 'page_delete_failed' )
    redirect_to admin_pages_path
  end

  def t( key )
    I18n.t( "admin.pages.#{key}" )
  end
end
