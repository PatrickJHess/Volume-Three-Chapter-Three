# **Inferring zero prices from the present value function**

The present value of a bond maturing in T periods is:

$$\text{Bond Value} = \sum_{t=1}^{T-1}\text{PV(t)}\times \text{Coupon} + \text{PV(T)}\times (\text{Principal + Coupon})$$

<br>

where $\text{PV(t)}$ is the present value factor at time $t$. The present value factor at $T$ is solved for by rearranging the $\text{Bond Value}$ equation:

$$\large \text{PV(T)} = \frac{\text{Bond Value} - \sum_{t=1}^{T-1}\text{PV(t)}\times \text{Coupon}}{\text{Principal + Coupon}}$$

<br>

This formula allows for the recursive calculation of present value factors (zero prices), beginning with the shortest maturity and progressively solving for factors at longer maturity dates.

### **Two bond example-recursive solution**

Consider two bonds:

1. A bond that pays \$100 in six months and sells for \$97.50.  
2. A bond that matures in one year, pays a semi-annual \$2 coupon, and sells for $100.

The present value factor for six months, $\text{PV(0.5)}$, is the ratio of the price to the final payment for the first bond:

<br>

$$\text{PV(0.5)} =\frac{97.5}{100} = 0.975$$

<br>

We can then use this six-month present value factor and the price of the one-year bond to infer the one-year present value factor, $\text{PV(1)}$. The one-year bond's price (\$100) must equal the present value of its two cash flows: the first coupon (\$2) and the final payment $\text{(coupon + principal=\$102).}$

<br>

$$\$100 = 2 \times \text{PV}(0.5) + 102 \times \text{PV}(1)$$

Solving for $\text{PV(1)}$:

$$\text{PV}(1) = \frac{100 - (0.975 \times 2)}{102} = 0.9613$$

<br>

One might initially think this recursive approach could be used to build the complete term structure. However, while straightforward, this method is not well-suited for reliably deducing the entire term structure from a set of bond prices. To understand why this approach is problematic and to develop a more effective method, we must first reframe the problem as a system of equations.


### **Two bond example-as two equations and two unknowns**

Here we describe how to determine zero-coupon bond prices (or present value factors) using the prices and cash flows of one-period and two-period coupon bonds; a common technique in finance known as bootstrapping.

The values of the two bonds are first expressed as a system of two linear equations:

<br>

1.   $97.5 = 100\times \text{PV(0.5)}$
2.   $100 = 2\times \text{PV(0.5)} + 102\times \text{PV(1)}$

<br>

These equations can be represented in matrix form:

<br>

$\text{Bond Values} = \text{Payoffs} \times \text{Zero Prices}$

1.  $\text{Bond Values} =\begin{pmatrix}
97.5  \\
100  \\
\end{pmatrix}$

2.   $\text{Payoffs} \hspace{0.85cm}=\begin{pmatrix}
100 &0  \\
2 &102  \\
\end{pmatrix}$

3.   $\text{Zero Prices}\hspace{.35cm}=\begin{pmatrix}
PV(0.5)  \\
PV(1)  \\
\end{pmatrix}$


<br>

$\Large\begin{pmatrix}
97.5  \\
100  \\
\end{pmatrix}= \begin{pmatrix}
100 &0  \\
2 &102  \\
\end{pmatrix}
\times\begin{pmatrix}
PV(0.5)  \\
PV(1)  \\
\end{pmatrix}$

<br>
<br>

The goal is to solve for the $\text{Zero Prices}$ array. Since the $\text{Payoffs}$ array is a square matrix, we can use its inverse to solve the system of equations. The inverse of the $\text{Payoffs}$ matrix is:

<br>
<br>


$$\text{Zero Prices} = \text{Payoffs}^{-1} = \Large\begin{pmatrix}
100 &0  \\
2 &102  \\
\end{pmatrix}^{-1} = \begin{pmatrix}
\frac{1}{100} &0  \\
\frac{-2}{100\times 102} &\frac{1}{102}  \\
\end{pmatrix} $$


<br>
<br>
