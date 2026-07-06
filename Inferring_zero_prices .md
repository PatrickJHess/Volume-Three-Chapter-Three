# Inferring zero prices from the present value function 📉💸
<br>
The present value of a bond maturing in $T$ periods is:

$$\text{Bond Value} = \sum_{t=1}^{T-1}\text{PV}(t)\times \text{Coupon} + \text{PV}(T)\times (\text{Principal} + \text{Coupon})$$

where $\text{PV}(t)$ is the present value factor at time $t$. The present value factor at $T$ is solved for by rearranging the $\text{Bond Value}$ equation:

$$\text{PV}(T) = \frac{\text{Bond Value} - \sum_{t=1}^{T-1}\text{PV}(t)\times \text{Coupon}}{\text{Principal} + \text{Coupon}}$$

This formula allows for the recursive calculation of present value factors (zero prices), beginning with the shortest maturity and progressively solving for factors at longer maturity dates. 🔄🗓️

## **Two bond example: Recursive solution 🧮🔍**
Consider two bonds:A bond that pays $100 in six months and sells for $97.50.A bond that matures in one year, pays a semi-annual $2 coupon, and sells for $100.The present value factor for six months, $\text{PV}(0.5)$, is the ratio of the price to the final payment for the first bond:

$$\text{PV}(0.5) = \frac{97.5}{100} = 0.975$$

We can then use this six-month present value factor and the price of the one-year bond to infer the one-year present value factor, $\text{PV}(1)$. The one-year bond's price ($100) must equal the present value of its two cash flows: the first coupon ($2) and the final payment (coupon + principal = $102). 💵➕

$$100 = 2 \times \text{PV}(0.5) + 102 \times \text{PV}(1)$$

Solving for $\text{PV}(1)$:

$$\text{PV}(1) = \frac{100 - (0.975 \times 2)}{102} = 0.9613$$

One might initially think this recursive approach could be used to build the complete term structure. 🏗️ However, while straightforward, this method is not well-suited for reliably deducing the entire term structure from a set of bond prices. To understand why this approach is problematic and to develop a more effective method, we must first reframe the problem as a system of equations. 🧩 

## **Two bond example: As two equations and two unknowns ⚖️🔢**

Here we describe how to determine zero-coupon bond prices (or present value factors) using the prices and cash flows of one-period and two-period coupon bonds; a common technique in finance known as bootstrapping. 👢📊

The values of the two bonds are first expressed as a system of two linear equations:
1. $97.5 = 100 \times \text{PV}(0.5)$
2. $100 = 2 \times \text{PV}(0.5) + 102 \times \text{PV}(1)$
  
These equations can be represented in matrix form: 🔲

$$\text{Bond Values} = \text{Payoffs} \times \text{Zero Prices}$$

1. $\text{Bond Values} = \begin{pmatrix} 97.5 \\ 100 \end{pmatrix}$$\text{Payoffs} = \begin{pmatrix} 100 & 0 \\ 2 & 102 \end{pmatrix}$
2. $\text{Zero Prices} = \begin{pmatrix} \text{PV}(0.5) \\ \text{PV}(1) \end{pmatrix}$

Bringing it all together:

$$\begin{pmatrix} 97.5 \\ 100 \end{pmatrix} = \begin{pmatrix} 100 & 0 \\ 2 & 102 \end{pmatrix} \times \begin{pmatrix} \text{PV}(0.5) \\ \text{PV}(1) \end{pmatrix}$$

The goal is to solve for the $\text{Zero Prices}$ array. 🎯 Since the $\text{Payoffs}$ array is a square matrix, we can use its inverse to solve the system of equations. The inverse of the $\text{Payoffs}$ matrix is:

$$\text{Payoffs}^{-1} = \begin{pmatrix} 100 & 0 \\ 2 & 102 \end{pmatrix}^{-1} = \begin{pmatrix} \frac{1}{100} & 0 \\ \frac{-2}{100 \times 102} & \frac{1}{102} \end{pmatrix}$$

Which allows us to isolate and solve for our present value factors: ✅

$$\text{Zero Prices} = \text{Payoffs}^{-1} \times \text{Bond Values}$$