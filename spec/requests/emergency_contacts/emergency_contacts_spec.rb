require 'rails_helper'

RSpec.describe "EmergencyContacts", type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:emergency_contact) { create(:emergency_contact, user: user) }
  
  describe "POST /api/emergency_contacts" do
    let(:valid_params) { { emergency_contact: attributes_for(:emergency_contact) } }
    
    context "リクエストが有効な場合" do
      before do
        post "/api/emergency_contacts", params: valid_params, headers: headers
      end

      it "緊急連絡先を登録する" do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["message"]).to eq("緊急連絡先が登録されました")
      end
    end

    context "リクエストが無効な場合" do
      let(:invalid_params) { { emergency_contact: { name: nil, relationship: nil, email: nil } } }
      before do
        post "/api/emergency_contacts", params: invalid_params, headers: headers
      end

      it "ステータスコード 422 を返す" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /api/emergency_contacts' do
    context '緊急連絡先が登録されている場合' do
      before do
        create_list(:emergency_contact, 3, user: user)
        get '/api/emergency_contacts', headers: headers
      end

      it 'ステータスコード 200 を返す' do
        expect(response).to have_http_status(:ok)
      end

      it '緊急連絡先の一覧を返す' do
        json_response = JSON.parse(response.body)
        expect(json_response['data'].size).to eq(3)
      end
    end

    context '緊急連絡先が登録されていない場合' do
      before do
        get '/api/emergency_contacts', headers: headers
      end

      it 'ステータスコード 404 を返す' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  
  describe 'PUT /api/emergency_contacts/:id' do
    let(:valid_attributes) { { emergency_contact: {name: '新しい名前', relationship: '友人', phone_number: '0123456789', email: 'new@example.com' } }}

    context '緊急連絡先が正常に更新される場合' do
      before do
        put "/api/emergency_contacts/#{emergency_contact.id}", params: valid_attributes, headers: headers
      end

      it 'ステータスコード 200 を返す' do
        expect(response).to have_http_status(:ok)
      end

      it '更新された情報を返す' do
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('緊急連絡先が更新されました')
      end
    end

    context '対象の緊急連絡先が見つからない場合' do
      before do
        put "/api/emergency_contacts/#{emergency_contact.id + 1}", params: valid_attributes, headers: headers
      end

      it 'ステータスコード 404 を返す' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '緊急連絡先の更新に失敗する場合' do
      let(:invalid_attributes) { { name: '' } } # 無効な属性（名前が空）

      before do
        put "/api/emergency_contacts/#{emergency_contact.id}", params: { emergency_contact: invalid_attributes }, headers: headers
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/emergency_contacts/:id' do
    context '緊急連絡先が正常に削除される場合' do
      before do
        delete "/api/emergency_contacts/#{emergency_contact.id}", headers: headers
      end

      it 'ステータスコード 200 を返す' do
        expect(response).to have_http_status(:ok)
      end

      it '正しいメッセージを含むレスポンスを返す' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('緊急連絡先が削除されました')
      end
    end

    context '対象の緊急連絡先が見つからない場合' do
      before do
        delete "/api/emergency_contacts/#{emergency_contact.id + 1}", headers: headers
      end

      it 'ステータスコード 404 を返す' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context '未認証ユーザーが削除を試みた場合' do
      before do
        delete "/api/emergency_contacts/#{emergency_contact.id}", headers: {}
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

