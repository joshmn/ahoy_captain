module AhoyCaptain
  module Tables
    class PropertiesTableComponent < DynamicTable
      register do
        progress_bar :label, value: :percentage, max: 100, title: "Name" do |item|
          link_to item.label, url(item), target: :_top
        end
        number :unique_visitors_count, title: "Visitors"
        number :events_count, title: "Events"
        percent :percentage, title: "%"
      end

      def self.url(item)
        name = Base64.decode64(item.request.params[:id])
        params = item.search_params.dup
        if params["q"] && params["q"].key?("properties_json_cont")
          json = JSON.parse(params["q"]["properties_json_cont"])
          json[name] = item.item.label
          params["q"]["properties_json_cont"] = json.to_json
        else
          params[:q] = { "properties_json_cont" => { name => item.item.label }.to_json }
        end
        params
      end
    end
  end
end
