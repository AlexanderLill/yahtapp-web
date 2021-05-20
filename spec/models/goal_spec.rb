require 'rails_helper'

describe Goal, type: :model do
  context "When cloning a goal" do
    let(:user) { create(:user) }
    before do
      @goal = create(:goal, is_template: true)
      @new_goal = @goal.clone(user)
    end
    it "fails if goal is not a template" do
      goal = create(:goal, is_template: false)
      expect { goal.clone(user) }.to raise_error
    end
    it "creates a copy of the goal and all relevant attributes" do
      expect(@new_goal.title).to eq(@goal.title)
      expect(@new_goal.description).to eq(@goal.description)
      expect(@new_goal.color).to eq(@goal.color)
    end
    it "sets the template_id to the cloned goal" do
      expect(@new_goal.template_id).to eq(@goal.id)
    end
    it "sets is_template of the cloned goal to false" do
      expect(@new_goal.is_template).to be_falsey
    end
    it "sets the correct user on the cloned goal" do
      expect(@new_goal.user).to eq(user)
    end
    it "sets correct timestamps on clone" do
      expect(@new_goal.created_at).to_not eq(@goal.created_at)
      expect(@new_goal.updated_at).to_not eq(@goal.updated_at)
    end

  end
end
