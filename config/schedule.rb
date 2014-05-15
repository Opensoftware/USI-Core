if defined?(Diamond)
  every :hour do
    runner "Diamond::ThesisEnrollment.reject_exceeded_enrollments!"
  end
end
