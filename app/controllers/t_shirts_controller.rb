# frozen_string_literal: true

class TShirtsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_t_shirt, only: %i[show edit update destroy]
  after_action :verify_authorized

  # GET /t_shirts or /t_shirts.json
  def index
    authorize TShirt, :index?
    # TODO: se non sei un seller, filtra via quelle con quantità zero????

    @q = TShirt.ransack(params[:q])
    t_shirts = @q.result(distinct: true)
                 .catalog_sort

    @pagy, @t_shirts = pagy(t_shirts)
  end

  # GET /t_shirts/1 or /t_shirts/1.json
  def show
    authorize @t_shirt, :show?
  end

  # GET /t_shirts/new
  def new
    authorize TShirt, :new?

    @t_shirt = TShirt.new
  end

  # GET /t_shirts/1/edit
  def edit
    authorize @t_shirt, :edit?
  end

  # POST /t_shirts or /t_shirts.json
  def create
    authorize TShirt, :create?

    @t_shirt = TShirt.new(t_shirt_params)

    respond_to do |format|
      if @t_shirt.save
        format.html { redirect_to t_shirt_url(@t_shirt), notice: 'T shirt was successfully created.' }
        format.json { render :show, status: :created, location: @t_shirt }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @t_shirt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /t_shirts/1 or /t_shirts/1.json
  def update
    authorize @t_shirt, :update?

    respond_to do |format|
      if @t_shirt.update(t_shirt_params)
        format.html { redirect_to t_shirt_url(@t_shirt), notice: 'T shirt was successfully updated.' }
        format.json { render :show, status: :ok, location: @t_shirt }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @t_shirt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /t_shirts/1 or /t_shirts/1.json
  def destroy
    authorize @t_shirt, :destroy?

    @t_shirt.destroy

    respond_to do |format|
      format.html { redirect_to t_shirts_url, notice: 'T shirt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_t_shirt
    @t_shirt = TShirt.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def t_shirt_params
    permitted = params.fetch(:t_shirt, {}).permit(
      :brand,
      :color,
      :name,
      :price,
      :quantity
    )

    # convert price to cents
    permitted[:price] = (permitted[:price].to_f * 100).to_i if permitted[:price]

    permitted
  end
end
