module CurrencyRates
  mattr_accessor :eur_rates

  self.eur_rates = {
    'EUR' => 1.0,
    'LVL' => 0.702804
  }

  def self.to_eur(amount, currency)
    return unless amount.present?
    unless eur_rates.key?(currency)
      load_rates(currency) if currency.present?
    end
    if rate = eur_rates[currency]
      (amount.to_f / rate).round(2)
    end
  end

  def self.to_lvl(amount, currency)
    if currency == 'LVL'
      amount.present? ? amount.to_f : nil
    elsif eur_amount = to_eur(amount, currency)
      eur_amount * eur_rates['LVL']
    end
  end

  def self.load_rates(currency)
    # get mostly used rates from ECB
    if !eur_rates['USD'] and response_xml_string = http_get("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")
      currencies_xml = Nokogiri::XML response_xml_string
      currencies_xml.css('Cube[currency]').each do |c|
        eur_rates[c[:currency]] = c[:rate].to_f
      end
    end

    # get missing rates from Yahoo
    if currency && currency.length == 3 && !eur_rates[currency]
      currencies_parameter = "s=EUR#{currency}=X"
      yahoo_url = "http://download.finance.yahoo.com/d/quotes.csv?#{currencies_parameter}&f=l1&e=.cs"
      if rates_string = http_get(yahoo_url)
        if (rate = rates_string.to_f) > 0
          eur_rates[currency] = rate
        end
      end
    end

    # If currency rate was not found then set it to nil to avoid repeated lookups
    eur_rates[currency] ||= nil
  end

  def self.http_get(url)
    retry_count = 0

    while retry_count < 3
      begin
        response = HTTParty.get(url, timeout: 10)
        if response.code == 200
          return response.body
        else
          Rails.logger.error "CurrencyRates http_get failed with response code #{response.code}, response body #{response.body.inspect}"
        end
      rescue => e
        Rails.logger.error "CurrencyRates http_get failed with error #{e.class.name}: #{e.message}"
      end
      sleep retry_count * 5 + 1
      retry_count += 1
    end
    nil
  end

end
