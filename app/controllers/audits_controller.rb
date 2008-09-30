class AuditsController < ApplicationController
  def index
    @audits = Audit.all(:order => 'created_at DESC', :limit => 100)
  end
end
