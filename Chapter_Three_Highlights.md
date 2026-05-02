# ***Bootstrapping Zero Prices With Ordinary Least Squares***

**Key Topics Covered**

* **Using the bond pricing formula:**  
  * Bond prices as one-dimensional array  
  * Zero prices or present value factors as one-dimensional arrays  
  * Bond payoffs as two-dimensional arrays.  
  * Visualizing the term structure  
      
* **Python concepts:**  
  * NumPy arrays- especially the linalg module  
    * linalg function matrix\_rank  
    * linalg function lstsq  
    * busday\_offset  
  * Pandas DataFrames  
    * method apply  
    * markets|_calendars  
  * Custom modules.  
    * one\_y\_axis  
    * accrued\_interest  
    * bond\_pay\_data  
    * create\_payoff\_matrix  
    * FEDInvest  
    * clean\_FEDInvest

## ***Background***

This chapter's examples and discussions rely on the **Pandas and **NumPy** libraries.

* **Pandas** is introduced in [*A Quick Introduction to Pandas*](https://patrickjhess.github.io/Introduction-To-Python-For-Financial-Python/An_Introduction_To_Pandas.html#a-quick-introduction-to-pandas).  
* **NumPy** is introduced in [*A Quick Introduction to NumPy*](https://patrickjhess.github.io/Introduction-To-Python-For-Financial-Python/An_Introduction_To_NumPy.html#a-quick-introduction-to-numpy).  
* Additional relevant Python concepts can be found in the introductory volume, [*Background Material: An Introduction to Python for Financial Python*](https://patrickjhess.github.io/Introduction-To-Python-For-Financial-Python/intro.html), that relate to this and other chapters of *Basic Concepts of Fixed Income*.

**The chapter includes four  sections:**

1. *Inferring zero prices from the present value function*  demonstrates how to estimate zero prices or present value factors from a sample of bonds.  
2. The  Jupyter notebook *Bond Payment Data* that calculates the actual payment dates and amounts.  
3. The  Jupyter notebook *Bootstrapping Zero Prices With FEDInvest Data*  
   * downloads data from FREDInvest..  
   * calculate the payoff matrix.  
   * calculates transaction prices  
   * estimates zero prices with ordinary least squares  
   * graphs spot rates calculated from the estimated spot prices  
4. *Functions Imported by Bootstrapping The Terms Structure of Interest Rates*  describes the function imported from DropBox (*module\_basic\_concepts\_fixed\_income*).

