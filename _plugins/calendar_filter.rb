module Jekyll
  module CalendarFilter
    def is_sameday(event)
      start_date = event["start_date"]
      end_date = event["end_date"]
      start_date.year == end_date.year and start_date.month == end_date.month and start_date.day == end_date.day
    end

    def datelize(data, *fields)
      data.select do |item|
        fields.each do |field|
          item[field] = DateTime.parse(item[field])
        end
        item
      end
    end

    def date_query(data, field_prop, comp_value)
      field, property = field_prop.split("__")
      compare = comp_value[0]
      value = comp_value[1..-1].to_i
      case compare
      when "="
        control = proc{|x| x == value}
      end
      data.select{|item| control[item[field].method(property.to_sym).call]}
    end

  end
end
Liquid::Template.register_filter(Jekyll::CalendarFilter)