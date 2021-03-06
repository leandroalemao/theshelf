shared_examples 'a reviewable resource' do
  let(:resource) { create(described_class.to_s.underscore) }

  context "#total_reviews" do
    it "returns the total number of reviews for the resource" do
      user = build :user
      Review.create(book: resource, reviewer: user, body: 'Nice')

      resource.reload.total_reviews.should eq 1
    end
  end
end
