class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :edit, :update, :create, :destroy, :to => :manage_own
    alias_action :read_own, :edit, :update, :to => :manage_own_excluding_creation

    user ||= User.new
    if user.new_record?
      user.role = Role.find_by_name("Anonymouse")
    else
      can :manage, :my
    end

    # TODO improve that code, split into private methods and get rid of those
    # evals.
    unless user.role.nil?
      @role = Role.includes(:permissions).where(:id => user.role.id).first
      @role.permissions.each do |permission|
        unless permission.cannot?
          if permission.subject_id.nil?
            if permission.condition.present?
              unless permission.block.blank?
                can permission.action.to_sym, permission.subject_class.constantize, eval(permission.condition) do |class_object|
                  eval(permission.block)
                end
              else
                can permission.action.to_sym, permission.subject_class.constantize, eval(permission.condition)
              end
            else
              if permission.subject_class.downcase == "all"
                can permission.action.to_sym, permission.subject_class.downcase.to_sym
              else
                can permission.action.to_sym, permission.subject_class.constantize
              end
            end
          else
            can permission.action.to_sym, permission.subject_class.constantize, :id => permission.subject_id
          end
        else
          cannot permission.action.to_sym, permission.subject_class.constantize
        end
      end
    end
  end

end
