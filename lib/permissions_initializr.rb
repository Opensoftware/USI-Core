require 'find'

module PermissionsInitializr
  def self.included(base)
    base.extend PermissionsInitializr
  end

  def setup_actions_controllers_db()
    Rails.application.eager_load!
    ApplicationController.subclasses.each do |controller|
      load_permission_from_subclasses(controller)
    end
    if defined?(Diamond)
      Diamond::Engine.eager_load!
      DiamondController.subclasses.each do |controller|
        load_permission_from_subclasses(controller)
      end
    end
    Permission.where(subject_class:[ 'Dashboard', 'UserSession', 'Base']).destroy_all
  end

  def load_permission_from_subclasses(controller)
    if controller.subclasses.present?
      controller.subclasses.each do |subcontroller|
        load_permission_from_subclasses(subcontroller)
      end
    end
    load_permission_from_controller(controller)
  end

  def load_permission_from_controller(controller)
    write_permission(controller, "manage")
    controller.action_methods.each do |action|
      cancan_action = eval_cancan_action(action)
      write_permission(controller, cancan_action)
    end
  end

  def eval_cancan_action(action)
    case action.to_s
    when "index", "show", "search"
      return "read"
    when "create", "new"
      return "create"
    when "edit", "update"
      return "update"
    when "delete", "destroy"
      return "delete"
    end
  end

  def write_permission(controller, cancan_action)
    return if cancan_action.nil?
    unless controller == "all"
      controller = controller.controller_path.classify
    end
    permission  = Permission.where(:subject_class => controller)
      .where(:action => cancan_action).first
    unless permission
      permission = Permission.new
      permission.subject_class = controller.to_s
      permission.action = cancan_action
      permission.save
    end
  end

end
