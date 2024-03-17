class EmergencyContactsController < ApplicationController
  before_action :jwt_authenticate

  # 緊急連絡先登録
  def create
    emergency_contact = @current_user.emergency_contacts.build(emergency_contact_params)
    if emergency_contact.save
      render json: { status: 'success', message: '緊急連絡先が登録されました' }, status: :created
    else
      render_error('緊急連絡先の登録に失敗しました')
    end
  end

  # 緊急連絡一覧取得
  def index
    emergency_contacts = @current_user.emergency_contacts
    return render_error('緊急連絡先が登録されていません', :not_found) if emergency_contacts.empty?

    data = emergency_contacts.map(&:attributes)
    render json: { status: 'success', data: data }, status: :ok
  end

  # 緊急連絡先更新
  def update
    emergency_contact = @current_user.emergency_contacts.find_by(id: params[:id])
    return render_error('緊急連絡先が見つかりません', :not_found) if emergency_contact.nil?

    if emergency_contact.update(emergency_contact_params)
      render json: { status: 'success', message: '緊急連絡先が更新されました' }, status: :ok
    else
      render_error('緊急連絡先の更新に失敗しました')
    end
  end

  # 緊急連絡先削除
  def destroy
    emergency_contact = @current_user.emergency_contacts.find_by(id: params[:id])
    return render_error('緊急連絡先が見つかりません', :not_found) if emergency_contact.nil?

    if emergency_contact.destroy
      render json: { status: 'success', message: '緊急連絡先が削除されました' }, status: :ok
    else
      render_error('緊急連絡先の削除に失敗しました')
    end
  end

  private

  def emergency_contact_params
    params.require(:emergency_contact).permit(:name, :relationship, :phone_number, :email, :line_id)
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { status: 'error', message: message }, status: status
  end
end
