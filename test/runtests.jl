using Test, AlphaVantage, Dates, DataFrames, CryptoDashApp, HTTP, JSON, Query

AlphaVantage.global_key!("AKTJ25ALEBBLH1QJ")

# Check if "data" folder exists, if not, create a new one
if isdir("data")
    @info "data folder exists, cleanup action will be performed!"
else
    mkdir("data")
    @info "New data folder has been created"
end

# Perform cleanup 
CryptoDashApp.remove_old_files()

################# Test cases for accessing market data #################

@testset "Check if AV market data are accessible" begin    

    for currency in ["ETH", "LTC", "LINK"]

        df_out_price, df_out_candle, df_out_vol = CryptoDashApp.get_price_data_single(currency)

        @test ~isempty(df_out_price)
        @test ~isempty(df_out_candle)
        @test ~isempty(df_out_vol)

    end

end

################# Test cases for moving averages #################

@testset "Check if MA, MACD and signal are calculated" begin

    for currency in ["BTC", "DOT"]

        df_out_price, _ , _ = CryptoDashApp.get_price_data_single(currency)

        duration = 90
        window = 30

        Price_SMA, Price_WMA, Price_EMA = CryptoDashApp.moving_averages(df_out_price, duration, window)

        @test ~isempty(Price_SMA)
        @test ~isempty(Price_WMA)
        @test ~isempty(Price_WMA)        

        df_out_price = df_out_price[end-duration+1-26-9+1:end, :]
        df_ema_all = CryptoDashApp.calculate_macd(df_out_price)

        @test ~isempty(df_ema_all)
        
    end
    
end

################# Test cases for CoinGecko API  #################

@testset "Check if CG developer and community data are accessible" begin    

    for currency in ["btc", "eth", "ltc"]

        df_dev, df_comm = CryptoDashApp.get_dev_comm_data(currency)        

        @test ~isempty(df_dev)
        @test ~isempty(df_comm)        

    end

end

@testset "Check if CG exchange volume data are accessible" begin    

    for currency in ["btc", "eth", "ltc"]

        df_ex_vol = CryptoDashApp.get_exchange_vol_data(currency, 10)

        @test ~isempty(df_ex_vol)        

    end

end

#=@testset "Check if ratings data is accessible" begin

    utility_score, fcas_score, dev_score, mark_score, fcas_rating = CryptoDashApp.get_ratings_data("ETH")

    @test ~isempty(utility_score)
    @test ~isempty(fcas_score)
    @test ~isempty(dev_score)
    @test ~isempty(mark_score)
    @test ~isempty(fcas_rating)
end=#





