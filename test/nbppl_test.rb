require "test_helper"

class NbpplTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Nbppl::VERSION
  end

  def test_fetch_mid_rate_returns_rate_for_valid_date_and_currency
    VCR.use_cassette("exchangerates_rates_a_EUR_2021-06-01", allow_unused_http_interactions: false) do
      rate = Nbppl::Client.new.fetch_mid_rate("EUR", Date.parse("2021-06-01"))
      assert_equal rate, 4.4749
    end
  end

  def test_fetch_mid_rate_returns_rate_from_cache
    VCR.use_cassette("exchangerates_rates_a_EUR_2021-06-01", allow_unused_http_interactions: false) do
      client = Nbppl::Client.new
      rate = client.fetch_mid_rate("EUR", Date.parse("2021-06-01"))
      assert_equal rate, 4.4749
      rate = client.fetch_mid_rate("EUR", Date.parse("2021-06-01"))
      assert_equal rate, 4.4749
    end
  end

  def test_fetch_mid_rate_returns_nil_for_weekend_from_cache
    VCR.use_cassette("exchangerates_rates_a_EUR_2021-06-05", allow_unused_http_interactions: false) do
      client = Nbppl::Client.new
      assert_nil client.fetch_mid_rate("EUR", Date.parse("2021-06-05"))
      assert_nil client.fetch_mid_rate("EUR", Date.parse("2021-06-05"))
    end
  end

  def test_fetch_mid_rate_returns_nil_for_date_on_weekend_and_valid_currency
    VCR.use_cassette("exchangerates_rates_a_EUR_2021-06-05", allow_unused_http_interactions: false) do
      assert_nil Nbppl::Client.new.fetch_mid_rate("EUR", Date.parse("2021-06-05"))
    end
  end

  def test_fetch_mid_rate_returns_nil_for_valid_date_but_invalid_currency
    VCR.use_cassette("exchangerates_rates_a_FOO_2021-06-01", allow_unused_http_interactions: false) do
      assert_nil Nbppl::Client.new.fetch_mid_rate("FOO", Date.parse("2021-06-01"))
    end
  end

  def test_fetch_mid_rate_raises_exception_for_date_in_future
    VCR.use_cassette("exchangerates_rates_a_EUR_2021-06-08", allow_unused_http_interactions: false) do
      error = assert_raises(Nbppl::ErrorResponse) do
        Nbppl::Client.new.fetch_mid_rate("EUR", Date.parse("2021-06-08"))
      end
      assert_equal error.message, "400, 400 BadRequest - Błędny zakres dat / Invalid date range"
    end
  end

  def test_closest_mid_returns_rate_and_date_from_closest_day_in_past
    VCR.use_cassette("exchangerates_rates_a_USD_2021-06-06_2021-06-05_2021-06-04", allow_unused_http_interactions: false) do
      rate, date = Nbppl::Client.new.closest_mid_rate("USD", Date.parse("2021-06-06"))
      assert_equal rate, 3.6931
      assert_equal date.to_s, "2021-06-04"
    end
  end
end
