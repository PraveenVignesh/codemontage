require "spec_helper"

describe Event do
  it { should have_many(:featured_projects) }
  it { should have_many(:projects).through(:featured_projects) }
  it { should have_many(:event_registrations) }
  it { should have_many(:sponsors).through(:sponsorships) }
  it { should have_many(:sponsorships) }
  it { should have_many(:users).through(:event_registrations) }

  before(:each) do
    @event1 = create(:event, start_date: Time.now, end_date: Time.now+1.day)
    @event2 = create(:event, start_date: Time.now, end_date: Time.now)
    @event3 = create(:event, start_date: Time.now+1.day, end_date: Time.now+2.day)
  end

  describe "upcoming event scope" do

    it "should return only upcoming events" do
      expect(Event.upcoming_events).to eq([@event1, @event3])
    end

  end

  describe "featured events" do

    it "should return only one upcoming event sorted by starting date" do
      expect(Event.featured).to eq(@event1)
    end

  end
end
