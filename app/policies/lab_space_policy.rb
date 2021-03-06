class LabSpacePolicy < ManagedModelsPolicy
  def new?
    return false unless user

    user.superadmin? || user.lab_admin?
  end

  def create?
    return false unless user

    user.superadmin? || user.manages?(record.lab)
  end

  class Scope < Scope
    def alternative_admin_scope
      user.managed_lab_spaces
    end
  end
end
