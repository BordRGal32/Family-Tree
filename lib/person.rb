class Person < ActiveRecord::Base
  belongs_to :parent

  validates :name, :presence => true

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      false
    else
      Person.find(spouse_id)
    end
  end

  def find_parents
    parents = []
    if parent_id.nil?
      false
    else
      parent_one = Person.find(parent.parent_one_id)
      parent_two = Person.find(parent.parent_two_id)
      parents << parent_one
      parents << parent_two
    end
    parents
  end

  def find_siblings
    if parent_id.nil?
      false
    else
      sibling = Person.where(:parent_id => self.parent_id)
      sibling.delete(self)
      sibling
    end
  end

  def find_children
    if Parent.where(:parent_one_id => self.id)
      childs_parent = Parent.where(:parent_one_id => self.id)
      children = Person.where(:parent_id => childs_parent.first.id)
    elsif Parent.where(:parent_two_id => self.id)
      childs_parent = Parent.where(:parent_two_id => self.id)
      children = Person.where(:parent_id => childs_parent.first.id)
    end
  end

  def self.find_person(name)
    Person.find_by(:name => name)
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
