require 'digest/sha1'

module Student::Persistence

  class Failure < Exception; end

  class UpdateEngine

    attr_reader :xls, :sheet

    def perform_update

      student_role = Role.find_by(const_name: "student")

      User.transaction do
        begin
          users_dict = []
          loop do |row, idx|
            row = build_row(row, idx)
            email = row.get(:email)

            # Check if an user exists in database for given index number
            if(student = Student
               .find_by(index_number: row.get(:index_number).to_i)).present?

              user = student.try(:user)
            end

            # Assign new e-mail address if it's been changed
            if user.present? && email.present? &&
                user.email.downcase != email.downcase
              user.email = email
            end

            if user.blank?
              user = User.new(:email => email)
              user.role = student_role
              password = row.get(:id_number).to_s.strip
              if password.blank?
                password = Digest::SHA1.hexdigest "#{email}#{Time.now.to_s}"
              end
              user.password = password
              user.password_confirmation = password
              unless user.valid?
                raise ActiveRecord::RecordInvalid, user
              end
              user.verifable = Student.new
            end

            student_attributes = {}
            student_attributes[:surname] = row.get(:surname).to_s.strip
            student_attributes[:name] = row.get(:name).to_s.strip
            student_attributes[:index_number] = row.get(:index_number).to_i
            student_attributes.each do |attr_name, value|
              user.verifable.send("#{attr_name}=", value)
            end

            studies_attributes = {}
            studies_attributes[:course_id] = Course
            .where("name ilike ?", row.get(:course_id).strip).first.try(:id)
            studies_attributes[:study_type_id] = StudyType
            .where("name ilike ?", row.get(:study_type_id).strip).first.try(:id)
            studies_attributes[:study_degree_id] = StudyDegree
            .where("short_name ilike ?", row.get(:study_degree_id).strip.split(" ")[0]).first.try(:id)
            studies_attributes[:specialty_id] = Specialization
            .where("name ilike ?", row.get(:specialty_id).to_s.strip).first.try(:id)

            studies_attributes.delete_if {|attr_name, v|  v.blank? }
            [:course_id, :study_type_id, :study_degree_id].each do |key|
              unless studies_attributes[key].present?
                fail!(user, row.get(key))
              end
            end


            studies = Studies
            .find_by(course_id: studies_attributes[:course_id],
                     study_type_id: studies_attributes[:study_type_id],
                     study_degree_id: studies_attributes[:study_degree_id],
                     specialty_id: studies_attributes[:specialty_id])

            if studies.blank?
              message = [
                row.get(:course_id),
                *("(#{row.get(:specialty_id)})" if row.get(:specialty_id).present?)
              ].join(" ")
              fail!(user, message)
            end

            student_studies_attributes = {}
            student_studies_attributes[:average_grade] =
              row.get(:average_grade).to_s.strip.gsub(/\,/, '.')
            student_studies_attributes[:passed_ects] =
              row.get(:passed_ects).to_s.strip
            student_studies_attributes[:semester_number] =
              row.get(:semester_number).to_i

            student_studies_attributes.delete_if {|attr_name, v|  v.blank? }
            # Expect semester_number to be an integer greater than 0.
            [:semester_number].each do |key|
              if student_studies_attributes[key] == 0
                fail!(user, row.get(key))
              end
            end

            student_studies = user.verifable.student_studies
            .detect {|ss| ss.studies_id == studies.id }
            # If student is not assigned to any studies, assign him
            # to that studies.
            if user.verifable.student_studies.blank?
              user.verifable.student_studies << StudentStudies.new(
                semester_number: student_studies_attributes[:semester_number],
                average_grade: student_studies_attributes[:average_grade],
                passed_ects: student_studies_attributes[:passed_ects],
                studies: studies
              )
              # Student is assigned to some studies,
              # however these do not match found studies. Need to check
              # additional use cases.
            elsif user.verifable.student_studies.present? && student_studies.blank?
              # A. Detect if student has changed his studies study type
              # B. Detect if student finished first degree studies
              # and started second degree studies.
              student_studies = user.verifable.student_studies
              .detect {|ss| ss.studies.course_id == studies.course_id &&
                ss.studies.study_degree_id == studies.study_degree_id &&
                ss.studies.specialty_id == studies.specialty_id
              } || user.verifable.student_studies
              .detect {|ss| ss.studies.course_id == studies.course_id &&
                ss.studies.study_degree_id < studies.study_degree_id
              }

              if student_studies.present?
                student_studies.studies = studies
                student_studies.semester_number = student_studies_attributes[:semester_number]
              end
            else
              student_studies_attributes.each do |attr_name, value|
                student_studies.send("#{attr_name}=", value)
              end
            end

            users_dict << user
          end
          users_dict.each do |user|
            user.save!
            user.verifable.save!
            user.silent_activate!
          end
        rescue Student::Persistence::Failure => e
          context.fail!(:message => e.message)
        rescue ActiveRecord::RecordInvalid => e
          context.fail!(:message =>
                        I18n.t('error.cannot_upgrade_student',
                               :student => e.record.surname_name))
        end
      end

    end

    private

    def loop
      raise "implement"
    end

    def build_row(row, idx)
      raise "implement"
    end

    def fail!(user, value = '')
      raise(Failure, I18n.t('error.students_upgrade_studies_params_invalid',
                            :student => user.verifable.surname_name,
                            :value => value))
    end
  end

end
