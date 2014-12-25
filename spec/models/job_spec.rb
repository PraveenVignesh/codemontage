require 'spec_helper'

describe Job do
  it { should belong_to(:organization) }

  before(:each) do
    @organization = create(:organization)
    @job1 = create(:job, :organization_id => @organization.id, :expires_at => DateTime.now+1.day)
    @job2 = create(:job, :organization_id => @organization.id, :expires_at => DateTime.now-1.day)
    @job3 = create(:job, :organization_id => @organization.id)
  end

  describe "active scope" do

    it "should return jobs which not expires or does not have expires_at field" do
      expect(Job.active).to eq([@job1, @job3])
    end

  end

end
