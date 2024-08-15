# frozen_string_literal: true

class FeedbacksController < ApplicationController
  before_action :jwt_authenticate

  def create
    feedback = @current_user.feedbacks.build(feedback_params)
    if feedback.save
      render json: { status: 'success', message: 'フィードバックが登録されました' }, status: :created
    else
      render_error('フィードバックの登録に失敗しました')
    end
  end

  def index
    feedbacks = Feedback.all
    if feedbacks.present?
      render json: { status: 'success', data: feedbacks }, status: :ok
    else
      render json: { status: 'success', message: 'フィードバックはありません' }, status: :ok
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :comment)
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { status: 'error', message: }, status:
  end
end
