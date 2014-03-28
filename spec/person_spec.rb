require 'spec_helper'

describe Person do
  it { should belong_to :parent }

  it { should validate_presence_of :name }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be false
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end

  describe ".find_person" do
    it 'finds a person by their name.' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      Person.find_by(name: 'Earl').should eq earl
    end
  end

  describe "#find_children" do
    it 'finds a child' do
      test_person_one = Person.create(:name => 'Earl')
      test_person_two = Person.create(:name => 'Steve')
      test_parent = Parent.create(:parent_one_id => test_person_one.id, :parent_two_id => test_person_two.id)
      test_person_three = Person.create(:name => 'George', :parent_id => test_parent.id)
      test_person_one.find_children.should eq [test_person_three]
    end
  end
  describe "#find_siblings" do
    it 'finds a sibling' do
      test_person_one = Person.create(:name => 'Earl', :parent_id => 3)
      test_person_two = Person.create(:name => 'Steve', :parent_id => 3)
      test_person_three = Person.create(:name => 'George', :parent_id => 1)
      test_person_two.find_siblings.should eq [test_person_one]
    end
  end
end
