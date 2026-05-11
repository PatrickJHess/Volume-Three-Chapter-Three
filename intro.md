# Financial Python
# Basic Concepts Of Fixed Income-The Term Structure Of Interest Rates
### Chapter Three: Bootstrapping Zero Prices With Ordinary Least Squares

The "bootstrapping" method determines zero prices (or present value factors) using data from U.S. Treasury bills, notes and bonds.

Following the fundamental concept of Chapter One, the prices of coupon bonds are assumed to be equivalent to a matching portfolio of zero-coupon bonds. Because the dataset contains more bonds than distinct maturity dates, the bootstrapping process is optimized to minimize the sum of squared differences between the actual and forecasted prices of the coupon bonds.

Unlike the calculation of accrued interest, the estimates require  the exact as opposed to the scheduled payment dates.  The chapter  notebook Bond Payment Data transitions from scheduled to actual  payment dates and principal/coupon amounts to the actual payment dates and corresponding amounts.  The bond payment data is used to create payoff matrices that are used to estimate zero prices. 

The chapter notebook Bootstrapping Zero Prices With FEDInvest Data uses the bond payment data as the basis for estimating zero prices.

The payoff matrices serve as a linear algebraic representation of the bond portfolio, where each row corresponds to a specific bond and each column represents a future payment date. By multiplying this matrix by a vector of unknown zero prices, the model generates forecasted bond prices. The bootstrapping optimization then solves for the zero-price vector that best reconciles these forecasts with observed market prices.

This methodology provides a system for relative bond pricing. Assuming the bonds are traded at the observed transaction prices, discrepancies between observed transaction prices and the prices predicted by the bootstrapping estimates signal potential return-enhancing opportunities. Specifically, investors can increase holdings in bonds where the forecasted price exceeds the actual price and reduce positions where the forecasted price is less than the actual price.


Once these zero prices are determined for all relevant maturities, they are converted into spot rates. Plotting these rates against their respective time horizons provides a visualization of  the term structure of interest rates, or the yield curve. Because bond payment dates occur at discrete dates, the curve provides a first approximation of the term structure. The next chapter expands on these estimates providing a more detailed representation using interpolation methods, like a cubic spline, to create a smooth, continuous representation of the term structure from the discrete spot rates.



