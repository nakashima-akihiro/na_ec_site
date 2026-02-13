# frozen_string_literal: true

class Admin::HeroImagesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_hero_image, only: %i[edit update destroy]

  def index
    @hero_images = HeroImage.ordered
    @hero_image = HeroImage.new
  end

  def create
    @hero_image = HeroImage.new(hero_image_params)
    if @hero_image.save
      redirect_to admin_hero_images_path, notice: 'トップ画像を追加しました'
    else
      @hero_images = HeroImage.ordered
      render :index
    end
  end

  def edit; end

  def update
    if @hero_image.update(hero_image_params)
      redirect_to admin_hero_images_path, notice: 'トップ画像を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @hero_image.destroy
    redirect_to admin_hero_images_path, notice: 'トップ画像を削除しました'
  end

  private

  def set_hero_image
    @hero_image = HeroImage.find(params[:id])
  end

  def hero_image_params
    params.require(:hero_image).permit(:image, :position)
  end
end
