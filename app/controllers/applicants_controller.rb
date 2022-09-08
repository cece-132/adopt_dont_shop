class ApplicantsController < ApplicationController

  def index
    @applicants = Applicant.all 
  end

  def show
    @pets = Pet.all
    @applicant = Applicant.find(params[:applicant_id])
    if params[:description].present?
      @applicant.description = params[:description]
      @applicant.status = "Pending"
      @applicant.save
    elsif params[:search_name].present?
      @pets = Pet.search(params[:search_name])
     
    end
    @applicant
  
  end

  def new
    
  end

  def create
    applicant = Applicant.create(applicant_params)
    if applicant.valid?
      applicant.update(status: "In Progress")
      redirect_to "/applicants/#{applicant.id}"
    else
     flash[:notice] = applicant.errors.full_messages.to_sentence
      redirect_to '/applicants/new'
    end 
  end

    def update
      applicant = Applicant.find(applicant_params)

      if applicant.update(description: params[:description],status: "Pending")
        redirect_to("/applicants/#{applicant.id}")
      else
        redirect_to("/applicants/#{applicant.id}")
        flash[:alert] = "Error: #{error_message(applicant.errors)}"
    end
  end




  private
  def applicant_params 
    params.permit(:name, :street_address, :city, :state, :zip_code, :description)
  end

end