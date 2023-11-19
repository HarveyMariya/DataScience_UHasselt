import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
from PIL import Image
import warnings
import datetime
warnings.filterwarnings('ignore')


# Set page configuration
st.set_page_config(
    page_title='Livlina Logistics Company',
    page_icon="🚚",  # Change to your desired logo
    layout='wide',
    initial_sidebar_state='expanded'
)

header_left, header_mid, header_right = st.columns([1, 6, 1])

# Header in the middle with logo
with header_mid:
    st.markdown(
        f'<style> .block-container{{padding-top: 1rem;}}</style>', unsafe_allow_html=True)
    image = Image.open("C:/Users/harve/Downloads/livlina_logistics_cover.jpeg")
    st.image(image, use_column_width=False)
    # st.title("Livlina Logistics Company")
    st.markdown('</p>', unsafe_allow_html=True)


# Load dataset
insert = st.file_uploader(":file_folder: Upload a file",
                          type=(["csv", "txt", "xlsx", "xls"]))
if insert is not None:
    filename = insert.name
    st.write(filename)
    data = pd.read_csv(filename)
else:
    # inbound_data = pd.read_csv("inbound_data.csv")
    outbound_data = pd.read_csv("outbound_data.csv")
    outbound_data['Order_date'] = pd.to_datetime(
        outbound_data['Order_date'], format='%d-%m-%Y').dt.strftime('%Y-%m-%d')


def load_data(zone):
    if zone == "Outbound":
        # return inbound_data
        # elif zone == "Outbound":
        return outbound_data
    else:
        return None


# Sidebar for zone selection
zone = st.sidebar.selectbox("Zone", ["Inbound", "Outbound"])

# Load data based on zone selection
selected_data = load_data(zone)

col1, col2 = st.columns((2))

# Assuming you have a selected_data variable
if selected_data is not None:
    # Check if "Order_date" column exists in selected_data
    if "Order_date" in selected_data.columns:
        selected_data['Order_date'] = pd.to_datetime(
            selected_data['Order_date'])
        start_date = selected_data['Order_date'].min()
        end_date = selected_data['Order_date'].max()

        with col1:
            date1 = pd.to_datetime(st.date_input("Start Date", start_date))

        with col2:
            date2 = pd.to_datetime(st.date_input("End Date", end_date))

        selected_data = selected_data[
            (selected_data["Order_date"] >= date1) & (selected_data["Order_date"] <= date2)].copy()
    else:
        st.warning("Selected data does not have the 'Order_date' column.")
else:
    st.warning("No data selected.")


# Function to generate exploratory plots


def generate_exploratory_plots(data, time_interval):
    with st.container():
        st.write(f"### {time_interval} View")

        if time_interval == "Daily":
            fig = px.line(data, x='Order_date', y='Total_Nb_Pallet',
                          title='Distribution of Workload over Time (Daily)')
        elif time_interval == "Weekly":
            fig = px.line(data, x='Week', y='Time(hrs)',
                          title='Distribution of Workload over Time (Weekly)')
        elif time_interval == "Monthly":
            fig = px.line(data, x='Month', y='Time(hrs)',
                          title='Distribution of Workload over Time (Monthly)')

        st.plotly_chart(fig)


# Function to generate prediction page content


def generate_predictions(data):
    # Here, you should use your trained model to generate predictions based on the data
    # This is just a placeholder example
    # Replace with your actual predictions
    predicted_workload = np.random.rand(len(data)) * 10
    return predicted_workload


def generate_prediction_page(data):
    st.write("### Prediction View")

    # Generate predictions using the placeholder function
    predicted_workload = generate_predictions(data)

    # Plot the predicted workload over time
    fig = px.line(x=data['Order_date'], y=predicted_workload,
                  title='Predicted Workload over Time')
    st.plotly_chart(fig)

    # Add any additional information or insights about the predictions
    st.write("Additional insights about the predictions:")
    # ...


# Home button
if st.sidebar.button("Home"):
    # Redirect to the main page or set the view variable accordingly
    view = st.write('<p style="font-weight:bold; font-size:24px; text-align:center;">Welcome, please select a zone you wish to explore and predict.</p>', unsafe_allow_html=True)


# Create columns for header
header_left, header_mid, header_right = st.columns([1, 6, 1])


# Navigation menu for different views
view = st.sidebar.selectbox("View", ["Overview", "Exploratory", "Prediction"])


