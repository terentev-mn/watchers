module TwWatchers
    class Hooks < Redmine::Hook::ViewListener
        def view_issues_new_top(context = {})
            # Rails.logger.info("Tw Watchers: Context #{context}")
            if not context[:issue].watcher_user_ids
                context[:issue].watcher_user_ids = Array.new
            end
            arr=context[:issue].watcher_user_ids
            # add author
            # Rails.logger.info("Tw Watchers: Add creator user #{User.current} id=#{User.current.id}")
            add_watch_arr(arr,User.current.id)
            # add groups
            groups=User.current.group_ids
            groups.each do |g|
              add_watch_arr(arr,g)
            end

            context[:issue].watcher_user_ids=arr
            # send context to _watchers_form.html.erb via fake page
            context[:controller].send(:render_to_string, partial: 'watchers/add_context', locals: context)
        end
        def add_watch_arr(arr, obj)
            if not arr.include?(obj.to_i)
                arr << obj.to_i
            end
        end
        def controller_issues_new_before_save(context = {})
            # Rails.logger.info("Tw Watchers: Context #{context}")
            # when hook applying in view_issues_new_top 'assigned_to' is not defined yet, so add him here
            if context[:params][:issue][:assigned_to_id] and context[:params][:issue][:assigned_to_id].length() > 0
                if not context[:issue].watcher_user_ids
                    context[:issue].watcher_user_ids = Array.new
                end
                arr=context[:issue].watcher_user_ids

                # Rails.logger.info("Tw Watchers: Add assigned user #{User.find(context[:issue][:assigned_to_id])} id=#{context[:issue][:assigned_to_id]}")
                add_watch_arr(arr,context[:params][:issue][:assigned_to_id])
                context[:issue].watcher_user_ids=arr
            end

        end
    end
end


