require 'rails_helper'

RSpec.describe MembersController, type: :controller do
    let!(:member) {create(:member, :with_headings)}
    let(:body) { JSON.parse(response.body, symbolize_names: true) }
    let(:valid_session) { {} }

    describe "GET #index" do
        it "returns a success response" do
            get :index
            expect(response).to be_successful
        end
    end
    describe "GET #show" do
        context 'valid id' do
            it "returns a success response" do
                get :show, params: {id: member.id}
                expect(response).to be_successful
            end
        end
        context 'member does not exist' do
            it "returns a resource not found" do
                get :show, params: {id: 3123}
                expect(response).to be_not_found
            end
        end
    end
    describe "GET #search" do

        context 'nothing found' do
            it "returns empty response" do
                get :search, params: {id: 1, heading: 'random'}
                expect(body[:data]).to eq([])
            end
        end
        context 'found outside of network' do
            let!(:member2) {create(:member, :with_headings)}

            it "returns member without connection" do
                get :search, params: {id: 1, heading: member2.headings.first.heading}
                expect( body[:data][0][:attributes][:connection]).to eq("outside of your network")
            end
        end
        context 'found with connection' do
            let!(:member3) {create(:member, :with_headings)}
            let!(:member4) {create(:member, :with_headings)}
            let(:result) {"#{member.name}->#{member3.name}->#{member4.name}"}
            before do
                member.befriend(member3)
                member3.befriend(member4)
            end
            it "returns member with connection" do
                get :search, params: {id: 1, heading: member4.headings.first.heading}
                expect( body[:data][0][:attributes][:connection]).to eq(result)
            end
        end
    end
    describe "patch #befriend" do
        context 'befriending another member' do
            let(:member1) {create(:member)}
            it "returns a success response" do
                patch :befriend, params: {id: member.id, friend_id: member1.id}
                expect(response).to be_successful
            end
        end
        context 'befriending oneself' do
            let(:member1) {create(:member)}
            it "returns an error" do
                patch :befriend, params: {id: member.id, friend_id: member.id}
                expect(body[:errors][:base]).to include('cannot be yourself')
            end
        end
    end

    describe "post #create" do
        context 'successfully created' do
            let(:payload){{member: {name:'something', url: "https://www.google.com/"}}}
            it "creates a member" do
                post :create, params: payload
                expect( body[:data][:attributes][:name]).to eq("something")
            end
        end
        context 'member exists' do
            let(:payload){{member: {name:member.name, url: member.url}}}
            it "creates a member" do
                post :create, params: payload
                expect( body[:data][:id]).to eq(member.id.to_s)
            end
        end
    end
end