# Overview View
if view == "Overview":
    with st.container():

        if selected_data is not None:
            st.write("### Overview of the selected Zone")

            # date_columns = st.columns(1)
            # with date_columns[0]:
            #     # start_date = st.date_input("From: ", datetime.date(2019, 7, 6))
            #     # end_date = st.date_input("To: ", datetime.date(2019, 7, 6))

            #     MIN_MAX_RANGE = (datetime.datetime(2022, 1, 1),
            #                      datetime.datetime(2023, 7, 1))
            #     PRE_SELECTED_DATES = (datetime.datetime(
            #         2023, 1, 1), datetime.datetime(2023, 7, 1))

            #     selected_min, selected_ax = st.slider(
            #         "Datetime slider",
            #         value=PRE_SELECTED_DATES,
            #         min_value=MIN_MAX_RANGE[0],
            #         max_value=MIN_MAX_RANGE[1],
            #     )
            # First Row: Metric Cards
            metric_columns = st.columns(3)

            # Metric 1: Average Number of Pallets
            with metric_columns[0]:
                avg_pallets = round(selected_data['Total_Nb_Pallet'].mean())
                # st.metric("Avg Pallets", avg_pallets)
                st.markdown(
                    f'<div style="background-color: #FFD700; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #000080;">Avg Pallets</h3>'
                    f'<p style="font-size: 24px;">{avg_pallets:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Metric 2: Average Number of Colli
            with metric_columns[1]:
                avg_colli = round(selected_data['Nb_of_colli'].mean())
                # st.metric("Avg Colli", avg_colli)
                st.markdown(
                    f'<div style="background-color: #800080; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #FFFFFF;">Avg Colli</h3>'
                    f'<p style="font-size: 24px; color: #FFFFFF;">{avg_colli:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Metric 3: Average Time(hr)
            with metric_columns[2]:
                avg_time = round(selected_data['Time(hrs)'].mean(), 2)
                # st.metric("Avg Workload(hr)", avg_time)
                st.markdown(
                    f'<div style="background-color: #00FA9A; padding: 20px; border-radius: 10px; text-align: center;">'
                    f'<h3 style="color: #000080;">Workload(hr)</h3>'
                    f'<p style="font-size: 24px;">{avg_time:.2f}</p>'
                    f'</div>',
                    unsafe_allow_html=True
                )

            # Add spacing
            st.markdown("<br><br>", unsafe_allow_html=True)

            metric_columns = st.columns(2)

            # Plot of Workload by Order_dates
            with metric_columns[0]:
                st.write("### Selected View")
                selected_data_sorted = selected_data.sort_values(
                    by='Order_date')
                fig = px.line(selected_data_sorted, x='Order_date', y='Time(hrs)',
                              title='Distribution of Workload over Time')
                st.plotly_chart(fig)

            # Plot of Order frequency
            with metric_columns[1]:
                st.write("### Order Frequency")
                # st.subheader("Bar Plot for Order Frequency")
                order_frequency_bar = px.bar(
                    selected_data, x='Order_frequency', title='Bar Plot for Order Frequency')
                st.plotly_chart(order_frequency_bar)

            metric_columns = st.columns(2)

            with metric_columns[0]:
                st.write("### Order Distribution")
                fig = px.pie(selected_data_sorted, values="Number_of_orders",
                             names="Order_frequency", hole=0.5)
                fig.update_traces(
                    text=selected_data_sorted["Order_frequency"], textposition="outside")
                st.plotly_chart(fig, use_container_width=True)

            with metric_columns[1]:
                st.write("### Subset of the Data")
                st.write(selected_data_sorted.style.background_gradient(
                    cmap="rainbow"))
                csv = selected_data_sorted.to_csv(index=False).encode('utf-8')
                st.download_button("Download Data", data=csv, file_name="Overview.csv", mime="text/csv",
                                   help="Click here to download the data as a CSV file")

            # else:
            #     st.write('<p style="font-weight:bold; font-size:24px; text-align:center;">Welcome, please select a zone you wish to explore and predict.</p>', unsafe_allow_html=True)


# Exploratory View
elif view == "Exploratory":
    with st.container():
        st.write("### Exploratory View")

        # Sidebar for exploratory controls
        menu = st.sidebar.selectbox(
            "Time Interval", ["Daily", "Weekly", "Monthly"])
        button_clicked = st.sidebar.button("Generate Exploratory Plots")

        # Content for each exploratory menu option
        if button_clicked:
            generate_exploratory_plots(selected_data, menu)

# Prediction View
elif view == "Prediction":
    generate_prediction_page(selected_data)
