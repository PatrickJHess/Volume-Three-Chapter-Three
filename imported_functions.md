# Functions Imported by the Chapter.

::::{dropdown} 🔍 View the helper functions of the Chapter

:::{dropdown} Click to see `adjust_bond_pay_dates`

```py
def adjust_bond_pay_dates(dates,calendar='SIFMAUS'):
  """
  Adjusts bond payment dates to account for holidays and weekends.
  dates can be a scalar, pandas series, or numpy array (datetime.date,timestamp, or datetime64)
  """

  import pandas as pd
  import numpy as np
  import pandas_market_calendars as mcal
  from pandas.tseries.holiday import GoodFriday

  # Ensure dates is a DatetimeIndex
  if not pd.api.types.is_scalar(dates):
      dates = pd.DatetimeIndex(pd.to_datetime(dates))
  else:
      dates = pd.DatetimeIndex(pd.to_datetime([dates]))

  sifma = mcal.get_calendar(calendar)
  sifma_holidays = sifma.holidays().holidays
  good_fridays = GoodFriday.dates('2000-01-01', '2060-12-31')

  # Convert to DatetimeIndex and use .union() (which automatically deduplicates and sorts)
  sifma_idx = pd.DatetimeIndex(sifma_holidays)
  gf_idx = pd.DatetimeIndex(good_fridays)
  master_bond_holidays = sifma_idx.union(gf_idx)

  # Create a CustomBusinessDay offset using the combined holidays
  numpy_holidays = master_bond_holidays.values.astype('datetime64[D]')

  # Use NumPy for lightning-fast, fully vectorized date math (No warnings!)
  actual_payment_dates = np.busday_offset(
      dates.values.astype('datetime64[D]'),
      offsets=0,
      roll='forward',
      holidays=numpy_holidays
  )

  final_dates = pd.to_datetime(actual_payment_dates).date

  return final_dates 
```
:::

:::{dropdown} Click to see `bond_pay_data`

```py
def bond_pay_data(maturity, coupon, settlement=None, freq=2):
    '''
    Function calculates payment Dates And Amounts.
    maturity is a datetime object and coupon is a real number.
    Required arguments are maturity and annual coupon.
    If provided, the value of settlement is a datetime object;
    otherwise defaults to date.today()
    freq defaults to semi-annual but accepts freq equal
    to 1 for annual, 2 for semi-annal, 4 for quarterly, and 12 for monthly.
    The function assumes a par value of 100.
    Returns Numpy arrays of dates and amounts.

    Raises:
        TypeError: If maturity or settlement are not datetime objects.
        ValueError: If inputs are not logically valid (e.g., negative coupon,
                    maturity before settlement).
    '''
    from datetime import datetime, date
    from dateutil.relativedelta import relativedelta
    import pandas as pd
    import numpy as np
    from IPython.display import display, Markdown as md

    # Validate the data - maturity, coupon, settlement, freq
    def validate_date(datetime_object):
        # check for datetime or date
        if not isinstance(datetime_object, (datetime, date)):
            raise TypeError("Input must be a datetime or date object.")
        # convert datetime to date
        if isinstance(datetime_object, datetime):
            datetime_object = datetime_object.date()
        return datetime_object

    # maturity
    maturity = validate_date(maturity)

    # settlement
    if settlement is None:
        settlement = date.today()
    else:
        settlement = validate_date(settlement)

    # coupon
    try:
        coupon = float(coupon)
        if coupon < 0:
            raise ValueError("coupon rate cannot be negative.")
    except (ValueError, TypeError):
        raise ValueError("coupon must be a valid number.")

    # freq
    if int(freq) not in [1, 2, 4, 12]:
        display(md(f"### ⚠️ your assigned freq {freq} it must be (1, 2, 4, or 12)\n ### semi-annual assumed (2)."))
        freq = int(2)

    # check maturity greater than settlement
    if maturity <= settlement:
        raise ValueError("maturity must be greater than the settlement date")

    if coupon == 0:
        # Adjust maturity for non-settlement day and return date and face value
        adjust_maturity = adjust_bond_pay_dates(maturity)
        return np.array([adjust_maturity['Settlement'].dt.date]), np.array([100.0])

    # get scheduled payment dates from helper function scheduled_pay_dates
    scheduled_dates = scheduled_pay_dates(maturity, settlement, freq)

    # Pandas DataFrame Settlement desired column
    both_dates = adjust_bond_pay_dates(scheduled_dates)
    pay_dates=np.array(both_dates['Settlement'].dt.date)
    # calculate payments
    # coupon divided by freq at each date
    pay = np.full(len(pay_dates), coupon / freq)

    # Add principal payment as last cash payment
    pay[-1] += 100

    return pay_dates,pay
```
:::

:::{dropdown} Click to see `create_payoff_df`

