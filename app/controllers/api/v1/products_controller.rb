class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 2
    total = Product.count
    products = Product.paginate(page:, per_page:).order(id: :desc)
    render json: {
      message: 'Successfully products are fetched!',
      data: {
        products:,
        total:
      }.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product index API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def list
    page = params[:page] || 1
    per_page = params[:per_page] || 5
    title = params[:title] || ''
    category = params[:category] || ''
    product_option = params[:product_option] || ''
    price_range = params[:price_range] || []
    price_option = params[:price_option] || ''
    # binding.irb
    products = Product.search(title, category, product_option, price_range, price_option)
    total = products.count
    products = products.paginate(page:, per_page:).order(id: :desc)
    render json: {
      message: 'Successfully products are fetched!',
      data: {
        products:,
        total:
      }.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product browse API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def show
    return render json: failed_response('Product not found'), status: :not_found unless @product.present?

    render json: {
      message: 'Successfully product is fetched!',
      data: @product.as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product details API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def create
    Product.create!(product_params)
    render json: {
      message: 'Successfully product created!',
      data: nil
    }, status: :created
  rescue StandardError => e
    Rails.logger.error("Product create API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def update
    return render json: failed_response('Product not found'), status: :not_found unless @product.present?

    @product.update!(product_params)
    render json: {
      message: 'Successfully product updated!',
      data: nil
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product update API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def destroy
    return render json: failed_response('Product not found'), status: :not_found unless @product.present?

    @product.destroy!
    render json: {
      message: 'Successfully product deleted!',
      data: nil
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product destroy API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def category_options
    categories = Setting.product_categories
    render json: {
      message: 'Successfully products are fetched!',
      data: categories
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product category option API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  def price_options
    price_options = Setting.price_options
    render json: {
      message: 'Successfully products are fetched!',
      data: price_options
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product category option API failed: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  private

  def product_params
    params.permit(
    :title,
    :description,
    :price,
    :rental_price,
    :price_option,
    product_categories: [],
    )
  end

  def set_product
    @product = Product.find_by(id: params[:id])
  end
end
