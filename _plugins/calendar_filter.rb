module Jekyll
  module CalendarFilter
    def same_day?(date1, date2)
      if (date1.year == date2.year) and (date1.month == date2.month) and (date1.day == date2.day)
        true
      else
        false
      end
    end

    def calendar(data, show_date = nil)
      return_value = data
      if show_date
        show_date = DateTime.parse("#{show_date}-01")
        condition = [
          proc{|i| DateTime.parse(i).month == show_date.month},
          proc{|i| DateTime.parse(i).year == show_date.year}
        ]
        return_value = data.select{|item| condition.all?{|c| c[item["start_date"]] }}.map do |item|
          start_date = DateTime.parse(item["start_date"])
          end_date = DateTime.parse(item["end_date"])
          end_time = nil
          if same_day?(start_date, end_date)
            end_time = end_date
          end
          item["start_date"] = start_date
          item["end_time"] = end_time
          item
        end
      end
      return_value.sort_by{|item| item["start_date"]}
    end
  end
end
Liquid::Template.register_filter(Jekyll::CalendarFilter)