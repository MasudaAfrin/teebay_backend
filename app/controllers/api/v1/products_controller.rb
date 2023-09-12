class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    render json: {
      message: 'Successfully products are fetched!',
      data: Product.all.order(id: :desc).as_json
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Product index API failed: #{e.message}")
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

  private

  def product_params
    params.permit(
    :title,
    :description,
    :product_categories,
    :price,
    :product_type,
    :price_option
    )
  end

  def set_product
    @product = Product.find_by(id: params[:id])
  end
end
