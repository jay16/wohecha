class SiteConfig < Settingslogic
    source "config/site_config.yaml"
    namespace  ENV["RACK_ENV"] 
end
