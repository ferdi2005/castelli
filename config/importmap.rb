# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "leaflet", to: "./node_modules/leaflet/dist/leaflet.js", preload: true
pin "leaflet.markercluster", to: "./node_modules/leaflet.markercluster/dist/leaflet.markercluster.js", preload: true
