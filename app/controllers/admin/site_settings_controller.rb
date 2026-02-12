# frozen_string_literal: true

class Admin::SiteSettingsController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @site_setting = SiteSetting.instance
  end

  def update
    @site_setting = SiteSetting.instance
    if @site_setting.update(site_setting_params)
      redirect_to edit_admin_site_settings_path, notice: t('admin.site_settings.update_success')
    else
      render :edit
    end
  end

  private

  def site_setting_params
    params.require(:site_setting).permit(:postage, :free_shipping_threshold)
  end
end
