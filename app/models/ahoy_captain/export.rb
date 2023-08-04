module AhoyCaptain
  class Export
    def initialize(params, context)
      @params = params
      @context = context
      @files = {}
    end

    def build
      @files["browsers.csv"] = to_csv(DeviceQuery.call(merged_params(devices_type: "browser")), DeviceDecorator)
      @files["cities.csv"] = to_csv(CityQuery.call(merged_params), CityDecorator)
      @files["countries.csv"] = to_csv(CountryQuery.call(merged_params), CountryDecorator)
      @files["devices.csv"] = to_csv(DeviceQuery.call(merged_params(devices_type: :device_type)), DeviceDecorator)
      @files["entry_pages.csv"] = to_csv(EntryPagesQuery.call(merged_params), EntryPageDecorator)
      @files["exit_pages.csv"] = to_csv(ExitPagesQuery.call(merged_params), ExitPageDecorator)
      @files["operating_systems.csv"] = to_csv(DeviceQuery.call(merged_params(devices_type: "os")), DeviceDecorator)
      @files["top_pages.csv"] = to_csv(TopPageQuery.call(merged_params), TopPageDecorator)
      @files["regions.csv"] = to_csv(RegionQuery.call(merged_params), RegionDecorator)
      @files["sources.csv"] = to_csv(SourceQuery.call(merged_params), SourceDecorator)
      ["campaign", "content", "medium", "source", "term"].each do |utm|
        @files["utm_#{utm.pluralize}.csv"] = to_csv(CampaignQuery.call(merged_params(campaigns_type: "utm_#{utm}")), CampaignDecorator)
      end
      self
    end

    def to_zip
      zip_stream = Zip::OutputStream.write_buffer do |zip|
        @files.each do |filename, csv|
          zip.put_next_entry(filename)
          zip.write(csv)
        end
      end

      zip_stream.rewind
      zip_stream
    end

    private

    def to_csv(query, decorator)
      decorator.to_csv(query, @context)
    end

    def merged_params(params_to_merge = {})
      @params.dup.merge(params_to_merge)
    end
  end
end
