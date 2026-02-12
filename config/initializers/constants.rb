# 送料設定: SiteSettingモデルから取得（後方互換のため定数も定義）
# 使用箇所では SiteSetting.postage / SiteSetting.free_shipping_threshold を推奨
POSTAGE = 500 # フォールバック用（SiteSetting.postage を使用すること）
FREE_SHIPPING_THRESHOLD = 5000 # フォールバック用（SiteSetting.free_shipping_threshold を使用すること）
