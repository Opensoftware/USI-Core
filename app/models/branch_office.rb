class BranchOffice < Faculty

  belongs_to :faculty, touch: true, class_name: "Faculty",
    foreign_key: :overriding_id



end
