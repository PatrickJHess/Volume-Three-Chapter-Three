# ✨ Chapter Highlights
## Chapter Three: Bootstrapping Zero Prices With Ordinary Least Squares.
<br>

This chapter focuses on the mathematical methods and practical Python programming skills required to estimate zero prices from a sample of bonds and visualize the term structure of interest rates.

### **📈 Financial Concepts**
* Using the bond pricing formula

* Bond prices and zero prices (present value factors) as one-dimensional arrays

* Bond payoffs modeled as two-dimensional arrays

* Visualizing the term structure

### **🐍 Python Concepts**
* 🧮 NumPy arrays and the linalg module (matrix_rank, lstsq)

* 🗓️ Date manipulation using busday_offset and markets_calendars

* 🐼 Pandas DataFrames and the .apply() method

* 🧩 financial_quant package

#### **📚 Background & Prerequisites**
This chapter's examples and discussions rely heavily on the Pandas and NumPy libraries. The following introductory materials are recommended for context:


* *[**🐼 Pandas**: *A Quick Introduction to Pandas*](https://patrickjhess.github.io/Introduction-To-Python-For-Financial-Python/An_Introduction_To_Pandas.html#a-quick-introduction-to-pandas).  
* [**🔢 NumPy***: A Quick Introduction to NumPy*](https://patrickjhess.github.io/Introduction-To-Python-For-Financial-Python/An_Introduction_To_NumPy.html#a-quick-introduction-to-numpy).  
* [**📖 Foundations**: *Background Material: An Introduction to Python for Financial Python*](https://patrickjhess.github.io/Introduction-To-Python-For-Financial-Python/intro.html).

### **🗺️ Chapter Outline**

This chapter is divided into the following four distinct sections:

* **🧮 Inferring Zero Prices from the Present Value Function**: Demonstrates how to estimate zero prices or present value factors from a sample of bonds.

* **🗓️ Bond Payment Data (Jupyter Notebook)**: Calculates the actual payment dates and corresponding amounts for the bond data.

* **💻 Bootstrapping Zero Prices With FEDInvest Data (Jupyter Notebook)**: Downloads data from FEDInvest, calculates the payoff matrix and transaction prices, estimates zero prices using ordinary least squares, and graphs spot rates calculated from those estimated prices.

* **📦 Imported Functions**: describes the functions imported from financial_quant package.

