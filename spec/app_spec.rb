# frozen_string_literal: true

require 'spec_helper'

RSpec.describe App, type: :request do
  def app
    App
  end

  describe 'GET /visited_domains' do
    it 'gets error message without params' do
      get 'visited_domains'
      expect(last_response.body).to include 'You have to provide FROM and TO parameters'
    end

    it 'not gets error message with valid params' do
      get 'visited_domains', from: '1000000001', to: '9999999998'
      expect(JSON.parse(last_response.body)['status']).to eq 'ok'
    end

    it 'is empty on startup' do
      get 'visited_domains', from: '1000000001', to: '9999999998'
      expect(JSON.parse(last_response.body)['domains']).to eq []
    end

    it 'gets error message with invalid FROM param' do
      get 'visited_domains', from: 'abc', to: '9999999998'
      expect(JSON.parse(last_response.body)['status']).to eq 'You have to pass valid FROM and TO parameters'
    end

    it 'gets error message with invalid TO param' do
      get 'visited_domains', from: '1000000001', to: 'abc'
      expect(JSON.parse(last_response.body)['status']).to eq 'You have to pass valid FROM and TO parameters'
    end
  end

  describe 'POST /visited_links' do
    context 'with valid links' do
      it 'adds valid links' do
        post 'visited_links', links: ['https://ya.ru', 'https://ya.ru?q=123', 'funbox.ru', 'https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor']
        expect(JSON.parse(last_response.body)['status']).to eq 'ok'

        get 'visited_domains', from: '1000000001', to: Time.now.to_i.to_s
        expect(JSON.parse(last_response.body)['domains']).to include 'funbox.ru'
      end
    end

    context 'with invalid links' do
      it 'not adding invalid links' do
        post 'visited_links', links: ['yaru', 'https://ya.ru?q=123', '3@#$', 'ysnex.com']
        expect(JSON.parse(last_response.body)['status']).to eq 'ok'

        get 'visited_domains', from: '1000000001', to: Time.now.to_i.to_s
        expect(JSON.parse(last_response.body)['domains']).not_to include '3@#$'
        expect(JSON.parse(last_response.body)['domains']).to include 'ysnex.com'
      end
    end
  end
end
