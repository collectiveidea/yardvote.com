class AuditsController < ApplicationController
  def index
    @audits = Audit.all(:order => 'created_at DESC')
  end
end
