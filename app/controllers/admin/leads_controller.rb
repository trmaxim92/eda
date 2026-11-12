module Admin
  class LeadsController < BaseController
    before_action :set_lead, only: %i[show edit update]

    def index
      authorize Lead
      @leads = Lead.recent
      @leads = @leads.where(status: params[:status]) if params[:status].present?
      @leads = @leads.where("phone ILIKE ? OR name ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    end

    def show
      authorize @lead
    end

    def edit
      authorize @lead
    end

    def update
      authorize @lead
      if @lead.update(lead_params)
        redirect_to admin_lead_path(@lead), notice: "Заявка обновлена"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_lead
      @lead = Lead.find(params[:id])
    end

    def lead_params
      params.require(:lead).permit(:status, :admin_comment, :name, :phone, :city_id, :courier_type_id)
    end
  end
end