```py
def create_payoff_df(df, settlement,OLS=False):
    adjusted_maturities = adjust_bond_pay_dates(list(df.index))
    all_maturities = set(adjusted_maturities)

    df_payoff_columns = sorted(all_maturities)
    df_payoff_index=[i for i in range(len(df.index))]

    df_payoff = pd.DataFrame(
        np.zeros((len(df), len(df_payoff_columns))),
        columns=df_payoff_columns,
        index=df_payoff_index
    )
    total_rows = len(df)
    # Define a clean, pleasing HTML template for our status box
    def status_box(current, total):
        return f"""
        <div style="font-family: Arial, sans-serif; padding: 10px 15px; background-color: #f8f9fa; 
                    border-left: 4px solid #007bff; border-radius: 4px; width: fit-content; color: #333;">
            <b style="color: #007bff;">⚙️ Processing Bonds:</b> {current} of {total} added to DataFrame
        </div>
        """
    
    # initial display showing 0 bonds added
    progress_ui = display(HTML(status_box(0, total_rows)), display_id=True)

    for index,(maturity, coupon) in enumerate(zip(df.index, df['Coupon'])):

        # bond_pay_data returns payment dates and amounts
        row_pay_data = bond_pay_data(maturity, coupon, settlement=settlement)

        # Find any dates that aren't already columns
        new_dates = set(row_pay_data[0].flatten()) - all_maturities

        if new_dates:
          if OLS:
            df_clean = df_payoff.loc[(df_payoff != 0).any(axis=1),
                                         (df_payoff != 0).any(axis=0)]
            print("✅ DataFrame Complete (Exited Early)!")
            return df_clean
          else:
            # ✅ FIX: Add new dates to our master set and reindex
            all_maturities.update(new_dates)
            df_payoff = df_payoff.reindex(columns=sorted(all_maturities), fill_value=0.0)
 
        #    fill up the columns
        df_payoff.loc[index, row_pay_data[0]] = row_pay_data[1]
         # update the progress bar
        progress_ui.update(HTML(status_box(index + 1, total_rows)))
    # re-sort the columns so dates are chronological
    df_payoff = df_payoff.reindex(sorted(df_payoff.columns), axis=1)
    progress_ui.update(HTML("""
        <div style="font-family: Arial, sans-serif; padding: 10px 15px; background-color: #e6f4ea; 
                    border-left: 4px solid #34a853; border-radius: 4px; width: fit-content; color: #137333;">
            <b>✅ DataFrame Complete!</b> All bonds added successfully.
            </div>
            """))
    return df_payoff
```
:::


:::{dropdown} Click to see `FEDInvest`

```py
def FEDInvest(price_date):
  """
    Fetches historical security prices from the FedInvest portal.

    Args:
        price_date (datetime.date): The date for which to retrieve prices.
            Note: Current day is typically available after 1:00 PM ET on business days.


    Returns:
        tuple: (pandas.DataFrame, str) if successful. The DataFrame contains
               security details (CUSIP, Price, Yield), and the string is the
               official "Prices For" date stamp from the site.
        tuple: (str, None) if the request fails or no data is found for the date
                (attempt to fetch current day before 1:00 PM ET).

    Example:
        >>> from datetime import date
        >>> df, stamp = FEDInvest(date(2025, 3, 17))
  """
  import requests
  from io import StringIO
  import pandas as pd
  from datetime import datetime, date
  from dateutil.relativedelta import relativedelta

  # check for date or datetime
  validate_date(price_date)

  # make share date of prices and settlement date are settlement dates
  price_date=adjust_bond_pay_dates(price_date)
  if price_date > date.today():
    return "price_date is in the future", None, None
  
  settlement_date=price_date+relativedelta(days=1)
  settlement_date=adjust_bond_pay_dates(settlement_date)

  # URL address of Treasury Direct Select A Date
  url = "https://treasurydirect.gov/GA-FI/FedInvest/selectSecurityPriceDate"

  # Standard headers to look like a real browser
  headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\
     (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Content-Type": "application/x-www-form-urlencoded"
  }

  #  variable names and type identified from inspecting url
  month=str(price_date.month)
  day=str(price_date.day)
  year=str(price_date.year)

  # payload passed in request post
  payload={'priceDate.month':month,
           'priceDate.day':day,
           'priceDate.year':year,
           "submit": "Show Prices"}

  # fires off form and returns prices for date
  try:
        response = requests.post(url, data=payload, headers=headers, timeout=10)
        response.raise_for_status()
  except requests.exceptions.RequestException as e:
        return f"Connection Error: {e}", None

  # reads the html
  # Pandas recommends to wrap the response in StingIO to make file like
  tables=pd.read_html(StringIO(response.text),match='CUSIP')

  # from inspection there is a single table
  return tables[0], price_date,settlement_date
```
:::

