require 'rails_helper'

RSpec.describe EquipmentPolicy, type: :policy do
  subject { described_class.new(user, equipment) }

  let(:lab) { create :lab }
  let(:lab_space) { create :lab_space, lab: lab }
  let(:equipment) { create :equipment, lab_space: lab_space }

  context 'for a visitor' do
    let(:user) { nil }
    it { should permit_actions([:index, :show]) }
    it { should forbid_actions([:new, :create, :edit, :update, :destroy]) }
  end

  context 'for a regular user' do
    let(:user) { create :user }
    it { should permit_actions([:index, :show]) }
    it { should forbid_actions([:new, :create, :edit, :update, :destroy]) }
  end

  context 'for a superadmin' do
    let(:user) { create :user, role: :superadmin }
    it { should permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
  end

  context 'for a lab space admin of that lab' do
    let(:user) do
      admin = create :user, role: :lab_space_admin
      lab.admins << admin
      admin
    end

    it { should permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
  end

  context 'for a lab admin of that lab space' do
    let(:user) do
      lab_admin = create(:user, role: :lab_admin)
      lab_space.admins << lab_admin
      lab_admin
    end

    it { should permit_actions([:index, :show, :new, :create, :edit, :update, :destroy]) }
  end

  context 'for a lab space admin of another lab' do
    let(:user) { create(:user, role: :lab_space_admin) }
    let(:new_lab) do
      new_lab = create(:lab)
      new_lab.admins << user
      new_lab
    end

    # :new omitted
    it { should permit_actions([:show, :index]) }
    it { should forbid_actions([:create, :edit, :update, :destroy]) }
  end

  context 'for a lab admin of another lab space' do
    let(:user) { create(:user, role: :lab_admin) }
    let(:new_lab_space) do
      new_lab_space = create :lab_space, lab: lab
      new_lab_space.admins << user
      new_lab_space
    end

    # :new omitted
    it { should permit_actions([:show, :index]) }
    it { should forbid_actions([:create, :edit, :update, :destroy]) }
  end
end
