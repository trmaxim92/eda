class LeadsController < ApplicationController
  def create
    if params[:company].present?
      redirect_to thank_you_path and return
    end

    @lead = Lead.new(lead_params.merge(attribution_attrs))
    @lead.ip_address = request.remote_ip
    @lead.city_name ||= @lead.city&.name
    @lead.courier_type_name ||= @lead.courier_type&.name
    @lead.status = :new_lead

    if @lead.save
      redirect_to thank_you_path, notice: "Заявка отправлена. Мы свяжемся с вами."
    else
      redirect_back fallback_location: root_path, alert: @lead.errors.full_messages.to_sentence
    end
  end

  def thank_you
    set_seo_meta(title: "Заявка принята", robots: "noindex,nofollow")
  end

  private

  def lead_params
    params.require(:lead).permit(:name, :phone, :city_id, :courier_type_id, :consent, :city_name, :courier_type_name)
  end
end
