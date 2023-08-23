module AhoyCaptain
  class I18nConfig < ::I18n::Config
    BACKEND = I18n::Backend::Simple.new
    AVAILABLE_LOCALES = AhoyCaptain::Engine.root.join("config/locales/ahoy_captain").glob("*.yml").map { |path| File.basename(path, ".yml").to_sym }.uniq
    AVAILABLE_LOCALES_SET = AVAILABLE_LOCALES.inject(Set.new) { |set, locale| set << locale.to_s << locale.to_sym }

    def backend
      BACKEND
    end

    def available_locales
      AVAILABLE_LOCALES
    end

    def available_locales_set
      AVAILABLE_LOCALES_SET
    end

    def default_locale
      AhoyCaptain.config.locale
    end
  end
end
