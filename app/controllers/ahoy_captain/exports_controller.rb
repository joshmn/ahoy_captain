module AhoyCaptain
  class ExportsController < ApplicationController
    skip_before_action :act_like_an_spa

    def show
      export = Export.new(params, self).build
      file = export.to_zip
      send_data file.read,
                type: 'application/zip',
                disposition: 'attachment',
                filename: "AhoyCaptain export #{request.host} #{range[0].to_date} to #{(range[1] || Time.current).to_date}.zip"
    end
  end
end
