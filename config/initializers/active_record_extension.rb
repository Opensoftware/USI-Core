class ActiveRecord::Relation
  def let
    return yield self
  end
end