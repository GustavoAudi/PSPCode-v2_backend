# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  order       :integer
#  first       :boolean          default(FALSE)
#  last        :boolean          default(FALSE)
#

require 'rails_helper'

describe Phase do
  describe 'Associations' do
    it { is_expected.to have_many(:psp_process_phases) }
    it { is_expected.to have_many(:processes).through(:psp_process_phases) }
    it { is_expected.to have_many(:phase_instances) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:order) }

    context 'validate name uniqueness' do
      subject(:phase) { build :phase }

      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    end

    describe 'order attr' do
      it 'validate uniqueness' do
        create :phase, order: 1
        new_phase = build :phase, order: 1
        expect(new_phase.valid?).to be_falsey
        expect(new_phase.errors[:order]).to include 'has already been taken'
      end

      it 'validates numericality' do
        new_phase = build :phase, order: 0.1
        expect(new_phase.valid?).to be_falsey
        expect(new_phase.errors[:order]).to include 'must be an integer'
      end

      it 'validates inclusion' do
        create_list :phase, 4
        new_phase = build :phase, order: 1000
        expect(new_phase.valid?).to be_falsey
        expect(new_phase.errors[:order])
          .to include "should be included within 1 and #{Phase.count + 1}"
      end
    end

    describe 'be_first_and_last_phase' do
      context 'when phase is set as first phase only' do
        let(:phase) { build :phase, first: true }
        it 'does not raise validation' do
          expect(phase.valid?).to be_truthy
        end
      end

      context 'when phase is set as last phase only' do
        let(:phase) { build :phase, last: true }
        it 'does not raise validation' do
          expect(phase.valid?).to be_truthy
        end
      end

      context 'when phase is set as first and last phase' do
        let(:phase) { build :phase, first: true, last: true }
        it 'raise validation' do
          expect(phase.valid?).to be_falsey
          expect(phase.errors[:phase])
            .to include 'can\'t be first and last phase at the same time'
        end
      end
    end
  end
end
