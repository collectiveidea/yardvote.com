module AuditsHelper
  
  # yes, this is overly simplistic, but I only have a couple use cases
  # create, update, destroy
  def past_tense(present)
    present.sub(/e?$/, 'ed')
  end
end
