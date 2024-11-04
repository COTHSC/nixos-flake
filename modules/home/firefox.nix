{ pkgs, firefox-addons, ...}: let
addons = firefox-addons.packages.${pkgs.system};
in {
    programs.firefox = {
        enable = true;

        profiles.default = {
            id = 0;
            name = "Default";
            isDefault = true;
            extensions = [
                addons.ublock-origin
                    addons.bitwarden
            ];


            settings = {
# Disable password autofill
                "signon.rememberSignons" = false;
                "signon.autofillForms" = false;

# DNS over HTTPS configuration
                "network.trr.mode" = 2;  # Enable DoH with fallback
                "network.trr.uri" = "https://dns.quad9.net/dns-query";
                "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";


# Set DuckDuckGo as default search engine
                "browser.search.isUS" = true;
                "browser.search.hiddenOneOffs" = "Google,Bing,Amazon.com,eBay,Twitter";
                "browser.urlbar.placeholderName" = "DuckDuckGo";
                "browser.urlbar.placeholderName.private" = "DuckDuckGo";
                "browser.search.defaultenginename" = "DuckDuckGo";
                "browser.search.defaultenginename.US" = "DuckDuckGo";

# Disable sponsored content and recommendations
                "browser.newtabpage.activity-stream.showSponsored" = false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                "browser.newtabpage.activity-stream.feeds.topsites" = false;
                "browser.newtabpage.activity-stream.feeds.snippets" = false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
                "browser.newtabpage.activity-stream.showSearch" = false;
            };

            search = {
                force = true;
                default = "DuckDuckGo";
            };
        };
    };
}
