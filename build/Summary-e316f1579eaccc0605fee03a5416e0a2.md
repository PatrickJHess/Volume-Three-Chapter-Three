# Chapter Summary
<br>

This chapter expands on the estimation of the term structure of interest rates by incorporating a broader dataset of Treasury bills, notes, and bonds. Building this model requires precise inputs for bond prices, payment amounts, and dates. To prepare the data, clean prices must be converted to dirty prices by factoring in accrued interest, and scheduled payment dates must be strictly aligned with settlement dates. From there, Ordinary Least Squares (OLS) is used to estimate zero-coupon prices, allowing us to calculate and visualize the resulting spot and forward rates.

Although computationally effective, OLS estimation is fundamentally a discrete statistical curve-fitting exercise that lacks underlying economic or financial reasoning. The next chapter addresses this limitation by introducing the Nelson-Siegel model. This framework yields a continuous term structure driven by actual yield curve dynamics—such as level, slope, and curvature—allowing us to accurately estimate rates for maturities well beyond the limits of our OLS data.