:::{dropdown} Click to see `clean_FEDInvest`

```py
def clean_FEDInvest(df):

    import pandas as pd
    # Filters for Standard Securities
    keep_rows=df['SECURITY TYPE'].str.contains('bill|note|bond',case=False)
    security_df=df[keep_rows].copy()
 
    # Removes Clutter
    drop_columns=['CUSIP','CALL DATE']
    security_df.drop(columns=drop_columns,inplace=True)

    # Creates a Time-Series Index
    security_df.set_index('MATURITY DATE',inplace=True)
    security_df.index=pd.to_datetime(security_df.index)
    security_df.sort_index(inplace=True)

    # Standardizes Financial Terms
    change_column_names={'RATE':'Coupon',
                         'BUY':'Price Ask',
                         'SELL':'Price Bid'}
    security_df.rename(columns=change_column_names,inplace=True)

    # Formats Numeric Data
    numeric_cols = ['Coupon', 'Price Ask', 'Price Bid', 'YIELD']
    for col in numeric_cols:
        if col in security_df.columns:
            security_df[col] = security_df[col].astype(str).str.replace('%', '', regex=False).astype(float)

    return security_df
```
:::

:::{dropdown} Click to see `one_y_axis`

```py
 def one_y_axis(x_data, y_data_list, title, series_labels, xlabel, ylabel,
                       markers, figure_size, y_limits,save_config={}, fill_config={},
                       colors=None):
    Args:
        x_data (array-like): Data for the x-axis.
        y_data_list (list of array-like): A list of datasets for the y-axis.
        title (str): The title of the graph.
        series_labels (list of str): Identifiers for each data series in the legend.
        xlabel (str): The label for the x-axis.
        ylabel (str): The label for the y-axis.
        markers (list of str): The markers to use for each series.
        figure_size (tuple): The width and height of the figure in inches.
        y_limits (tuple): The minimum and maximum values for the y-axis.
        save_config (dict, optional): Configuration for saving the file, passed
            to save_results(). Keys: 'volume', 'chapter', 'file_name'. Defaults to {}.
        fill_config (dict, optional): Configuration for filling areas.
            Keys: 'Between' (list of 1 or 2 indices from y_data_list),
                  'Start' (int, start index), 'End' (int, end index),
                  'Colors' (str), 'Labels' (str), 'Alpha' (float).
            Defaults to {}.
    Raises:
        ValueError: If input lists for series, markers, or colors do not match the number of y-datasets.
    '''
    import numpy as np
    from matplotlib import pyplot as plt
    num_series = len(y_data_list)
    # --- Input Validation ---
    if not all(len(lst) == num_series for lst in [series_labels, markers]):
        raise ValueError("The 'series_labels' and 'markers' lists must have the same length as 'y_data_list'.")

    if colors and len(colors) != num_series:
        raise ValueError("The 'colors' list must have the same length as 'y_data_list'.")

    # --- Plotting Setup ---
    fig = plt.figure(figsize=figure_size)
    fig.suptitle(title)
    plt.style.use('ggplot')

    if colors is None:
        # Generate a default color cycle if none are provided
        colors = plt.cm.viridis_r(np.linspace(0, 1, num_series))

# --- Plot Data Series ---
    for i in range(num_series):
        plt.plot(x_data, y_data_list[i], label=series_labels[i], marker=markers[i], color=colors[i])

    # --- Handle Fill Area ---
    if fill_config.get('Between'):
        if len(fill_config['Between']) > 2:
            raise ValueError("The 'Between' key in fill_config can contain a maximum of two indices.")


        # Get values from fill_config dict, providing safe defaults
        start = fill_config.get('Start', 0)
        end = fill_config.get('End', len(x_data))
        alpha = fill_config.get('Alpha', 0.3)
        color = fill_config.get('Colors', 'gray')
        label = fill_config.get('Labels', None) # 'None' won't create a legend item

        if len(fill_config['Between']) == 2:
            y1_index, y2_index = fill_config['Between']
            plt.fill_between(x_data[start:end],
                             y_data_list[y1_index][start:end],
                             y_data_list[y2_index][start:end],
                             color=color, alpha=alpha, label=label)
        else:
            y_index = fill_config['Between'][0]
            # Fills between the series and y=0
            plt.fill_between(x_data[start:end],
                             y_data_list[y_index][start:end],
                             color=color, alpha=alpha, label=label)

    # --- Final Touches ---
    plt.ylim(y_limits)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.legend()
    plt.tight_layout()

    # --- Save Figure ---
    # Calls the save_results function (assumed to be defined)
    path = save_results(save_config=save_config)
    if path:
      plt.savefig(path, dpi=300, bbox_inches='tight')

    plt.show()
```

:::
::::
