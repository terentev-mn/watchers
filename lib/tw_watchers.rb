module TwWatchers
    class Hooks < Redmine::Hook::ViewListener
        def view_issues_new_top(context = {})
            # Rails.logger.info("Tw Watchers: Context #{context}")
            if Setting.plugin_watchers['show_author'] or Setting.plugin_watchers['show_groups']
                if not context[:issue].watcher_user_ids
                    context[:issue].watcher_user_ids = Array.new
                end
                arr=context[:issue].watcher_user_ids

                # add author
                if Setting.plugin_watchers['show_author']
                    # Rails.logger.info("Tw Watchers: Add creator user #{User.current} id=#{User.current.id}")
                    add_watch_arr(arr,User.current.id)
                end

                # add groups
                if Setting.plugin_watchers['show_groups']
                    groups=User.current.group_ids
                    # Rails.logger.info("Tw Watchers: Add groups #{groups}")
                    groups.each do |g|
                        add_watch_arr(arr,g)
                    end
                end

                # Rails.logger.info("Tw Watchers: Add context. Context #{context}")
                context[:issue].watcher_user_ids=arr
                # send context to _watchers_form.html.erb via fake page
                context[:controller].send(:render_to_string, partial: 'watchers/add_context', locals: context)
            end
        end


        def add_watch_arr(arr, obj)
            if not arr.include?(obj.to_i)
                arr << obj.to_i
            end
        end


        def controller_issues_new_before_save(context = {})
            # Rails.logger.info("Tw Watchers: Context #{context}")
            # when hook applying in view_issues_new_top 'assigned_to' is not defined yet, so add him here
            if Setting.plugin_watchers['add_assigned_user']
                # Rails.logger.info("Tw Watchers: Assign issue to creator #{User.find_by_id(context[:issue][:assigned_to_id])}")
                if context[:params][:issue][:assigned_to_id] and context[:params][:issue][:assigned_to_id].length() > 0
                    if not context[:issue].watcher_user_ids
                        context[:issue].watcher_user_ids = Array.new
                    end
                    arr=context[:issue].watcher_user_ids

                    add_watch_arr(arr,context[:params][:issue][:assigned_to_id])
                    context[:issue].watcher_user_ids=arr
                end
            end
        end
    end
end


