module UserRolesHelper
  def role_icons(user)
    safe_join(UserRole::ALL_ROLES.filter_map { |role| role_icon(user, role) }, " ")
  end

  def role_icon(user, role)
    if current_user&.administrator?
      if user.role?(role)
        image = "roles/#{role}"
        alt = t("users.show.role.revoke.#{role}")
        title = t("users.show.role.revoke.#{role}")
        url = revoke_role_path(:display_name => user.display_name, :role => role)
        confirm = t("user_role.revoke.are_you_sure", :name => user.display_name, :role => role)
      else
        image = "roles/blank_#{role}"
        alt = t("users.show.role.grant.#{role}")
        title = t("users.show.role.grant.#{role}")
        url = grant_role_path(:display_name => user.display_name, :role => role)
        confirm = t("user_role.grant.are_you_sure", :name => user.display_name, :role => role)
      end
    elsif user.role?(role)
      image = "roles/#{role}"
      alt = t("users.show.role.#{role}")
      title = t("users.show.role.#{role}")
    end

    if image
      icon = image_tag("#{image}.png", :srcset => image_path("#{image}.svg"), :size => "20x20", :border => 0, :alt => alt, :title => title)
      icon = link_to(icon, url, :method => :post, :data => { :confirm => confirm }) if url
    end

    icon
  end
end
