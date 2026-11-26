require "test_helper"

class FederationAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @entry_file = file_fixture("conc1694854.xml").read
    @show = EntryFile.new(@entry_file).tap(&:import).show
  end

  test "entries of a show are refused without an api key" do
    get show_entries_url(@show)

    assert_response :unauthorized
    assert_empty response.body
  end

  test "entries of a show are refused with a wrong api key" do
    get show_entries_url(@show), headers: { "X-FEDERATION-API-KEY" => "wrong" }

    assert_response :unauthorized
    assert_empty response.body
  end

  test "entries of a show are given with the api key" do
    get show_entries_url(@show), headers: authorized

    assert_response :success
    assert_equal @show.id.to_s, response.parsed_body.dig("show", "id")
  end

  test "results of a show are refused without an api key" do
    get show_results_url(@show)

    assert_response :unauthorized
    assert_empty response.body
  end

  test "an entry file is refused without an api key and nothing is stored" do
    assert_no_difference -> { EntryFileUpload.count } do
      post file_entries_url, params: @entry_file, headers: { "Content-Type" => "application/xml" }
    end

    assert_response :unauthorized
  end

  test "an entry file is converted with the api key" do
    post file_entries_url, params: @entry_file, headers: authorized.merge("Content-Type" => "application/xml")

    assert_response :success
    assert_equal @show.id.to_s, response.parsed_body.dig("show", "id")
  end

  test "a result file is refused without an api key" do
    post file_results_url, params: { show: { foreign_id: @show.id } }.to_json, headers: { "Content-Type" => "application/json" }

    assert_response :unauthorized
    assert_empty response.body
  end

  test "results are refused without an api key" do
    post results_url, params: {}.to_json, headers: { "Content-Type" => "application/json" }

    assert_response :unauthorized
  end

  test "results are accepted with the api key" do
    post results_url, params: {}.to_json, headers: authorized.merge("Content-Type" => "application/json")

    assert_response :accepted
  end

  private

  def authorized
    { "X-FEDERATION-API-KEY" => Rails.application.credentials.federation_api_key }
  end
end
