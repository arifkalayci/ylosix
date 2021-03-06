class AddressesController < Frontend::CommonController
  before_action :authenticate_customer!
  before_action :set_customer_address, except: [:index, :new, :create]

  def append_variables
    super

    helper = Rails.application.routes.url_helpers
    @variables['new_customers_address_path'] = helper.new_customers_address_path
    if customer_signed_in?
      @variables['customer_addresses'] = array_to_liquid(current_customer.customer_addresses)

      @variables['address'] = @address.to_liquid unless @address.nil?
    end

    @variables['countries'] = Country.where(enabled: true)
  end

  def index
  end

  def edit
    add_breadcrumb(Breadcrumb.new(url: edit_customers_address_path, name: 'Edit'))
  end

  def create
    @address = CustomerAddress.new(address_params)
    @address.customer = current_customer
    @address.save

    if @address.errors.any?
      render 'addresses/new'
    else
      redirect_to :customers_addresses, notice: 'Address saved successfully!'
    end
  end

  def update
    @address.attributes = address_params
    @address.save

    if @address.errors.any?
      render 'addresses/edit'
    else
      redirect_to :customers_addresses, notice: 'Address saved successfully!'
    end
  end

  def destroy
    @address.destroy
    redirect_to :customers_addresses, notice: 'Address destroyed successfully!'
  end

  def new
    @address = CustomerAddress.new

    @address.customer = current_customer
    @address.name = 'My address'
    @address.customer_name = current_customer.name
    @address.customer_last_name = current_customer.last_name
  end

  protected

  def set_breadcrumbs
    add_breadcrumb(Breadcrumb.new(url: show_customers_path, name: 'Customers'))
    add_breadcrumb(Breadcrumb.new(url: customers_addresses_path, name: 'Addresses'))
  end

  def set_customer_address
    # TODO, security check if current_user has this address
    @address = CustomerAddress.find(params[:id])
  end

  def address_params
    params.require(:customer_address).permit(:name, :default_billing, :default_shipping,
                                             :customer_name, :customer_last_name,
                                             :business, :address_1, :address_2,
                                             :postal_code, :city, :country,
                                             :phone, :mobile_phone, :state,
                                             :dni, :other)
  end
end
